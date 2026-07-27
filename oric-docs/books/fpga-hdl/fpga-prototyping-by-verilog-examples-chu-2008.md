# FPGA Prototyping by Verilog Examples (Xilinx Spartan-3 Version)

**Author:** Pong P. Chu
**Year:** 2008
**Category:** FPGA / HDL reference
**Source:** `/Users/nenaddjordjevic/pCloud Drive/iCloud-Migration/Programming/Retro/FPGA/FPGAPrototypingByVerilogExamples.pdf`

## Table of Contents

Preface — xxi
Acknowledgments — xxvii

### Part I  Basic Digital Circuits

**Chapter 1  Gate-Level Combinational Circuit** — 1
- 1.1 Introduction — 1
- 1.2 General description — 2
- 1.3 Basic lexical elements and data types — 3
- 1.4 Data types — 4
- 1.5 Program skeleton — 5
- 1.6 Structural description — 9
- 1.7 Testbench — 12
- 1.8 Bibliographic notes — 14
- 1.9 Suggested experiments — 14

**Chapter 2  Overview of FPGA and EDA Software** — 15
- 2.1 Introduction — 15
- 2.2 FPGA — 15
- 2.3 Overview of the Digilent S3 board — 17
- 2.4 Development flow — 19
- 2.5 Overview of the Xilinx ISE project navigator — 21
- 2.6 Short tutorial on ISE project navigator — 24
- 2.7 Short tutorial on the ModelSim HDL simulator — 31
- 2.8 Bibliographic notes — 35
- 2.9 Suggested experiments — 36

**Chapter 3  RT-Level Combinational Circuit** — 39
- 3.1 Introduction — 39
- 3.2 Operators — 39
- 3.3 Always block for a combinational circuit — 48
- 3.4 If statement — 51
- 3.5 Case statement — 54
- 3.6 Routing structure of conditional control constructs — 57
- 3.7 General coding guidelines for an always block — 60
- 3.8 Parameter and constant — 64
- 3.9 Design examples — 67
- 3.10 Bibliographic notes — 80
- 3.11 Suggested experiments — 80

**Chapter 4  Regular Sequential Circuit** — 83
- 4.1 Introduction — 83
- 4.2 HDL code of the FF and register — 86
- 4.3 Simple design examples — 91
- 4.4 Testbench for sequential circuits — 96
- 4.5 Case study — 99
- 4.6 Bibliographic notes — 115
- 4.7 Suggested experiments — 115

**Chapter 5  FSM** — 119
- 5.1 Introduction — 119
- 5.2 FSM code development — 122
- 5.3 Design examples — 125
- 5.4 Bibliographic notes — 135
- 5.5 Suggested experiments — 135

**Chapter 6  FSMD** — 139
- 6.1 Introduction — 139
- 6.2 Code development of an FSMD — 143
- 6.3 Design examples — 153
- 6.4 Bibliographic notes — 170
- 6.5 Suggested experiments — 170

**Chapter 7  Selected Topics of Verilog** — 175
- 7.1 Blocking versus nonblocking assignment — 175
- 7.2 Alternative coding style for sequential circuit — 182
- 7.3 Use of the signed data type — 188
- 7.4 Use of function in synthesis — 191
- 7.5 Additional constructs for testbench development — 193
- 7.6 Bibliographic notes — 210
- 7.7 Suggested experiments — 210

### Part II  I/O Modules

**Chapter 8  UART** — 215
- 8.1 Introduction — 215
- 8.2 UART receiving subsystem — 216
- 8.3 UART transmitting subsystem — 223
- 8.4 Overall UART system — 226
- 8.5 Customizing a UART — 230
- 8.6 Bibliographic notes — 232
- 8.7 Suggested experiments — 232

**Chapter 9  PS2 Keyboard** — 235
- 9.1 Introduction — 235
- 9.2 PS2 receiving subsystem — 236
- 9.3 PS2 keyboard scan code — 240
- 9.4 PS2 keyboard interface circuit — 244
- 9.5 Bibliographic notes — 248
- 9.6 Suggested experiments — 248

**Chapter 10  PS2 Mouse** — 251
- 10.1 Introduction — 251
- 10.2 PS2 mouse protocol — 252
- 10.3 PS2 transmitting subsystem — 253
- 10.4 Bidirectional PS2 interface — 259
- 10.5 PS2 mouse interface — 263
- 10.6 Bibliographic notes — 266
- 10.7 Suggested experiments — 266

**Chapter 11  External SRAM** — 269
- 11.1 Introduction — 269
- 11.2 Specification of the IS61LV25616AL SRAM — 270
- 11.3 Basic memory controller — 274
- 11.4 A safe design — 276
- 11.5 More aggressive design — 288
- 11.6 Bibliographic notes — 294
- 11.7 Suggested experiments — 294

**Chapter 12  Xilinx Spartan-3 Specific Memory** — 297
- 12.1 Introduction — 297
- 12.2 Embedded memory of Spartan-3 device — 297
- 12.3 Method to incorporate memory modules — 298
- 12.4 HDL templates for memory inference — 300
- 12.5 Bibliographic notes — 307
- 12.6 Suggested experiments — 307

**Chapter 13  VGA Controller I: Graphic** — 309
- 13.1 Introduction — 309
- 13.2 VGA synchronization — 312
- 13.3 Overview of the pixel generation circuit — 319
- 13.4 Graphic generation with an object-mapped scheme — 319
- 13.5 Graphic generation with a bit-mapped scheme — 332
- 13.6 Bibliographic notes — 337
- 13.7 Suggested experiments — 337

**Chapter 14  VGA Controller II: Text** — 341
- 14.1 Introduction — 341
- 14.2 Text generation — 341
- 14.3 Full-screen text display — 348
- 14.4 The complete pong game — 352
- 14.5 Bibliographic notes — 366
- 14.6 Suggested experiments — 366

### Part III  PicoBlaze Microcontroller (Xilinx specific)

**Chapter 15  PicoBlaze Overview** — 371
- 15.1 Introduction — 371
- 15.2 Customized hardware and customized software — 372
- 15.3 Overview of PicoBlaze — 374
- 15.4 Development flow — 377
- 15.5 Instruction set — 377
- 15.6 Assembler directives — 390
- 15.7 Bibliographic notes — 391

**Chapter 16  PicoBlaze Assembly Code Development** — 393
- 16.1 Introduction — 393
- 16.2 Useful code segments — 393
- 16.3 Subroutine development — 398
- 16.4 Program development — 399
- 16.5 Processing of the assembly code — 406
- 16.6 Syntheses with PicoBlaze — 411
- 16.7 Bibliographic notes — 412
- 16.8 Suggested experiments — 412

**Chapter 17  PicoBlaze I/O Interface** — 415
- 17.1 Introduction — 415
- 17.2 Output port — 416
- 17.3 Input port — 418
- 17.4 Square program with a switch and seven-segment LED display interface — 421
- 17.5 Square program with a combinational multiplier and UART console — 434
- 17.6 Bibliographic notes — 449
- 17.7 Suggested experiments — 449

**Chapter 18  PicoBlaze Interrupt Interface** — 453
- 18.1 Introduction — 453
- 18.2 Interrupt handling in PicoBlaze — 453
- 18.3 External interface — 456
- 18.4 Software development considerations — 457
- 18.5 Design example — 458
- 18.6 Bibliographic notes — 464
- 18.7 Suggested experiments — 464

Appendix A: Sample Verilog templates — 467
- A.1 Numbers and operators — 467
- A.2 General Verilog constructs — 469
- A.3 Routing with conditional operator and if and case statements — 470
- A.4 Combinational circuit using an always block — 472
- A.5 Memory Components — 473
- A.6 Regular sequential circuits — 474
- A.7 FSM — 476
- A.8 FSMD — 478
- A.9 S3 board constraint file (s3.ucf) — 480

References — 485
Topic Index — 487
