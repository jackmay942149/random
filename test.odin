package random

import "core:testing"

@(test)
test_mersenne_twister :: proc(t: ^testing.T) {
	mt := mersenne_twister_create(5489)
	defer mersenne_twister_destroy(mt)

	testing.expect_value(t, mersenne_twister_next(mt), u32(3499211612))
	testing.expect_value(t, mersenne_twister_next(mt), u32(581869302))
	testing.expect_value(t, mersenne_twister_next(mt), u32(3890346734))
	testing.expect_value(t, mersenne_twister_next(mt), u32(3586334585))
	testing.expect_value(t, mersenne_twister_next(mt), u32(545404204))
}

