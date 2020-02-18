// Copyright 2009 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package runtime

//go:nosplit
func cputicks() int64 {
	// Currently cputicks() is used in blocking profiler and to seed fastrand().
	// nanotime() is a poor approximation of CPU ticks that is enough for the profiler.
	return nanotime()
}

//go:nosplit
func cpuid() int {
	// for now only single CPU is supported (see also identcurcpu, osinit)
	return 0
}