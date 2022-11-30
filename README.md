
#PROBLEM STATEMENT<br />
Let us define our customized floating point number system (called as NFP => New Floating-Point number) in 32 bits as follows:<br />
1) Sign bit: most significant bit (0 => the number is positive, 1=> the number is negative)<br />
2) 2’compliment exponent: next 12 bits<br />
3) Mantissa: rest 19 bits<br />
</br>
All these floating-point numbers are in normalized format.<br />
Write Assembly Language program to Add and Multiply two LPFP numbers. Also write additional code / data to test these functions.<br />
</br>
Note:<br />
a) Implementation must be modular.<br />
b) You need to write nfpAdd and nfpMultiply as two functions.<br />
c) Data must be taken from memory. And After computation the result has to be put into memory.<br />
d) Each function assumes that address is stored in register [r1] from where the two 32-bit NFP<br />
numbers must be taken.<br />
e) And the result needs to be put into location pointed by register [r1] just after the input data.<br />
f) All registers (except [r1]) used inside your functions must be restored to its original value after<br />
the end of function call.<br />
