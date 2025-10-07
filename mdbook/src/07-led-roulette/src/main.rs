#![no_std]
#![no_main]

use cortex_m_rt::entry;
use embedded_hal::delay::DelayNs;
use microbit::{
    board::Board, display::blocking::Display, hal::Timer,
};
use panic_rtt_target as _;
use rtt_target::rtt_init_print;

#[entry]
fn main() -> ! {
    rtt_init_print!();

    let board = Board::take().unwrap();
    let mut timer = Timer::new(board.TIMER0);
    let mut display = Display::new(board.display_pins);

    let mut lights = [[[0; 5]; 5]; 16];
    for k in 0..5 {
        lights[k][0][k] = 1;
    }
    for k in 5..9 {
        lights[k][k - 4][4] = 1;
    }
    for k in 9..13 {
        lights[k][4][12 - k] = 1;
    }
    for k in 13..16 {
        lights[k][16 - k][0] = 1;
    }

    loop {
        for k in 0..16 {
            display.show(
                &mut timer, lights[k],
                40u32, // at 20 the mux causes weird output
            )
        }
    }
}
