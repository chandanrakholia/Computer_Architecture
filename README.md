
Computer Architecture
=>PROBLEM STATEMENT
Let us define our customized floating point number system (called as NFP => New Floating-Point number) in 32 bits as follows:
1) Sign bit: most significant bit (0 => the number is positive, 1=> the number is negative)
2) 2’compliment exponent: next 12 bits
3) Mantissa: rest 19 bits
All these floating-point numbers are in normalized format.
Write Assembly Language program to Add and Multiply two LPFP numbers. Also write additional code / data to test these functions.
Note:
a) Implementation must be modular.
b) You need to write nfpAdd and nfpMultiply as two functions.
c) Data must be taken from memory. And After computation the result has to be put into
memory.
d) Each function assumes that address is stored in register [r1] from where the two 32-bit NFP
numbers must be taken.
e) And the result needs to be put into location pointed by register [r1] just after the input data.
f) All registers (except [r1]) used inside your functions must be restored to its original value after
the end of function call.
