

This repository contains a **custom-built APB3 Verification IP (VIP)** supporting both **APB3 Master VIP** and **APB3 Slave VIP**, developed using **SystemVerilog and UVM**.

The VIP is designed to verify **APB3-compliant designs**, including peripherals and bus bridges, with a strong focus on:

* Protocol correctness
* Reusability
* Configurability
* Coverage-driven verification

This project is suitable for **IP-level, subsystem-level, and SoC-level verification** environments.


##  APB3 Protocol Scope

This VIP strictly follows the **AMBA APB3 specification**, supporting the following signals:

## APB3 Signals

* `PCLK`, `PRESETn`
* `PADDR`
* `PSEL`
* `PENABLE`
* `PWRITE`
* `PWDATA`
* `PRDATA`
* `PREADY`
* `PSLVERR`

❌ APB4/APB5 features such as `PSTRB`, `PPROT`, and low-power extensions are **not included**.


## ✨ Key Features

* Full **APB3 protocol compliance**
* Independent **Master VIP** and **Slave VIP**
* UVM-compliant agent architecture
* Configurable wait-state handling
* Error response (`PSLVERR`) support
* Protocol assertions for rule checking
* Functional coverage for transactions and timing
* Active and passive agent modes
* Easily reusable across multiple projects

-----------------------------------------------------------------------------------------------------------------

## APB3 Master VIP

### Purpose

The **APB3 Master VIP** generates APB3 bus transactions to stimulate the DUT.
It accurately models the **two-phase APB3 transfer**:

1. **Setup phase**
2. **Access phase**

### Supported Transactions

* APB3 **Write**
* APB3 **Read**
* Back-to-back transfers
* Randomized and directed access patterns

### Master VIP Components

* **Sequencer**

  * Accepts APB3 read/write sequences
  * Supports constrained-random traffic
* **Driver**

  * Drives `PSEL`, `PENABLE`, `PADDR`, `PWRITE`, `PWDATA`
  * Waits for `PREADY` before completing transfers
* **Monitor**

  * Observes APB3 bus activity
  * Converts pin-level signals into transaction objects
* **Coverage Collector**

  * Read vs write coverage
  * Address range coverage
  * Wait-state coverage
  * Error response coverage

### Configurable Parameters

* Address width
* Data width
* Maximum wait cycles
* Enable/disable protocol checking
* Active or passive mode selection

---

##  APB3 Slave VIP

### Purpose

The **APB3 Slave VIP** models peripheral behavior and responds to APB3 master requests.
It is useful for verifying **APB masters, interconnects, and bridges**.

### Slave VIP Capabilities

* Programmable register/memory model
* Configurable wait-state insertion
* Error response generation using `PSLVERR`
* Address-based read data generation

### Slave VIP Components

* **Driver**

  * Drives `PREADY`, `PRDATA`, `PSLVERR`
  * Inserts wait states based on configuration
* **Monitor**

  * Observes incoming APB3 transactions
  * Checks protocol correctness
* **Optional Scoreboard**

  * Compares expected vs actual read/write data
* **Coverage**

  * Address access coverage
  * Error vs non-error responses
  * Timing-related scenarios

---

## 🛡️ APB3 Protocol Checking (Assertions)

The VIP includes **SystemVerilog Assertions (SVA)** to validate APB3 protocol rules, such as:

* `PSEL` must be asserted during setup phase
* `PENABLE` must be asserted only in access phase
* Address and control signals must remain stable during access
* `PREADY` sampled only when `PENABLE` is high
* Correct handling of `PSLVERR`

These checks help detect **protocol violations early** in simulation and formal verification.

---

## 📊 Functional Coverage

Functional coverage is collected to ensure completeness, including:

* Read vs write transactions
* Address range coverage
* Data value distribution
* Wait-state variations
* Error response scenarios

Coverage metrics assist in achieving **verification closure**.

---

## 🧪 Testbench Architecture

The VIP follows a modular UVM testbench structure:

## ⚙️ Configuration & Reuse

* Uses `uvm_config_db` for run-time configuration
* Parameterized APB interface
* Easy integration into existing UVM environments
* Reusable across multiple APB3-based designs

---

## 🛠️ Tools & Technology

* **Language**: SystemVerilog
* **Methodology**: UVM
* **Simulators**: VCS / Xcelium / Questa
* **Debug**: Verdi / SimVision

---

## Typical Use Cases

* Verifying APB3 peripherals (UART, GPIO, Timers)
* Verifying APB3 master controllers
* Verifying AHB-to-APB3 bridges
* Protocol compliance and regression testing

---

## 📜 License

This project is intended for **educational and demonstration purposes**.
Please review and adapt before using in production environments.
