# A binding/wrapper library for an awesome GUI library [LEIF](https://github.com/cococry/leif/)
still a bit rough since the library used a lot of macros and they were annoying :p. pull requests are welcome!

## TODOs:
- [ ] add examples
- [ ] do something about the #file and #line args. look a bit ugly (used for IDs internally in the c library.

## usage
go to [LEIF](https://github.com/cococry/leif/) and follow the installation instructions. after that just import this in your Odin project and you should be good to go. when running/building, you need to pass this to Odin:
```-extra-linker-flags:"-lclipboard"```

## example
(need to add later, for now you can just do a basic OpenGL setup in odin and then copy the example from Leif repo and translate it. ```lf_``` just becomes ```lf.``` (assuming you imported it as lf)