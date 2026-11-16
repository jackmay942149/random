// Implmentation of the Mersenne Twister algorithim
// M. Matsumoto and T. Nishimura, “Mersenne Twister: A 623-dimensionally equidistributed uniform pseudo-random number generator,” ACM Transactions on Modeling and Computer Simulation, vol. 8, no. 1, pp. 3–30, 1998.
// DOI: https://doi.org/10.1145/272991.272995 

package random

Mersenne_Twister :: struct {
	index: int,
	state: [624]u32,
}

@(private = "file")
high_bit :: proc(a: u32) -> u32 {
	return a & 0x80000000
}

@(private = "file")
low_31_bits :: proc(a: u32) -> u32 {
	return a & 0x7FFFFFFF
}

@(private = "file")
twist :: proc(mt: ^Mersenne_Twister) {
	for i in 0 ..< 624 {
		x := high_bit(mt.state[i]) | low_31_bits(mt.state[(i + 1) % 624])
		shifted := x >> 1
		if x % 2 == 1 {
			shifted = shifted ~ 0x9908B0DF
		}
		mt.state[i] = mt.state[(i + 397) % 624] ~ shifted
	}
	mt.index = 0

}

mersenne_twister_create :: proc(seed: u32, allocator := context.allocator) -> ^Mersenne_Twister {
	mt := new(Mersenne_Twister, allocator)
	mt.state[0] = seed

	for i in 1 ..< 624 {
		prev := mt.state[i - 1]
		mt.state[i] = 1812433253 * (prev ~ (prev >> 30)) + u32(i)
	}

	mt.index = 624 // Makes twist on first call
	return mt
}

mersenne_twister_destroy :: proc(mt: ^Mersenne_Twister, allocator := context.allocator) {
	free(mt, allocator)
}

mersenne_twister_next :: proc(mt: ^Mersenne_Twister) -> u32 {
	if mt.index >= 624 {
		twist(mt)
	}

	y := mt.state[mt.index]

	y ~= y >> 11
	y ~= (y << 7) & 0x9D2C5680
	y ~= (y << 15) & 0xEFC60000
	y ~= y >> 18

	mt.index += 1
	return y
}

