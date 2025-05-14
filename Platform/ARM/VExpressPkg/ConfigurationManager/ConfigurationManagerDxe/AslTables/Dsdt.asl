/** @file
  Differentiated System Description Table Fields (DSDT)

  Copyright (c) 2014-2023, ARM Ltd. All rights reserved.<BR>
  Copyright (c) 2013, Al Stone <al.stone@linaro.org>
  All rights reserved.

  SPDX-License-Identifier: BSD-2-Clause-Patent

**/

DefinitionBlock("DsdtTable.aml", "DSDT", 2, "ARMLTD", "ARM-VEXP", 1) {
  Scope(_SB) {
    //
    // Processor declaration
    //
    Method (_OSC, 4, Serialized)  { // _OSC: Operating System Capabilities
      CreateDWordField (Arg3, 0x00, STS0)
      CreateDWordField (Arg3, 0x04, CAP0)
      If ((Arg0 == ToUUID ("0811b06e-4a27-44f9-8d60-3cbbc22e7b48") /* Platform-wide Capabilities */)) {
        If (!(Arg1 == One)) {
          STS0 &= ~0x1F
          STS0 |= 0x0A
        } Else {
          If ((CAP0 & 0x100)) {
            CAP0 &= ~0x100 /* No support for OS Initiated LPI */
            STS0 &= ~0x1F
            STS0 |= 0x12
          }
        }
      } Else {
        STS0 &= ~0x1F
        STS0 |= 0x06
      }
      Return (Arg3)
    }

    // SMC91X
    Device (NET0) {
      Name (_HID, "LNRO0003")
      Name (_UID, 0)

      Name (_CRS, ResourceTemplate () {
        Memory32Fixed (ReadWrite, 0x1a000000, 0x00010000)
        Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive) {0x2F}
      })
    }

    Device (SCM0)
    {
      Name (_HID, "ARML0001")  // _HID: Hardware ID
      Name (_UID, 0)  // _UID: Unique ID
      Name (_DSD, Package (2)  // _DSD: Device-Specific Data
      {
        ToUUID ("daffd814-6eba-4d8c-8a91-bc9bbf4aa301") /* Device Properties for _DSD */,
        Package ()
        {
          Package ()
          {
            "arm-arml0001-transport-pcc",// Key
            Package ()                   // Value
            {
              1,                         // Revision
	      4,			 // Count
              Package ()
              {
                0,                       // PCCT Idx
                2,                       // TransportUID
                1                        // Common Tx channel
              },
              Package ()
              {
                1,                       // PCCT Idx
                3,                       // TransportUID
                3                        // Common Rx channel
              },
              Package ()
              {
                2,                       // PCCT Idx
                0,                       // TransportUID
                0                        // Dedicated Tx channel
              },
              Package ()
              {
                3,                       // PCCT Idx
                1,                       // TransportUID
                2                        // Dedicated Rx channel
              }
                                         // End of PCC Transport Package
            }                            // End of Value
          },

          Package ()
          {
            "arm-arml0001-protocol-pcap",// Key
            Package ()                   // Value
            {
              1,                         // Revision
              Package (){},              // Protocol Transport Binding - EMPTY
              Package (){}               // Protocol Association Binding
            }                            // End of Value
          },

          Package ()
          {
            "arm-arml0001-protocol-telemetry",// Key
            Package ()                   // Value
            {
              1,                         // Revision
              Package ()                 // Protocol Transport Binding
	      {
		Package ()
		{
		  0,
		  0
		},
		Package ()
		{
		  1,
		  0
		}
	      },
              Package (){}               // Protocol Association Binding
            }                            // End of Value
          }
        }
      })                                 // _DSD()
    }

    // VIRTIO block device
    Device (VIRT) {
      Name (_HID, "LNRO0005")
      Name (_UID, 0)

      Name (_CRS, ResourceTemplate() {
        Memory32Fixed (ReadWrite, 0x1c130000, 0x1000)
        Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive) {0x4A}
      })
    }
  } // Scope(_SB)
}
