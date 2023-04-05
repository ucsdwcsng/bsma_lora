# BSMA: scalable LoRa networks using full duplex gateways

This repository accompanies the paper ["BSMA: scalable LoRa networks using full duplex gateways" by Raghav Subbaraman, Yeswanth Guntupalli, Shruti Jain, Rohit Kumar, Krishna Chintalapudi, and Dinesh Bharadia.](https://dl.acm.org/doi/abs/10.1145/3495243.3560544)

## Folder Structure

The repository is organized as follows:

```markdown
.
├── hardware
|   ├── pcb_design: Full duplex analog canceller PCB design files
├── simulator: MATLAB simulation code
└── testbed
    ├── arduino-lmic: Modified LoRa stack for Arduino compatible boards 
    ├── devices_stm32: STM32 LoRa device firmware. Arduino compatible.
    └── gateway_fpga: BSMA FPGA implementation on RFNoC (for USRP X3xx). GNURadio bindings.
```

## Simulator

The MATLAB simulator allows simulation of LoRa networks with various MAC protocols. The physical layer is abstracted out and the simulator can be used to evaluate the performance of MAC protocols in different network topologies.

To get started, run `simulator/Simulations.m`

## Cite this work

If this was useful to you, please cite the following paper:

```bibtex
@inproceedings{subbaraman2022bsma,
  title={BSMA: scalable LoRa networks using full duplex gateways},
  author={Subbaraman, Raghav and Guntupalli, Yeswanth and Jain, Shruti and Kumar, Rohit and Chintalapudi, Krishna and Bharadia, Dinesh},
  booktitle={Proceedings of the 28th Annual International Conference on Mobile Computing And Networking},
  pages={676--689},
  year={2022}
}
```

Contact: `rsubbaraman@eng.ucsd.edu`.
