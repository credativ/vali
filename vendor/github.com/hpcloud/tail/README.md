
**NOTE**: This fork is currently being maintained for use in the valitail agent of the [Vali](https://github.com/credativ/vali) project.

Use outside of that context is not tested or supported.

# Go package for tail-ing files

A Go package striving to emulate the features of the BSD `tail` program. 

```Go
t, err := tail.TailFile("/var/log/nginx.log", tail.Config{Follow: true})
for line := range t.Lines {
    fmt.Println(line.Text)
}
```

See [API documentation](http://godoc.org/github.com/hpcloud/tail).

## Log rotation

Tail comes with full support for truncation/move detection as it is
designed to work with log rotation tools.

## Installing

    go get github.com/hpcloud/tail/...

## Windows support

This package [needs assistance](https://github.com/hpcloud/tail/labels/Windows) for full Windows support.
