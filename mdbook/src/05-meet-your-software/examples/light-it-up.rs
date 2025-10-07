#![deny(unsafe_code)]
#![no_main]
#![no_std]

use cortex_m::asm;
use cortex_m_rt::entry;
use embedded_hal::digital::OutputPin;
use microbit::board::Board;
use panic_halt as _;

const WAIT_CYCLES: u32 = 250_000;

#[entry]
fn main() -> ! {
    let mut board = Board::take().unwrap();

    loop {
        board.display_pins.col1.set_low().unwrap();
        board.display_pins.row1.set_high().unwrap();
        for _ in 0..WAIT_CYCLES {
            asm::nop();
        }
        board.display_pins.col1.set_high().unwrap();
        for _ in 0..WAIT_CYCLES {
            asm::nop();
        }
    }
}
