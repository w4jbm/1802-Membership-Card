# 1802-Membership-Card-STEM-Lessons

This project need to be revisited and the source code is out of synch with the assembly listing and the Intel Hex file. I have moved it to Herb Johnson's version of William Colley's [A18 Assembler](http://www.retrotechnology.com/memship/a18.html).

## Background

Originally this started when a friend who teaches middle school science was looking for STEM (Science, Techonolgy, Engineering, and Math) projects for her students. I had built Lee Hart's [1802 Membership Card](http://www.sunrise-ev.com/1802.htm) and suggested she take a look at that.

She asked two questions...

The first was whether a 14 or 15 year old could assemble the kit? Although it isn't a beginners kit, I believe I could have built it at that age. I did recommend looking at some of the low-cost kits designed to help get some soldering experience as a first step for anyone who hadn't build something before.

The second question was a bit toughter. What would they really learn with this? Granted, the lights and switches would probably grab their attention, but if she had to set some specific learning objectives, what would they be?

So I wrote this up as a first pass. The answer to her question is largely in the assembly source, but here is a quick list:

- What is an assembler and what is assembly language?
- What is meant by Little Endian and Big Endian? How did this lead to the "nUxi" bug?
- What is "scratch pad" memory and how is it used by programs?
- What are the XOR, AND, and OR functions and how do they work?
- What is a timing loop?
- How can you fill a range of memory with a specific value?
- On an 8-bit system, what is a "page" of memory?
- What is the difference between RAM and ROM?

This was two evenings of work while on a business trip and using Marcel van Tongeren's excellen [Emma 02](https://www.emma02.hobby-site.com/) emulator.


## How do I really use this?

I originally located the code at $F000 and later to $FF00. It fits in a single page (256 bytes) of memory with room left over and I loaded it into the top of the ROM image for the 1802 Membership Card. That was a few years ago and another thing on my to-do list is to upgrade the ROM in my machine and see if there is still room at the top for this.

All of the examples are short enough to be hand-loaded using the toggle switches if needed. If you have the code in ROM, there is a "relocator" that you can jump to that will move them down to RAM where they can be examined and tweaked.

This does assume the system has RAM in the lower part of memory (including the use of some scratchpad RAM at $7FFF) and ROM in the upper part.


## What can I do with it?

Pretty much anything you want. It is released under the MIT license and I am also happy to share it under other licenses if needed.

I would be interested in hearing about any use, but beyond that I am basically turning this loose into the wild.


## License

MIT License

Copyright (c)2017,2019,2022 by James McClanahan W4JBM

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
