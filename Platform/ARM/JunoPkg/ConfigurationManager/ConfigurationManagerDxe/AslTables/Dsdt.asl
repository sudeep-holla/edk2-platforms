/** @file
  Differentiated System Description Table Fields (DSDT)

  Copyright (c) 2014 - 2021, ARM Ltd. All rights reserved.<BR>
    SPDX-License-Identifier: BSD-2-Clause-Patent

**/

#include "ArmPlatform.h"

DefinitionBlock("DsdtTable.aml", "DSDT", 2, "ARMLTD", "ARM-JUNO", EFI_ACPI_ARM_OEM_REVISION) {
  Scope(_SB) {
    //
    // A57x2-A53x4 Processor declaration
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
    //
    // LAN9118 Ethernet
    //
    Device(ETH0) {
      Name(_HID, "ARMH9118")
      Name(_UID, Zero)
      Name(_CRS, ResourceTemplate() {
              Memory32Fixed(ReadWrite, 0x18000000, 0x1000)
              Interrupt(ResourceConsumer, Level, ActiveHigh, Exclusive) { 192 }
      })
      Name(_DSD, Package() {
                   ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
                       Package() {
                               Package(2) {"phy-mode", "mii"},
                               Package(2) {"reg-io-width", 4 },
                               Package(2) {"smsc,irq-active-high",1},
                               Package(2) {"smsc,irq-push-pull",1}
                      }
      }) // _DSD()
    }
  } // Scope(_SB)
}
