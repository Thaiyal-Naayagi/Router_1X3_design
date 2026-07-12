# Router_1X3_design
This repository contains the RTL design for a 1x3 Network Router supporting variable packet lengths and operates based on FCFS(First Come First Serve) scheduling mechanism. The project was developed independently based on architectural and verification specifications provided during training at Maven Silicon.

Core Operational Features
  1. Header Validation & Dynamic Routing - The design reads the first byte (Header) to extract the payload length and destination address. Packets are routed dynamically to FIFO 0, FIFO 1, or FIFO 2 based on the 2-bit destination address field.
  2. Invalid Address Packet Dropping - If the decoded header address points to an unmapped or invalid destination, the routing logic automatically drops the entire packet to prevent congestion or routing incorrect packets to the destination.
  3. Parity Checking & Error Recovery - The internal register block calculates running parity during packet arrival and compares it against the appended trailing parity byte. In case of a mismatch (Parity Error), the target FIFO containing the corrupted packet is immediately reset, clearing out the faulty data stream completely.
