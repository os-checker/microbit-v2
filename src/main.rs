#![no_main]
#![no_std]

// Some panic handler needs to be included. This one halts the processor on panic.
use panic_halt as _;

use cortex_m::asm::nop;
use cortex_m_rt::entry;
use rtt_target::{rprintln, rtt_init_print};

// Use `main` as the entry point of this application, which may not return.
#[entry]
fn main() -> ! {
    // initialization
    rtt_init_print!();
    rprintln!("Hello world!");
    let mut x = 100;

    loop {
        x += 1;
        rprintln!("x={}", x);
        for _ in 0..1_000_000 {
            nop();
        }
    }
}
