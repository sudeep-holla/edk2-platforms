/** @file
*  Platform Communications Channel Table (PCCT)
*
*  Copyright (c) 2021, ARM Limited. All rights reserved.
*
*  SPDX-License-Identifier: BSD-2-Clause-Patent
*
**/

#include "ArmPlatform.h"
#include <Library/AcpiLib.h>
#include <Library/ArmLib.h>
#include <Library/PcdLib.h>
#include <IndustryStandard/Acpi.h>

#define MHU_BASE_ADDRESS 0x2B1F0000
#define MHU_LP_OFFSET	0x0
#define MHU_HP_OFFSET	0x20
#define MHU_TX_OFFSET   0x100

#define MHU_LP_TX_ADDRESS (MHU_BASE_ADDRESS + MHU_LP_OFFSET + MHU_TX_OFFSET)
#define MHU_HP_TX_ADDRESS (MHU_BASE_ADDRESS + MHU_HP_OFFSET + MHU_TX_OFFSET)
#define MHU_LP_RX_ADDRESS (MHU_BASE_ADDRESS + MHU_LP_OFFSET)
#define MHU_HP_RX_ADDRESS (MHU_BASE_ADDRESS + MHU_HP_OFFSET)

/* AND with preserve, OR with WRITE */
#define DOORBELL_REGISTER (MHU_LP_TX_ADDRESS + 0x8)
#define DOORBELL_PRESERVE_MASK 0xFFFFFFFFFFFFFFFE
#define DOORBELL_WRITE_MASK 0x1

#define INTERRUPT_REGISTER (MHU_LP_RX_ADDRESS + 0x10)
#define INTERRUPT_PRESERVE_MASK 0xFFFFFFFFFFFFFFFE
#define INTERRUPT_WRITE_MASK 0x1

#define SHMEM_BASE_ADDRESS 0x2E000000
#define SHMEM_LP0_ADDRESS SHMEM_BASE_ADDRESS
#define SHMEM_LP1_ADDRESS (SHMEM_LP0_ADDRESS + 0x80)
#define SHMEM_HP0_ADDRESS (SHMEM_LP1_ADDRESS + 0x80)
#define SHMEM_HP1_ADDRESS (SHMEM_HP0_ADDRESS + 0x80)

#define SHMEM_ADDRESS (SHMEM_LP0_ADDRESS + 0xC)
#define SHMEM_SIZE (0x80 - 0xC)

//channel status register in shmem
#define COMMAND_REGISTER (SHMEM_LP0_ADDRESS + 0x4)
#define COMMAND_CHECK_MASK 0x1

#define COMMAND_UPDATE_PRESERVE_MASK 0xFFFFFFFFFFFFFFFE
#define COMMAND_UPDATE_WRITE_MASK 0x0

#define EFI_ACPI_6_3_PCCT_SUBSPACE_3_EXTENDED_PCC_INIT(IRQ, IRQFlags, BaseAddr,\
 Length, DBReg, DBPr, DBWr, Latency, MaxPerAccRate, MinReqTurnTime,            \
 PIAckReg, PIAckPr, PIAckWr, CMDCompReg, CMDCompCheck, CMDCompUpdReg,          \
 CMDCompUpdPr, CMDCompUpdSet, ErrReg, ErrMask)                                 \
  {                                                                            \
    EFI_ACPI_6_3_PCCT_SUBSPACE_TYPE_3_EXTENDED_PCC,      /* Type */            \
    sizeof (EFI_ACPI_6_3_PCCT_SUBSPACE_3_EXTENDED_PCC),  /* Length */          \
    IRQ,                                                 /* GSIV */            \
    IRQFlags,                                            /* PlatIrqFlags */    \
    EFI_ACPI_RESERVED_BYTE,                              /* Reserved */        \
    BaseAddr,                             /* BaseAddress */                    \
    Length,                               /* Length */                         \
    ARM_GAS32(DBReg),                     /* GASDoorbellRegister */            \
    DBPr,                                 /* DoorbellPreserve */               \
    DBWr,                                 /* DoorbellWrite */                  \
    Latency,                              /* NominalLatency */                 \
    MaxPerAccRate,                        /* MaximumPeriodicAccessRate */      \
    MinReqTurnTime,                       /* MinimumRequestTurnaroundTime */   \
    ARM_GAS32(PIAckReg),                  /* GASPlatIntAckRegister */          \
    PIAckPr,                              /* PlatIntAckPRreserve */            \
    PIAckWr,                              /* PlatIntAckWrite */                \
     {                                                                         \
      EFI_ACPI_RESERVED_BYTE,             /* Reserved8[0] */                   \
      EFI_ACPI_RESERVED_BYTE,             /* Reserved8[1] */                   \
      EFI_ACPI_RESERVED_BYTE,             /* Reserved8[2] */                   \
      EFI_ACPI_RESERVED_BYTE,             /* Reserved8[3] */                   \
      EFI_ACPI_RESERVED_BYTE,             /* Reserved8[4] */                   \
      EFI_ACPI_RESERVED_BYTE,             /* Reserved8[5] */                   \
      EFI_ACPI_RESERVED_BYTE,             /* Reserved8[6] */                   \
      EFI_ACPI_RESERVED_BYTE              /* Reserved8[7] */                   \
    },                                                                         \
    ARM_GAS32(CMDCompReg),                /* GASCommandCompleteRegister */     \
    CMDCompCheck,                         /* CommandCompleteCheckMask */       \
    ARM_GAS32(CMDCompUpdReg),             /* CommandCompleteUpdateRegister */  \
    CMDCompUpdPr,                         /* CommandCompleteUpdatePreserve */  \
    CMDCompUpdSet,                        /* CommandCompleteUpdateSet */       \
    ARM_GAS32(ErrReg),                    /* ErrorStatusRegister */            \
    ErrMask                               /* ErrorStatusMask */                \
  }


/*
 * Platform Communications Channel Table
 */

#pragma pack(1)

typedef struct {
  EFI_ACPI_6_3_PLATFORM_COMMUNICATION_CHANNEL_TABLE_HEADER Header;
  EFI_ACPI_6_3_PCCT_SUBSPACE_3_EXTENDED_PCC PCC1;
} EFI_ACPI_6_3_PLATFORM_COMMUNICATION_CHANNEL_TABLE;
#pragma pack ()

EFI_ACPI_6_3_PLATFORM_COMMUNICATION_CHANNEL_TABLE Pcct = {
  {
    ARM_ACPI_HEADER (
      EFI_ACPI_6_3_PLATFORM_COMMUNICATIONS_CHANNEL_TABLE_SIGNATURE,
      EFI_ACPI_6_3_PLATFORM_COMMUNICATION_CHANNEL_TABLE,
      EFI_ACPI_6_3_PLATFORM_COMMUNICATION_CHANNEL_TABLE_REVISION
    ),
    //PCCT Specific Fields
    1, // Interrupt
    0  // Reserved
  },
  EFI_ACPI_6_3_PCCT_SUBSPACE_3_EXTENDED_PCC_INIT(68, 0x0,/* GSIV and Flags */
    SHMEM_ADDRESS, SHMEM_SIZE, /* Shmem Addr + size */
    DOORBELL_REGISTER, DOORBELL_PRESERVE_MASK, DOORBELL_WRITE_MASK,
    5, /* Latency */
    0, /* Max Periodic Access Rate */
    10,/* Min Request Turnaround Time */
    INTERRUPT_REGISTER, INTERRUPT_PRESERVE_MASK, INTERRUPT_WRITE_MASK,
    COMMAND_REGISTER, COMMAND_CHECK_MASK,
    COMMAND_REGISTER, COMMAND_UPDATE_PRESERVE_MASK, COMMAND_UPDATE_WRITE_MASK,
    COMMAND_REGISTER, 0x2)
};