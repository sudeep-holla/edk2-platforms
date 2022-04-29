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

    OperationRegion(FFHR, FFixedHW, 0, 32)
    Field(FFHR, BufferAcc, NoLock, Preserve)
    {
      SMCC, 0x100 // 8 * 4 = 32 bytes
    }

    Method(PS03)
    {
      Name(BUFF, Buffer(20){})
      CreateDWordField(BUFF, 0x00, BFW0) // W0 (FID)
      CreateDWordField(BUFF, 0x04, BFW1) // W1
      CreateDWordField(BUFF, 0x8, BFW2) // W2
      CreateDWordField(BUFF, 0xC, BFW3) // W3
      CreateDWordField(BUFF, 0x10, BFW4) // W4

      BFW0 = 0x8400006F
      BFW1 = 0xc001
      BFW2 = 0x80000000
      BFW3 = 0x4D2
      BFW4 = 0x123

      BUFF = (SMCC = BUFF)
      Return(BFW0)
    }

    // SMC91X
    Device (NET0) {
      Name (_HID, "LNRO0003")
      Name (_UID, 0)

      Name (_CRS, ResourceTemplate () {
        Memory32Fixed (ReadWrite, 0x1a000000, 0x00010000)
        Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive) {0x2F}
      })

      Method (_PS0, 0, Serialized) {
        PS03()
      }
      Method (_PS3, 0, Serialized) {
        PS03()
      }

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
