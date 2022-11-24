package queryrange

import (
	"context"
	"fmt"
	"runtime"
	"strconv"
	"sync"
	"testing"
	"time"

	"github.com/cortexproject/cortex/pkg/querier/queryrange"
	"github.com/stretchr/testify/require"
	"github.com/weaveworks/common/user"

	"github.com/credativ/vali/pkg/loghttp"
	"github.com/credativ/vali/pkg/logproto"
)

var nilMetrics = NewSplitByMetrics(nil)

func Test_splitQuery(t *testing.T) {
	tests := []struct {
		name     string
		req      queryrange.Request
		interval time.Duration
		want     []queryrange.Request
	}{
		{
			"smaller request than interval",
			&ValiRequest{
				StartTs: time.Date(2019, 12, 9, 12, 0, 0, 1, time.UTC),
				EndTs:   time.Date(2019, 12, 9, 12, 30, 0, 0, time.UTC),
			},
			time.Hour,
			[]queryrange.Request{
				&ValiRequest{
					StartTs: time.Date(2019, 12, 9, 12, 0, 0, 1, time.UTC),
					EndTs:   time.Date(2019, 12, 9, 12, 30, 0, 0, time.UTC),
				},
			},
		},
		{
			"exactly 1 interval",
			&ValiRequest{
				StartTs: time.Date(2019, 12, 9, 12, 1, 0, 0, time.UTC),
				EndTs:   time.Date(2019, 12, 9, 13, 1, 0, 0, time.UTC),
			},
			time.Hour,
			[]queryrange.Request{
				&ValiRequest{
					StartTs: time.Date(2019, 12, 9, 12, 1, 0, 0, time.UTC),
					EndTs:   time.Date(2019, 12, 9, 13, 1, 0, 0, time.UTC),
				},
			},
		},
		{
			"2 intervals",
			&ValiRequest{
				StartTs: time.Date(2019, 12, 9, 12, 0, 0, 1, time.UTC),
				EndTs:   time.Date(2019, 12, 9, 13, 0, 0, 2, time.UTC),
			},
			time.Hour,
			[]queryrange.Request{
				&ValiRequest{
					StartTs: time.Date(2019, 12, 9, 12, 0, 0, 1, time.UTC),
					EndTs:   time.Date(2019, 12, 9, 13, 0, 0, 1, time.UTC),
				},
				&ValiRequest{
					StartTs: time.Date(2019, 12, 9, 13, 0, 0, 1, time.UTC),
					EndTs:   time.Date(2019, 12, 9, 13, 0, 0, 2, time.UTC),
				},
			},
		},
		{
			"3 intervals series",
			&ValiSeriesRequest{
				StartTs: time.Date(2019, 12, 9, 12, 0, 0, 1, time.UTC),
				EndTs:   time.Date(2019, 12, 9, 16, 0, 0, 2, time.UTC),
			},
			2 * time.Hour,
			[]queryrange.Request{
				&ValiSeriesRequest{
					StartTs: time.Date(2019, 12, 9, 12, 0, 0, 1, time.UTC),
					EndTs:   time.Date(2019, 12, 9, 14, 0, 0, 1, time.UTC),
				},
				&ValiSeriesRequest{
					StartTs: time.Date(2019, 12, 9, 14, 0, 0, 1, time.UTC),
					EndTs:   time.Date(2019, 12, 9, 16, 0, 0, 1, time.UTC),
				},
				&ValiSeriesRequest{
					StartTs: time.Date(2019, 12, 9, 16, 0, 0, 1, time.UTC),
					EndTs:   time.Date(2019, 12, 9, 16, 0, 0, 2, time.UTC),
				},
			},
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			require.Equal(t, tt.want, splitByTime(tt.req, tt.interval))
		})
	}
}

func Test_splitMetricQuery(t *testing.T) {
	const seconds = 1e3 // 1e3 milliseconds per second.

	for i, tc := range []struct {
		input    queryrange.Request
		expected []queryrange.Request
		interval time.Duration
	}{
		// the step is lower than the interval therefore we should split only once.
		{
			input: &ValiRequest{
				StartTs: time.Unix(0, 0),
				EndTs:   time.Unix(0, 60*time.Minute.Nanoseconds()),
				Step:    15 * seconds,
			},
			expected: []queryrange.Request{
				&ValiRequest{
					StartTs: time.Unix(0, 0),
					EndTs:   time.Unix(0, 60*time.Minute.Nanoseconds()),
					Step:    15 * seconds,
				},
			},
			interval: 24 * time.Hour,
		},
		{
			input: &ValiRequest{
				StartTs: time.Unix(0, 0),
				EndTs:   time.Unix(60*60, 0),
				Step:    15 * seconds,
			},
			expected: []queryrange.Request{
				&ValiRequest{
					StartTs: time.Unix(0, 0),
					EndTs:   time.Unix(60*60, 0),
					Step:    15 * seconds,
				},
			},
			interval: 3 * time.Hour,
		},
		{
			input: &ValiRequest{
				StartTs: time.Unix(0, 0),
				EndTs:   time.Unix(24*3600, 0),
				Step:    15 * seconds,
			},
			expected: []queryrange.Request{
				&ValiRequest{
					StartTs: time.Unix(0, 0),
					EndTs:   time.Unix(24*3600, 0),
					Step:    15 * seconds,
				},
			},
			interval: 24 * time.Hour,
		},
		{
			input: &ValiRequest{
				StartTs: time.Unix(0, 0),
				EndTs:   time.Unix(3*3600, 0),
				Step:    15 * seconds,
			},
			expected: []queryrange.Request{
				&ValiRequest{
					StartTs: time.Unix(0, 0),
					EndTs:   time.Unix(3*3600, 0),
					Step:    15 * seconds,
				},
			},
			interval: 3 * time.Hour,
		},
		{
			input: &ValiRequest{
				StartTs: time.Unix(0, 0),
				EndTs:   time.Unix(2*24*3600, 0),
				Step:    15 * seconds,
			},
			expected: []queryrange.Request{
				&ValiRequest{
					StartTs: time.Unix(0, 0),
					EndTs:   time.Unix((24*3600)-15, 0),
					Step:    15 * seconds,
				},
				&ValiRequest{
					StartTs: time.Unix((24 * 3600), 0),
					EndTs:   time.Unix((2 * 24 * 3600), 0),
					Step:    15 * seconds,
				},
			},
			interval: 24 * time.Hour,
		},
		{
			input: &ValiRequest{
				StartTs: time.Unix(0, 0),
				EndTs:   time.Unix(2*3*3600, 0),
				Step:    15 * seconds,
			},
			expected: []queryrange.Request{
				&ValiRequest{
					StartTs: time.Unix(0, 0),
					EndTs:   time.Unix((3*3600)-15, 0),
					Step:    15 * seconds,
				},
				&ValiRequest{
					StartTs: time.Unix((3 * 3600), 0),
					EndTs:   time.Unix((2 * 3 * 3600), 0),
					Step:    15 * seconds,
				},
			},
			interval: 3 * time.Hour,
		},
		{
			input: &ValiRequest{
				StartTs: time.Unix(3*3600, 0),
				EndTs:   time.Unix(3*24*3600, 0),
				Step:    15 * seconds,
			},
			expected: []queryrange.Request{
				&ValiRequest{
					StartTs: time.Unix(3*3600, 0),
					EndTs:   time.Unix((24*3600)-15, 0),
					Step:    15 * seconds,
				},
				&ValiRequest{
					StartTs: time.Unix(24*3600, 0),
					EndTs:   time.Unix((2*24*3600)-15, 0),
					Step:    15 * seconds,
				},
				&ValiRequest{
					StartTs: time.Unix(2*24*3600, 0),
					EndTs:   time.Unix(3*24*3600, 0),
					Step:    15 * seconds,
				},
			},
			interval: 24 * time.Hour,
		},
		{
			input: &ValiRequest{
				StartTs: time.Unix(2*3600, 0),
				EndTs:   time.Unix(3*3*3600, 0),
				Step:    15 * seconds,
			},
			expected: []queryrange.Request{
				&ValiRequest{
					StartTs: time.Unix(2*3600, 0),
					EndTs:   time.Unix((3*3600)-15, 0),
					Step:    15 * seconds,
				},
				&ValiRequest{
					StartTs: time.Unix(3*3600, 0),
					EndTs:   time.Unix((2*3*3600)-15, 0),
					Step:    15 * seconds,
				},
				&ValiRequest{
					StartTs: time.Unix(2*3*3600, 0),
					EndTs:   time.Unix(3*3*3600, 0),
					Step:    15 * seconds,
				},
			},
			interval: 3 * time.Hour,
		},
	} {
		t.Run(strconv.Itoa(i), func(t *testing.T) {
			splits := splitMetricByTime(tc.input, tc.interval)
			require.Equal(t, tc.expected, splits)
		})
	}
}

func Test_splitByInterval_Do(t *testing.T) {
	ctx := user.InjectOrgID(context.Background(), "1")
	next := queryrange.HandlerFunc(func(_ context.Context, r queryrange.Request) (queryrange.Response, error) {
		return &ValiResponse{
			Status:    loghttp.QueryStatusSuccess,
			Direction: r.(*ValiRequest).Direction,
			Limit:     r.(*ValiRequest).Limit,
			Version:   uint32(loghttp.VersionV1),
			Data: ValiData{
				ResultType: loghttp.ResultTypeStream,
				Result: []logproto.Stream{
					{
						Labels: `{foo="bar", level="debug"}`,
						Entries: []logproto.Entry{

							{Timestamp: time.Unix(0, r.(*ValiRequest).StartTs.UnixNano()), Line: fmt.Sprintf("%d", r.(*ValiRequest).StartTs.UnixNano())},
						},
					},
				},
			},
		}, nil
	})

	l := WithDefaultLimits(fakeLimits{}, queryrange.Config{SplitQueriesByInterval: time.Hour})
	split := SplitByIntervalMiddleware(
		l,
		valiCodec,
		splitByTime,
		nilMetrics,
	).Wrap(next)

	tests := []struct {
		name string
		req  *ValiRequest
		want *ValiResponse
	}{
		{
			"backward",
			&ValiRequest{
				StartTs:   time.Unix(0, 0),
				EndTs:     time.Unix(0, (4 * time.Hour).Nanoseconds()),
				Query:     "",
				Limit:     1000,
				Step:      1,
				Direction: logproto.BACKWARD,
				Path:      "/api/prom/query_range",
			},
			&ValiResponse{
				Status:    loghttp.QueryStatusSuccess,
				Direction: logproto.BACKWARD,
				Limit:     1000,
				Version:   1,
				Data: ValiData{
					ResultType: loghttp.ResultTypeStream,
					Result: []logproto.Stream{
						{
							Labels: `{foo="bar", level="debug"}`,
							Entries: []logproto.Entry{
								{Timestamp: time.Unix(0, 3*time.Hour.Nanoseconds()), Line: fmt.Sprintf("%d", 3*time.Hour.Nanoseconds())},
								{Timestamp: time.Unix(0, 2*time.Hour.Nanoseconds()), Line: fmt.Sprintf("%d", 2*time.Hour.Nanoseconds())},
								{Timestamp: time.Unix(0, time.Hour.Nanoseconds()), Line: fmt.Sprintf("%d", time.Hour.Nanoseconds())},
								{Timestamp: time.Unix(0, 0), Line: fmt.Sprintf("%d", 0)},
							},
						},
					},
				},
			},
		},
		{
			"forward",
			&ValiRequest{
				StartTs:   time.Unix(0, 0),
				EndTs:     time.Unix(0, (4 * time.Hour).Nanoseconds()),
				Query:     "",
				Limit:     1000,
				Step:      1,
				Direction: logproto.FORWARD,
				Path:      "/api/prom/query_range",
			},
			&ValiResponse{
				Status:    loghttp.QueryStatusSuccess,
				Direction: logproto.FORWARD,
				Limit:     1000,
				Version:   1,
				Data: ValiData{
					ResultType: loghttp.ResultTypeStream,
					Result: []logproto.Stream{
						{
							Labels: `{foo="bar", level="debug"}`,
							Entries: []logproto.Entry{
								{Timestamp: time.Unix(0, 0), Line: fmt.Sprintf("%d", 0)},
								{Timestamp: time.Unix(0, time.Hour.Nanoseconds()), Line: fmt.Sprintf("%d", time.Hour.Nanoseconds())},
								{Timestamp: time.Unix(0, 2*time.Hour.Nanoseconds()), Line: fmt.Sprintf("%d", 2*time.Hour.Nanoseconds())},
								{Timestamp: time.Unix(0, 3*time.Hour.Nanoseconds()), Line: fmt.Sprintf("%d", 3*time.Hour.Nanoseconds())},
							},
						},
					},
				},
			},
		},
		{
			"forward limited",
			&ValiRequest{
				StartTs:   time.Unix(0, 0),
				EndTs:     time.Unix(0, (4 * time.Hour).Nanoseconds()),
				Query:     "",
				Limit:     2,
				Step:      1,
				Direction: logproto.FORWARD,
				Path:      "/api/prom/query_range",
			},
			&ValiResponse{
				Status:    loghttp.QueryStatusSuccess,
				Direction: logproto.FORWARD,
				Limit:     2,
				Version:   1,
				Data: ValiData{
					ResultType: loghttp.ResultTypeStream,
					Result: []logproto.Stream{
						{
							Labels: `{foo="bar", level="debug"}`,
							Entries: []logproto.Entry{
								{Timestamp: time.Unix(0, 0), Line: fmt.Sprintf("%d", 0)},
								{Timestamp: time.Unix(0, time.Hour.Nanoseconds()), Line: fmt.Sprintf("%d", time.Hour.Nanoseconds())},
							},
						},
					},
				},
			},
		},
		{
			"backward limited",
			&ValiRequest{
				StartTs:   time.Unix(0, 0),
				EndTs:     time.Unix(0, (4 * time.Hour).Nanoseconds()),
				Query:     "",
				Limit:     2,
				Step:      1,
				Direction: logproto.BACKWARD,
				Path:      "/api/prom/query_range",
			},
			&ValiResponse{
				Status:    loghttp.QueryStatusSuccess,
				Direction: logproto.BACKWARD,
				Limit:     2,
				Version:   1,
				Data: ValiData{
					ResultType: loghttp.ResultTypeStream,
					Result: []logproto.Stream{
						{
							Labels: `{foo="bar", level="debug"}`,
							Entries: []logproto.Entry{
								{Timestamp: time.Unix(0, 3*time.Hour.Nanoseconds()), Line: fmt.Sprintf("%d", 3*time.Hour.Nanoseconds())},
								{Timestamp: time.Unix(0, 2*time.Hour.Nanoseconds()), Line: fmt.Sprintf("%d", 2*time.Hour.Nanoseconds())},
							},
						},
					},
				},
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			res, err := split.Do(ctx, tt.req)
			require.NoError(t, err)
			require.Equal(t, tt.want, res)
		})
	}
}

func Test_series_splitByInterval_Do(t *testing.T) {
	ctx := user.InjectOrgID(context.Background(), "1")
	next := queryrange.HandlerFunc(func(_ context.Context, r queryrange.Request) (queryrange.Response, error) {
		return &ValiSeriesResponse{
			Status:  "success",
			Version: uint32(loghttp.VersionV1),
			Data: []logproto.SeriesIdentifier{
				{
					Labels: map[string]string{"filename": "/var/hostlog/apport.log", "job": "varlogs"},
				},
				{
					Labels: map[string]string{"filename": "/var/hostlog/test.log", "job": "varlogs"},
				},
				{
					Labels: map[string]string{"filename": "/var/hostlog/test.log", "job": "varlogs"},
				},
			},
		}, nil
	})

	l := WithDefaultLimits(fakeLimits{}, queryrange.Config{SplitQueriesByInterval: time.Hour})
	split := SplitByIntervalMiddleware(
		l,
		valiCodec,
		splitByTime,
		nilMetrics,
	).Wrap(next)

	tests := []struct {
		name string
		req  *ValiSeriesRequest
		want *ValiSeriesResponse
	}{
		{
			"backward",
			&ValiSeriesRequest{
				StartTs: time.Unix(0, 0),
				EndTs:   time.Unix(0, (4 * time.Hour).Nanoseconds()),
				Match:   []string{`{job="varlogs"}`},
				Path:    "/vali/api/v1/series",
			},
			&ValiSeriesResponse{
				Status:  "success",
				Version: 1,
				Data: []logproto.SeriesIdentifier{
					{
						Labels: map[string]string{"filename": "/var/hostlog/apport.log", "job": "varlogs"},
					},
					{
						Labels: map[string]string{"filename": "/var/hostlog/test.log", "job": "varlogs"},
					},
				},
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			res, err := split.Do(ctx, tt.req)
			require.NoError(t, err)
			require.Equal(t, tt.want, res)
		})
	}
}

func Test_ExitEarly(t *testing.T) {
	ctx := user.InjectOrgID(context.Background(), "1")

	var callCt int
	var mtx sync.Mutex

	next := queryrange.HandlerFunc(func(_ context.Context, r queryrange.Request) (queryrange.Response, error) {
		time.Sleep(time.Millisecond) // artificial delay to minimize race condition exposure in test

		mtx.Lock()
		defer mtx.Unlock()
		callCt++

		return &ValiResponse{
			Status:    loghttp.QueryStatusSuccess,
			Direction: r.(*ValiRequest).Direction,
			Limit:     r.(*ValiRequest).Limit,
			Version:   uint32(loghttp.VersionV1),
			Data: ValiData{
				ResultType: loghttp.ResultTypeStream,
				Result: []logproto.Stream{
					{
						Labels: `{foo="bar", level="debug"}`,
						Entries: []logproto.Entry{

							{
								Timestamp: time.Unix(0, r.(*ValiRequest).StartTs.UnixNano()),
								Line:      fmt.Sprintf("%d", r.(*ValiRequest).StartTs.UnixNano()),
							},
						},
					},
				},
			},
		}, nil
	})

	l := WithDefaultLimits(fakeLimits{}, queryrange.Config{SplitQueriesByInterval: time.Hour})
	split := SplitByIntervalMiddleware(
		l,
		valiCodec,
		splitByTime,
		nilMetrics,
	).Wrap(next)

	req := &ValiRequest{
		StartTs:   time.Unix(0, 0),
		EndTs:     time.Unix(0, (4 * time.Hour).Nanoseconds()),
		Query:     "",
		Limit:     2,
		Step:      1,
		Direction: logproto.FORWARD,
		Path:      "/api/prom/query_range",
	}

	expected := &ValiResponse{
		Status:    loghttp.QueryStatusSuccess,
		Direction: logproto.FORWARD,
		Limit:     2,
		Version:   1,
		Data: ValiData{
			ResultType: loghttp.ResultTypeStream,
			Result: []logproto.Stream{
				{
					Labels: `{foo="bar", level="debug"}`,
					Entries: []logproto.Entry{
						{
							Timestamp: time.Unix(0, 0),
							Line:      fmt.Sprintf("%d", 0),
						},
						{
							Timestamp: time.Unix(0, time.Hour.Nanoseconds()),
							Line:      fmt.Sprintf("%d", time.Hour.Nanoseconds()),
						},
					},
				},
			},
		},
	}

	res, err := split.Do(ctx, req)

	require.Equal(t, int(req.Limit), callCt)
	require.NoError(t, err)
	require.Equal(t, expected, res)
}

func Test_DoesntDeadlock(t *testing.T) {
	n := 10

	next := queryrange.HandlerFunc(func(_ context.Context, r queryrange.Request) (queryrange.Response, error) {
		return &ValiResponse{
			Status:    loghttp.QueryStatusSuccess,
			Direction: r.(*ValiRequest).Direction,
			Limit:     r.(*ValiRequest).Limit,
			Version:   uint32(loghttp.VersionV1),
			Data: ValiData{
				ResultType: loghttp.ResultTypeStream,
				Result: []logproto.Stream{
					{
						Labels: `{foo="bar", level="debug"}`,
						Entries: []logproto.Entry{

							{
								Timestamp: time.Unix(0, r.(*ValiRequest).StartTs.UnixNano()),
								Line:      fmt.Sprintf("%d", r.(*ValiRequest).StartTs.UnixNano()),
							},
						},
					},
				},
			},
		}, nil
	})

	l := WithDefaultLimits(fakeLimits{
		maxQueryParallelism: n,
	}, queryrange.Config{SplitQueriesByInterval: time.Hour})
	split := SplitByIntervalMiddleware(
		l,
		valiCodec,
		splitByTime,
		nilMetrics,
	).Wrap(next)

	// split into n requests w/ n/2 limit, ensuring unused responses are cleaned up properly
	req := &ValiRequest{
		StartTs:   time.Unix(0, 0),
		EndTs:     time.Unix(0, (time.Duration(n) * time.Hour).Nanoseconds()),
		Query:     "",
		Limit:     uint32(n / 2),
		Step:      1,
		Direction: logproto.FORWARD,
		Path:      "/api/prom/query_range",
	}

	ctx := user.InjectOrgID(context.Background(), "1")

	startingGoroutines := runtime.NumGoroutine()

	// goroutines shouldn't blow up across 100 rounds
	for i := 0; i < 100; i++ {
		res, err := split.Do(ctx, req)
		require.NoError(t, err)
		require.Equal(t, 1, len(res.(*ValiResponse).Data.Result))
		require.Equal(t, n/2, len(res.(*ValiResponse).Data.Result[0].Entries))

	}
	runtime.GC()
	endingGoroutines := runtime.NumGoroutine()

	// give runtime a bit of slack when catching up -- this isn't an exact science :(
	// Allow for 1% increase in goroutines
	require.LessOrEqual(t, endingGoroutines, startingGoroutines*101/100)
}
