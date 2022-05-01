; 1802 Membership Card Demo Programs
;
; Hacked together by James McClanahan, W4JBM
;
; (e-mail w4jbm at bellsouth period net)
;
; These small programs are designed to set in EPROM above the
; monitor and BASIC to allow quick demos primarily making use
; of the LEDs and Swiches of the 1802 Membership Card.
;
; A routine to transfer these down to Page Zero is also include
; to allow experimentation and exploration.
;
; None of this work is particularly original and definately builds
; from a foundation laid by others. Special thanks to...
;
; Lee Hart for making the 1802 Membership Card available.
; Herb Johnson for the RAM/ROM and serial upgrade kits.
; Chuck Yakym for his solid serial monitor + Tiny BASIC eprom images.
; Marcel van Tongeren for the Emma 02 emulator used for testing.
;
; The 1802 Membership Card definately can play a role in helping
; "kids of all ages, including fifty and up" explore aspects related
; to Science, Technology, Engineering, and Math (STEM).
;
; This code may be freely used, modified, and distributed. You are
; encouraged to share any additions, enhancements, and such.
;


;
; Compile using:
; asmx20.exe -C 1802 -l -o -w -e STEM1802.asm
;

;
; starting memory location of these routines
;

STPROG		EQU	$FF00	; Starting Address
STPGHI		EQU	$FF	; High Byte
STPGLO		EQU	$00	; Low Byte

;
; change start address as follows to allow testing in RAM
; note that the copy routine will only copy 127 bytes in
; this case
;
;STPROG		EQU	$7F00	; Starting Address in RAM
;STPGHI		EQU	$7F	; High Byte
;STPGLO		EQU	$00	; Low Byte


;
; Register Definitions:
;

R0		EQU	0
R1		EQU	1
R2		EQU	2
R3		EQU	3
R4		EQU	4
R5		EQU	5
R6		EQU	6
R7		EQU	7
R8		EQU	8
R9		EQU	9
R10		EQU	10
R11		EQU	11
R12		EQU	12
R13		EQU	13
R14		EQU	14
R15		EQU	15


;
; I/O Port Definitions:
;

P1		EQU	1
P2		EQU	2
P3		EQU	3
P4		EQU	4
P5		EQU	5
P6		EQU	6
P7		EQU	7

; 
; Set starting location to Page F0H
;

START:		ORG	STPROG


;;;;;;;;;;;;;;;;;;;;
;
;;;;; ROM Monitor Cold Start
;
;;;;;;;;;;;;;;;;;;;;

CLDSTRT:	LBR	8000H	; long branch to start monitor

; this is primarily here so that if the contents of ROM at F0xxH
; are copied to page zero at 00xxH, the monitor cold start will
; be at address 0H

		IDL

;
; Some sections of code have "Learning Exercises" associated with
; them. This assumes that the routines have been copied down to
; page zero.
;
; The goal was to give some "practical" but easy examples of how
; the code could be modified to allow a "hands-on" demonstration
; for anyone interested in trying them.
;
; LEARNING:
;
; Once the routines are loaded to Page Zero, you will probably want
; to modify this jump to point to the routine you want to work with.
; For example, this should be C0 00 20 to jump to the "Mimic Switches"
; routine.
;
; For someone wanting to dig a bit deeper, you might also want to
; explain the different between "little endian" such as the 1802 and 
; 68000 use and "little endian" (where the address bytes are reversed)
; such as the Intel x86, 6502,and Z80 use. For example, the equivalent
; instruction on a 6502 would assemble to something like:
;
; Hex		Assembler	Comments
; --------	---------	---------------
; 4C 00 80	JMP $8000	; jump to $8000
;
; As a "bonus question", discuss how operating systems (such as Unix)
; that might run on both types of systems might encounter issues with
; dealing with this. (This is sometimes called the "nUxi" problem.
; The PDP-11 was the first machine Unix was developed on and uses
; a mix of big endian and little endian (called, appropriately enough,
; "mixed-endian"). When Unix was ported to the IBM System/1 (which uses
; big-endian), it caused the bytes in the words containing "Un" and "ix"
; to be "flipped" (to "nU" and "xi") and the sytem printed "nUxi" instead
; printing "Unix" early in the porting process.
;

;
; The following helps quickly find the routine you want to look at or
; edit once they are loaded to page zero. All LEDs will blank until
; just prior to the next segment of code. Then they will, in sequence,
; all light, display the lower byte of the address, and then all light
; a second time. The byte following that is the first byte of the
; code.

		DB	0,0,0
		DB	0,0,0
		DB	0,0,0
		DB	0,0,0
		DB	0,0,0
		DB	0,0,0
		DB	0,0,0
		DB	0,0,0
		DB	0
		DB	FFH,20H,FFH

;;;;;;;;;;;;;;;;;;;;
;
;;;;; Mimic Switches (echo to LEDs)
;
;;;;;;;;;;;;;;;;;;;;
;
; Uses 7FFFH as a scratch pad memory location
;

;
; before the "filler" was added to make finding portions of the
; code easier to find when using the built-in monitor (once
; the program is transfered to Page Zero), one of the two assembler
; directives below was used to force things to line up at "easy
; to remember" addresses
;
;		ALIGN	20H	; find next 32 bit boundary
;ORG		F020H		; start at F020H
;

MIMIC:		LDI	7FH	; load high byte of scratch pad
		PHI	R3	; and put in high portion of R3
		LDI	FFH	; load low byte of scratch pad
		PLO	R3	; and put in low portion of R3

; R3 now points to 7FFFH which is the RAM address used for
; scratch pad memory

		SEX	R3	; Set X to point to R3

; X tells the 1803 which register to use to point to memory

		INP	P4	; read switch status

; beware:	the INP instruction places the input value in
;		both the accumulator and the memory location
;		pointed to by Register x (R3 in this case)

		OUT	P4	; write to LEDs

; beware:	the OUT instruction also increments value at R3
;		we don't really need to decrement it, but why not?
;		(if this code is reused, this might save a headache)

		DEC	R3	; restore R3
		BR	MIMIC	; loop back to the start

;
; Some sections of code have "Learning Exercises" associated with
; them. This assumes that the routines have been copied down to
; page zero.
;
; The goal was to give some "practical" but easy examples of how
; the code could be modified to allow a "hands-on" demonstration
; for anyone interested in trying them.
;
; LEARNING:
;
; The "scratch pad" memory location is pointed to with the high
; byte at xxH and the low byte at xxH. You could move this to
; something like 0010H and then after a reset you should see the
; last switch positions displayed by advacing the built in monitor
; to 0010H. You could even use 0000H to make it easier, but that
; will clobber the jump instruction located there.
;

		DB	0,0,0
		DB	0,0,0
		DB	0,0,0
		DB	0,0,0
		DB	0,0,0
		DB	0,0
		DB	FFH,40H,FFH

;;;;;;;;;;;;;;;;;;;;
;
;;;;; Mimic XOR (inverted) Switches (to LEDs)
;
;;;;;;;;;;;;;;;;;;;;
;
; Uses 7FFFH as a scratch pad memory location
;

;		ALIGN	20H	; find next 32 bit boundary
;		ORG	F040H	; start at easy to remember address

XMIMIC:		LDI	7FH	; load high byte of scratch pad
		PHI	R3	; and put in high portion of R3
		LDI	FFH	; load low byte of scratch pad
		PLO	R3	; and put in low portion of R3

; R3 now point to 7FFFH

		SEX	R3	; Set X to point to R3

; X tells the 1803 which register to use to point to memory

		INP	P4	; read switch status
		XRI	FFH	; XOR to flip all bits
		STR	R3	; store
		OUT	P4	; write to LEDs
		DEC	R3	; undo increment from OTU
		BR	XMIMIC	; loop back to the start

;
; LEARNING:
;
; The value the input switches is XORed with is at xxH. If that
; value is changed from FFH to 00H, the LEDs will display the value
; of the switches without inverting them.
;
; For those wanting to explore a bit deeper, you may want to discuss
; the XOR function.
;
; Also, values like 0FH or F0H will cause half the LEDs to display
; the oposite value from the switch while the other half of the
; LEDs to match the value from the switch.
;
; As a "bonus question", set the value to something like $AA, $55, or
; even some random value and let the user play with the switches to
; determine the XOR mask that is in use.
;

		DB	0,0,0
		DB	0,0,0
		DB	0,0,0
		DB	0,0,0
		DB	0,0
		DB	FFH,60H,FFH

;;;;;;;;;;;;;;;;;;;;
;
; Slow Flash of Q LED
;
;;;;;;;;;;;;;;;;;;;;
;
; allows the use of the switches to control the speed
; at which the LED flashes
;

;		ALIGN	20H	; find next 32 bit boundary
;		ORG	F080H	; start at easy to remember address

SFLSHQ:		REQ		; reset Q

		LDI	7FH	; load high byte of scratch pad
		PHI	R3	; and put in high portion of R3
		LDI	FFH	; load low byte of scratch pad
		PLO	R3	; and put in low portion of R3

; R3 now point to 7FFFH

		SEX	R3	; Set X to point to R3

; X tells the 1803 which register to use to point to memory

FLOOP1:		INP	4	; read switch status
		STR	R3	; store the results and then
		OUT	4	; show the value on the LEDs
		DEC	R3	; undo OUT's increment
		PHI	R1	; push switch value into hi byte of R1
FLOOP2:		DEC	R1	; count down in R1 as timer
		GHI	R1	; load the hi byte of R1 for test
		BNZ 	FLOOP2	; if not zero, branch to loop 2
		BQ	SFLSHQ	; if Q set, jump to start and reset
		SEQ		; otherwise, set Q
		BR	FLOOP1	; then read switch and count again

; note that the switches are only read when the routine jumps to SFSHQ
; which will be the transition from Q set to Q reset during normal
; operation
;
;;;;; LEARNING:
;
; Counting the "pulses per second" (pps) can be a way to measure speed.
;
; From the perspective of learning about binary numbers, you should be
; able to perform exercises like setting the switches to 80H and then
; 40H and see the number of pulses double.
;
; Faster operation would be possible by pushing the countdown value
; into R1's low byte and then getting and testing it. With the 1802
; operating at around 1.8 MHz, this is likely to be faster than can
; be counted by the eye.
;
; As a "bonus question", if you measure the pps at $80H and $40H, can
; you calculate the approximate pps for $C0H?;
;
; Also, in looking at the code can you highlight which portion is fixed
; "overhead" that will take the same amound of time to run no matter
; what position the switches are in versus the portion of the code that
; actually varies based on the setting?
;
; Another "bonus question" if a terminal is connected to the serial
; output of the Membership Card computer... Q is used as the output for
; the serial port. Can you find switch settings that "spoof" the
; terminal into thinking it is seeing serial data?
;
; If you are able to spoof the serial device, you will likely see the
; letter "U". Knowing the U has the ASCII code of 85 decimal (55H),
; can you explain why it would show up frequently?
;

		DB	0,0,0
		DB	0,0,0
		DB	0
		DB	FFH,80H,FFH

;;;;;;;;;;;;;;;;;;;;
;
;;;;; Scan LEDs Left to Right
;
;;;;;;;;;;;;;;;;;;;;

;		ALIGN	20H	; find next 32 bit boundary
;		ORG	F080H	; start at easy to remember address

SCANRL:		LDI	7FH	; load high byte of scratch pad
		PHI	R3	; and put in high portion of R3
		LDI	FFH	; load low byte of scratch pad
		PLO	R3	; and put in low portion of R3

; R3 now point to 7FFFH

		SEX	R3	; Set X to point to R3

; X tells the 1803 which register to use to point to memory

SLOOP1:		LDI	80H	; start with bit 7 set
SLOOP2:		STR	R3	; store the results
		OUT	4	; show it on the LEDs
		DEC	R3	; undo OUT's increment
		LDI	10H	; load delay count (adjusts speed)
		PHI	R1	; put in hi byte of R1
SLOOP3:		DEC	R1	; count down in R1
		GHI	R1	; load the hi byte of R1
		BNZ 	SLOOP3	; if not zero, branch to loop 3
		LDN	R3	; load current value
		SHR		; shift right
		BNZ	SLOOP2	; if not zero, branch to loop 2
		BR	SLOOP1	; otherwise, start over

; LEARNING
;
; Try changing the pre-loaded number at location xxxxH from
; 80H to FFH and see what happens.
;
; Try different values in the countdown timer at  xxxxH from
; 10H and see what happens. Probably the best way to "measure"
; the speed is using something like "scans per second" where
; one scan is completed and the next begins. Covering all of
; the LEDs except one can make this easier to count.
;
; Can you change the program it scans the opposite direction?
; Hint: The SHL (shift left) instruction is xxH.
;
;

		DB	0,0,0
		DB	0
		DB	FFH,A0H,FFH


;;;;;;;;;;;;;;;;;;;;
;
;;;;; Copy F0xxH to 00xxH
;
;;;;;;;;;;;;;;;;;;;;
;
; to allow for easy manipulation of the above routines by putting them
; down in RAM starting at 0000H.
;
; Note: This copies 255 (FFH) bytes because that was an easy number to
; load into R6 (the counter). It only checks for the low byte of R6
; to count down to zero. This routine is based on code from Ipso Facto
; #7. That routine includes counting and testing using the high byte
; of R6 (as well as a routine for entering values).
;

;		ALIGN	20H	; find next 32 bit boundary
;		ORG	F0A0H	; start at easy to remember address

MCOPY:		LDI	STPGHI	; use FFH for various things
		PHI	R4	; upper byte of R4 is "from" page
		PLO	R6	; lower byte of R6 is the number
				; of bytes to transfer
				;
				; using 255 saves having to LDI
				; another value

		LDI	STPGLO	; use 00H for various things
		PLO	R4	; zero lower bye of R4
		PHI	R5	; upper byte of R5 is "to" page
		PLO	R5	; zero lower bye of R5
		PHI	R6	; zero upper byte of R6

		REQ		; reset Q to show we are working

DOCOPY:		LDA	R4	; load D and increment R4
		STR	R5	; push data to new location pointed to
				; by R5
		INC	R5	; and increment R5 for next pass
		DEC	R6	; decrement bytes left to copy count
		GLO	R6	; check how much is left to copy
		BNZ	DOCOPY	; as long as not zero, continue
		SEQ		; set Q to show we are done
		IDL		; and stop

;
; LEARNING
;
; This segment was streamlined to fit into less than 32 bytes, but
; adding logic to handle different a different source address,
; destination address, or byte count to copy is fairly easy.
;
; Another possible change that might be reasonable to implement is to
; replace the read from a source address and hard code a value to be
; pushed to the destination location. In effect, this would turn the
; code into a "fill" command.
;

;
; ADDITIONAL LEARNING
;
; The 1802 microprocessor was used in several satellites.
;

;
; the code below "points" to C0H in a manner consistent with the other
; code segments and could be used for user programs if desired
;

		DB	0,0,0
		DB	0,0,0
		DB	0,0,0
		DB	FFH,C0H,FFH
		DB	0,0,0
		DB	0,0,0
		DB	0,0,0
		DB	0,0,0
		DB	0,0,0
		DB	0,0,0
		DB	0,0,0
		DB	0,0,0
		DB	0,0,0
		DB	0,0,0
		DB	0,0


		END
