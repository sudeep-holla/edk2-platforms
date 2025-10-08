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

    OperationRegion (PFRM, PCC, 0x00, 0x74)
    Field(PFRM, ByteAcc, NoLock, Preserve) {
      SIGN, 32, // Signature field
      FLGS, 32, // Command Flags field
      LEN, 32, // Length field
      CMD, 32, // Command field
      DATA, 0x320 // Communication space of size 100 bytes
    }

    Method (_REG, 2) { // Check if OS Op region handler is available
    /*
     * Check if Arg0.Byte0 = 0xA, PCC Operation Region Supported?
     * Check if Arg0.Byte1 = 0x3, subchannel type 3 as defined in Table 14-357
     * Disallow further processing until support for Type 3 becomes available
     */
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
      Method (_PS0, 0, Serialized)
      {
        Name(BUFF, Buffer(12) {})
	CreateDWordField(BUFF, 0, WD0)
	CreateDWordField(BUFF, 4, WD1)
	CreateDWordField(BUFF, 8, WD2)

	WD0 = 0x50434300
	SIGN = BUFF
	WD0 = 0x1
	FLGS = BUFF
	WD0 = 0x10
	LEN = BUFF
	WD0 = 0x0
	WD1 = 0x8
	WD2 = 0x0
	DATA = BUFF
	WD0 = 0x4404
	CMD = BUFF
      }
      Method (_PS3, 0, Serialized)
      {
        Name(BUFF, Buffer(12) {})
	CreateDWordField(BUFF, 0, WD0)
	CreateDWordField(BUFF, 4, WD1)
	CreateDWordField(BUFF, 8, WD2)

	WD0 = 0x50434300
	SIGN = BUFF
	WD0 = 0x1
	FLGS = BUFF
	WD0 = 0x10
	LEN = BUFF
	WD0 = 0x0
	WD1 = 0x8
	WD2 = 0x0
	DATA = BUFF
	WD0 = 0x4404
	CMD = BUFF
      }
    }
  } // Scope(_SB)
}
