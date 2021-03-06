// Copyright 2018 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package runtime

import "unsafe"

const _NSIG = 0

type gsignalStack struct{}
type sigset struct{}

//go:nosplit
func setThreadCPUProfiler(hz int32) {
	for {
		breakpoint()
	}
}

//go:nosplit
func unminit() {
	for {
		breakpoint()
	}
}

func clearSignalHandlers()           {}
func sigdisable(uint32)              {}
func sigenable(uint32)               {}
func sigignore(uint32)               {}
func signame(sig uint32) string      { return "" }
func sigblock()                      {}
func msigrestore(sigmask sigset)     {}
func initsig(preinit bool)           {}
func setProcessCPUProfiler(hz int32) {}
func mpreinit(mp *m)                 {}
func msigsave(mp *m)                 {}
func goenvs()                        {}
func minit()                         {}

//go:nosplit
func crash() {
	for {
		breakpoint()
	}
}

//go:nosplit
func setsystim(nanotime func() int64, setalarm func(ns int64) bool) {
	if nanotime != nil {
		thetasker.newnanotime = nanotime
	} else {
		thetasker.newnanotime = dummyNanotime
	}
	if setalarm != nil {
		thetasker.newsetalarm = setalarm
	} else {
		thetasker.newsetalarm = dummySetalarm

	}
	setsystim1()
}

//go:nosplit
func usleep(usec uint32) {
	nanosleep(int64(usec) * 1000)
}

//go:nosplit
func getRandomData(r []byte) {
	// BUG: true random data required
	extendRandom(r, 0)
}

//go:nosplit
func osinit() {
	ncpu = 1 // for now only single CPU is supported (see identcurcpu, cpuid)
	physPageSize = _PageSize
}

//go:nosplit
func isr() bool {
	return getg() == &thetasker.allcpu[cpuid()].gh
}

func setsystim1()
func newosproc(mp *m)
func exit(code int32)
func osyield()

//go:noescape
func write(fd uintptr, p unsafe.Pointer, n int32) int32

//go:noescape
func futexsleep(addr *uint32, val uint32, ns int64)

//go:noescape
func futexwakeup(addr *uint32, cnt uint32)

//go:noescape
func exitThread(wait *uint32)

// syscalls not used by runtime

func setwalltime(sec int64, nsec int32)
func setprivlevel(newlevel int) (oldlevel, errno int)
func irqenabled(irq int) (enabled, errno int)
func setirqenabled(irq, enabled int) (errno int)
func irqctl(irq, ctl int) (enabled, prio, errno int)
func nanosleep(ns int64)
