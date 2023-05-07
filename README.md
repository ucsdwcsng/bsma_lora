# BSMA: scalable LoRa networks using full duplex gateways

This repository accompanies the paper ["BSMA: scalable LoRa networks using full duplex gateways" Raghav Subbaraman, Yeswanth Guntupalli, Shruti Jain, Rohit Kumar, Krishna Chintalapudi, and Dinesh Bharadia.](https://dl.acm.org/doi/abs/10.1145/3495243.3560544)

[Link to slides from BSMA Mobicom 2022 Talk](./docs/bsma_talk_mobicom22.pdf)

## Folder Structure

The repository is organized as follows:

```markdown
.
├── docs: Additional documentation
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

To get started, run `simulator/Simulations.m`. The main file is called `Simulations.m which sets the deployment and network parameters for the simulation. These parameters include the number of cells, the radius of the cells, the number of devices per cell, the hearing range for the devices, the Medium Access Control (MAC) and latency parameters, and the offered load.

To run the code, the user needs to set the desired parameters in `Simulations.m` and then run the script. The simulation results are stored in a directory called `results` located in the same directory as `Simulations.m`. The directory is created automatically by the code and named using a timestamp. The user can modify the simulation parameters by editing the `SIMULATION PARAMETERS` section in the `Simulations.m` file.

The code includes the following functions/scripts that are called from `Simulations.m:`

- `generate_configuration_defaults.m`: generates the configuration settings for different offered loads
- `generate_configuration_varying_load.m`: generates the configuration settings for a varying offered load
- `deploy.m`: deploys the nodes and gateways in the network
- `run_simulation_vary_load_scale.m`: runs the simulation for different offered loads
- `plots_vary_load.m`: processes and plots the simulation results

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
