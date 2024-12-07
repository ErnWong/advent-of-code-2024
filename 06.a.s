# References:
# https://www.cl.cam.ac.uk/teaching/1617/ECAD+Arch/files/docs/RISCVGreenCardv8-20151013.pdf
# http://csl.snu.ac.kr/courses/4190.307/2020-1/riscv-user-isa.pdf
# https://www.qemu.org/docs/master/system/target-riscv.html#board-specific-documentation
# https://www.qemu.org/docs/master/system/riscv/virt.html

	.global _start
	.section .text.bios

_start:
	li s0, 0x10000000               # UART 16550 Read Buffer Register, and Transmitter Holding Register (https://osblog.stephenmarz.com/ch2.html, and https://github.com/qemu/qemu/blob/master/hw/riscv/virt.c)
	addi s1, s0, 5                  # UART 16550 Line Status Register

	li s2, 0x80001000               # Map start address - 4096 bytes into the RAM to skip over our 1024 bytes of code (https://github.com/qemu/qemu/blob/master/hw/riscv/virt.c)
	mv s3, s2                       # Map end address
	li s4, 0                        # Map width
	li s5, 0                        # Map height

	li s6, 0                        # Guard X coord
	li s7, 0                        # Guard Y coord
	li s8, 0                        # Guard velocity x
	li s9, 0                        # Guard velocity y

	li s10, 0                       # Current X coord for reading
	li s11, 0                       # Current Y coord for reading

read_map_byte:
	lb t0, (s1)                     # Read the uart Line Status Register
	andi t0, t0, 0x1                # Check the Data Ready bit (bit 0)
	beq t0, x0, read_map_byte       # Skip reading if there's no data to read

	lb t0, (s0)                     # Read one byte of the map
	#    sb t0, (s0) # debug
	
parse_end_of_transmission:
	li t1, 0x4 # (end-of-transmission ascii character)
	bne t0, t1, parse_end_of_row
	add s5, s11, 1                  # Save map height using Y coord
	j end_of_read_map

parse_end_of_row:
	li t1, 0xA # ('\n')
	bne t0, t1, parse_guard_up
	mv s4, s10                      # Save map width using X coord
	li s10, 0                       # Reset X coord
	addi s11, s11, 1                # Increment current Y coord
	j parse_end_for_byte            # Skip incrementing size

parse_guard_up:
	li t1, 0x5E # ('^')
	bne t0, t1, parse_guard_right
	li s8, 0                        # Initial guard velocity x
	li s9, -1                       # Initial guard velocity y
	j parse_end_for_guard
parse_guard_right:
	li t1, 0x3E # ('>')
	bne t0, t1, parse_guard_down
	li s8, 1                        # Initial guard velocity x
	li s9, 0                        # Initial guard velocity y
	j parse_end_for_guard
parse_guard_down:
	li t1, 0x76 # ('v')
	bne t0, t1, parse_guard_left
	li s8, 0                        # Initial guard velocity x
	li s9, 1                        # Initial guard velocity y
	j parse_end_for_guard
parse_guard_left:
	li t1, 0x3C # ('<')
	bne t0, t1, parse_end_for_map_cell
	li s8, -1                       # Initial guard velocity x
	li s9, 0                        # Initial guard velocity y
	j parse_end_for_guard
parse_end_for_guard:
	mv s6, s10                      # Set guard initial x coord
	mv s7, s11                      # Set guard initial y coord
parse_end_for_map_cell:
	addi s10, s10, 1                # Increment current X coord
	sb t0, (s3)                     # Append to map
	addi s3, s3, 1                  # Update our map size

	#    #debug coords
	#    addi t1, s10, 0x41
	#    sb t1, (s0)
	#    addi t1, s11, 0x61
	#    sb t1, (s0)
parse_end_for_byte:
	j read_map_byte

end_of_read_map:
	#    # Debug Newline
	#    li t0, 0xA
	#    sb t0, (s0)
visit:
	#    # Newline
	#    li t0, 0xA
	#    sb t0, (s0)

	# t0 = current guard address
	mul t0, s7, s4
	add t0, t0, s6
	add t0, t0, s2

	# Mark visited
	li t1, 0x58 # ('X')
	sb t1, (t0)

try_advance:
	add t1, s6, s8                  # Candidate new guard X coord
	add t2, s7, s9                  # Candidate new guard Y coord
	# t0 = Candidate address
	mul t0, t2, s4
	add t0, t0, t1
	add t0, t0, s2

	# Check bounds
	blt t1, x0, left_the_map
	blt t2, x0, left_the_map
	bge t1, s4, left_the_map
	bge t2, s5, left_the_map

	# Check for obstacle - rotate if there is
	lb t3, (t0)
	li t4, 0x23 # ('#')
	beq t3, t4, rotate

	# Otherwise, save the new guard position, and continue visiting
	mv s6, t1
	mv s7, t2
	#    li t3, 0x4D #debug 'M'
	#    sb t3, (s0) #debug
	j visit

rotate:
	# Rotate 90deg and try again
	#        li t1, 0x52 #debug 'R'
	#        sb t1, (s0) #debug
	mv t1, s8
	li t2, -1
	mul s8, s9, t2
	mv s9, t1
	j try_advance

left_the_map:
	#    #debug coords
	#    addi t1, s6, 0x41
	#    sb t1, (s0)
	#    addi t1, s7, 0x61
	#    sb t1, (s0)
	#    #debug size map
	#    addi t1, s4, 0x41
	#    sb t1, (s0)
	#    addi t1, s5, 0x61
	#    sb t1, (s0)

	mv t0, s2                       # Init read address for looping through map
	li t1, 0                        # Init count
sum_loop:
	bge t0, s3, print_sum           # Exit if we've reached the end of the map

	# Increment count if map position is visited, using convoluted branchless equality
	li t6, 1
	li t6, 5
	li t6, 5
	li t6, 5
	li t6, 5
	li t6, 1
	lb t3, (t0)
	slti t4, t3, 0x58 # ('X' character)
	not t4, t4
	slti t5, t3, 0x59 # (one after 'X' character)
	and t6, t4, t5
	add t1, t1, t6

	# Advance to next position on the map
	addi t0, t0, 1
	j sum_loop

print_sum:
	#    # Newline
	#    li s3, 0xA
	#    sb s3, (s0)

	mv t2, s2                       # Address for digit queue - Reuse the map address
	li t3, 0                        # Number of digits
	li t4, 10                       # Decimal base

	# Pad with zero character on the digit stack for the degenerate case
	li t5, 0x30 # ('0')
	sb t5, (t2)

push_digit:	
	beq t1, x0, print_digit         # Exit if we've exhausted the digits
	rem t5, t1, t4                  # Find the least significant decimal digit
	addi t5, t5, 0x30 # ('0')       # Convert digit to ASCII

	# Push onto digit stack
	addi t2, t2, 1
	sb t5, (t2)
	addi t3, t3, 1

	# Divide by 10 and loop for the next digit
	div t1, t1, t4
	j push_digit
print_digit:
	lb t5, (t2)                     # Load digit character
	sb t5, (s0)                     # Print the digit
	addi t2, t2, -1                 # Move to the next digit
	addi t3, t3, -1                 # Decrement the number of digits left
	li t6, 1
	bge t3, t6, print_digit         # Print the next digit


	li s3, 0xA
	sb s3, (s0)
	li s3, 0x4F
	sb s3, (s0)
	li s3, 0x4B
	sb s3, (s0)
end:
	j end
