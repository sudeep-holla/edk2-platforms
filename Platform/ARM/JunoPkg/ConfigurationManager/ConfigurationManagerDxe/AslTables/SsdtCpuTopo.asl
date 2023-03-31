/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20230628 (64-bit version)
 * Copyright (c) 2000 - 2023 Intel Corporation
 *
 * Disassembling to symbolic ASL+ operators
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x0000033E (830)
 *     Revision         0x02
 *     Checksum         0x81
 *     OEM ID           "ARMLTD"
 *     OEM Table ID     "CPU-TOPO"
 *     OEM Revision     0x00010000 (65536)
 *     Compiler ID      "DYNT"
 *     Compiler Version 0x00010000 (65536)
 */
DefinitionBlock ("SsdtCpuTopo.aml", "SSDT", 2, "ARMLTD", "CPU-TOPO", 0x00010000)
{
    Scope (\_SB)
    {
        OperationRegion (PFRM, PCC, Zero, 0x74)
        Field (PFRM, ByteAcc, NoLock, Preserve)
        {
            SIGN,   32,
            FLGS,   32,
            LEN,    32,
            CMD,    32,
            DATA,   800
        }

        Method (_REG, 2, NotSerialized)  // _REG: Region Availability
        {
        }

        Method (PS03, 0, Serialized)
        {
            Name (BUFF, Buffer (0x0C) {})
            CreateDWordField (BUFF, Zero, WD0)
            CreateDWordField (BUFF, 0x04, WD1)
            CreateDWordField (BUFF, 0x08, WD2)
            WD0 = 0x50434300
            SIGN = BUFF /* \_SB_.PS03.BUFF */
            WD0 = One
            FLGS = BUFF /* \_SB_.PS03.BUFF */
            WD0 = 0x10
            LEN = BUFF /* \_SB_.PS03.BUFF */
            WD0 = Zero
            WD1 = 0x08
            WD2 = Zero
            DATA = BUFF /* \_SB_.PS03.BUFF */
            WD0 = 0x4404
            CMD = BUFF /* \_SB_.PS03.BUFF */
        }

        Device (CLU0)
        {
            Name (_HID, "ACPI0010" /* Processor Container Device */)  // _HID: Hardware ID
            Name (_UID, One)  // _UID: Unique ID
            Name (_LPI, Package (0x04)  // _LPI: Low Power Idle States
            {
                Zero,
                Zero,
                One,
                Package (0x0A)
                {
                    0x09C4,
                    0x047E,
                    One,
                    One,
                    0x64,
                    Zero,
                    0x01000000,
                    ResourceTemplate ()
                    {
                        Register (SystemMemory,
                            0x00,               // Bit Width
                            0x00,               // Bit Offset
                            0x0000000000000000, // Address
                            ,)
                    },

                    ResourceTemplate ()
                    {
                        Register (SystemMemory,
                            0x00,               // Bit Width
                            0x00,               // Bit Offset
                            0x0000000000000000, // Address
                            ,)
                    },

                    "CluPwrDn"
                }
            })
            Name (PLPI, Package (0x05)
            {
                Zero,
                Zero,
                0x02,
                Package (0x0A)
                {
                    One,
                    One,
                    One,
                    Zero,
                    0x64,
                    Zero,
                    ResourceTemplate ()
                    {
                        Register (FFixedHW,
                            0x20,               // Bit Width
                            0x00,               // Bit Offset
                            0x00000000FFFFFFFF, // Address
                            0x03,               // Access Size
                            )
                    },

                    ResourceTemplate ()
                    {
                        Register (SystemMemory,
                            0x00,               // Bit Width
                            0x00,               // Bit Offset
                            0x0000000000000000, // Address
                            ,)
                    },

                    ResourceTemplate ()
                    {
                        Register (SystemMemory,
                            0x00,               // Bit Width
                            0x00,               // Bit Offset
                            0x0000000000000000, // Address
                            ,)
                    },

                    "WFI"
                },

                Package (0x0A)
                {
                    0x96,
                    0x015E,
                    One,
                    One,
                    0x64,
                    One,
                    ResourceTemplate ()
                    {
                        Register (FFixedHW,
                            0x20,               // Bit Width
                            0x00,               // Bit Offset
                            0x0000000000010000, // Address
                            0x03,               // Access Size
                            )
                    },

                    ResourceTemplate ()
                    {
                        Register (SystemMemory,
                            0x00,               // Bit Width
                            0x00,               // Bit Offset
                            0x0000000000000000, // Address
                            ,)
                    },

                    ResourceTemplate ()
                    {
                        Register (SystemMemory,
                            0x00,               // Bit Width
                            0x00,               // Bit Offset
                            0x0000000000000000, // Address
                            ,)
                    },

                    "CorePwrDn"
                }
            })
            Device (CPU0)
            {
                Name (_HID, "ACPI0007" /* Processor Device */)  // _HID: Hardware ID
                Name (_UID, Zero)  // _UID: Unique ID
                Method (_LPI, 0, NotSerialized)  // _LPI: Low Power Idle States
                {
                    Return (PLPI) /* \_SB_.CLU0.PLPI */
                }

                Name (_PSD, Package (0x01)  // _PSD: Power State Dependencies
                {
                    Package (0x05)
                    {
                        0x05,
                        Zero,
                        Zero,
                        0xFD,
                        0x02
                    }
                })

                Device (ETM0)
                {
                    Name (_HID, "ARMHC500")  // _HID: Hardware ID
                    Name (_CID, "ARMHC500")  // _CID: Compatible ID
                    Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                    {
                        Memory32Fixed (ReadWrite,
                            0x22040000,         // Address Base
                            0x00001000,         // Address Length
                            )
                    })
                    Name (_DSD, Package (0x02)  // _DSD: Device-Specific Data
                    {
                        ToUUID ("ab02a46b-74c7-45a2-bd68-f7d344ef2153") /* Device Graphs for _DSD */,
                        Package (0x03)
                        {
                            Zero,
                            One,
                            Package (0x04)
                            {
                                One,
                                ToUUID ("3ecbc8b6-1d0e-4fb3-8107-e627f805c6cd") /* ARM Coresight Graph */,
                                One,
                                Package (0x04)
                                {
                                    Zero,
                                    Zero,
                                    FUN0,
                                    One
                                }
                            }
                        }
                    })
                    Method (_PS0, 0, Serialized)  // _PS0: Power State 0
                    {
                        PS03 ()
                    }

                    Method (_PS3, 0, Serialized)  // _PS3: Power State 3
                    {
                        PS03 ()
                    }

                    Method (_PSC, 0, Serialized)  // _PSC
                    {
                        Return (3)
                    }
                }
            }

            Device (CPU1)
            {
                Name (_HID, "ACPI0007" /* Processor Device */)  // _HID: Hardware ID
                Name (_UID, One)  // _UID: Unique ID
                Method (_LPI, 0, NotSerialized)  // _LPI: Low Power Idle States
                {
                    Return (PLPI) /* \_SB_.CLU0.PLPI */
                }

                Name (_PSD, Package (0x01)  // _PSD: Power State Dependencies
                {
                    Package (0x05)
                    {
                        0x05,
                        Zero,
                        Zero,
                        0xFD,
                        0x02
                    }
                })

                Device (ETM1)
                {
                    Name (_HID, "ARMHC500")  // _HID: Hardware ID
                    Name (_CID, "ARMHC500")  // _CID: Compatible ID
                    Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                    {
                        Memory32Fixed (ReadWrite,
                            0x22140000,         // Address Base
                            0x00001000,         // Address Length
                            )
                    })
                    Name (_DSD, Package (0x02)  // _DSD: Device-Specific Data
                    {
                        ToUUID ("ab02a46b-74c7-45a2-bd68-f7d344ef2153") /* Device Graphs for _DSD */,
                        Package (0x03)
                        {
                            Zero,
                            One,
                            Package (0x04)
                            {
                                One,
                                ToUUID ("3ecbc8b6-1d0e-4fb3-8107-e627f805c6cd") /* ARM Coresight Graph */,
                                One,
                                Package (0x04)
                                {
                                    Zero,
                                    One,
                                    FUN0,
                                    One
                                }
                            }
                        }
                    })
                    Method (_PS0, 0, Serialized)  // _PS0: Power State 0
                    {
                        PS03 ()
                    }

                    Method (_PS3, 0, Serialized)  // _PS3: Power State 3
                    {
                        PS03 ()
                    }

                    Method (_PSC, 0, Serialized)  // _PSC
                    {
                        Return (3)
                    }
                }
            }

            Device (FUN0)
            {
                Name (_HID, "ARMHC9FF")  // _HID: Hardware ID
                Name (_CID, "ARMHC9FF")  // _CID: Compatible ID
                Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                {
                    Memory32Fixed (ReadWrite,
                        0x220C0000,         // Address Base
                        0x00001000,         // Address Length
                        )
                })
                Name (_DSD, Package (0x02)  // _DSD: Device-Specific Data
                {
                    ToUUID ("ab02a46b-74c7-45a2-bd68-f7d344ef2153") /* Device Graphs for _DSD */,
                    Package (0x03)
                    {
                        Zero,
                        One,
                        Package (0x06)
                        {
                            One,
                            ToUUID ("3ecbc8b6-1d0e-4fb3-8107-e627f805c6cd") /* ARM Coresight Graph */,
                            0x03,
                            Package (0x04)
                            {
                                Zero,
                                Zero,
                                MFUN,
                                One
                            },

                            Package (0x04)
                            {
                                Zero,
                                Zero,
                                ^CPU0.ETM0,
                                Zero
                            },

                            Package (0x04)
                            {
                                One,
                                Zero,
                                ^CPU1.ETM1,
                                Zero
                            }
                        }
                    }
                })
                Method (_PS0, 0, Serialized)  // _PS0: Power State 0
                {
                    PS03 ()
                }

                Method (_PS3, 0, Serialized)  // _PS3: Power State 3
                {
                    PS03 ()
                }

                    Method (_PSC, 0, Serialized)  // _PSC
                    {
                        Return (3)
                    }
            }
        }

        Device (CLU1)
        {
            Name (_HID, "ACPI0010" /* Processor Container Device */)  // _HID: Hardware ID
            Name (_UID, 0x02)  // _UID: Unique ID
            Name (_LPI, Package (0x04)  // _LPI: Low Power Idle States
            {
                Zero,
                Zero,
                One,
                Package (0x0A)
                {
                    0x09C4,
                    0x047E,
                    One,
                    One,
                    0x64,
                    Zero,
                    0x01000000,
                    ResourceTemplate ()
                    {
                        Register (SystemMemory,
                            0x00,               // Bit Width
                            0x00,               // Bit Offset
                            0x0000000000000000, // Address
                            ,)
                    },

                    ResourceTemplate ()
                    {
                        Register (SystemMemory,
                            0x00,               // Bit Width
                            0x00,               // Bit Offset
                            0x0000000000000000, // Address
                            ,)
                    },

                    "CluPwrDn"
                }
            })
            Name (PLPI, Package (0x05)
            {
                Zero,
                Zero,
                0x02,
                Package (0x0A)
                {
                    One,
                    One,
                    One,
                    Zero,
                    0x64,
                    Zero,
                    ResourceTemplate ()
                    {
                        Register (FFixedHW,
                            0x20,               // Bit Width
                            0x00,               // Bit Offset
                            0x00000000FFFFFFFF, // Address
                            0x03,               // Access Size
                            )
                    },

                    ResourceTemplate ()
                    {
                        Register (SystemMemory,
                            0x00,               // Bit Width
                            0x00,               // Bit Offset
                            0x0000000000000000, // Address
                            ,)
                    },

                    ResourceTemplate ()
                    {
                        Register (SystemMemory,
                            0x00,               // Bit Width
                            0x00,               // Bit Offset
                            0x0000000000000000, // Address
                            ,)
                    },

                    "WFI"
                },

                Package (0x0A)
                {
                    0x96,
                    0x015E,
                    One,
                    One,
                    0x64,
                    One,
                    ResourceTemplate ()
                    {
                        Register (FFixedHW,
                            0x20,               // Bit Width
                            0x00,               // Bit Offset
                            0x0000000000010000, // Address
                            0x03,               // Access Size
                            )
                    },

                    ResourceTemplate ()
                    {
                        Register (SystemMemory,
                            0x00,               // Bit Width
                            0x00,               // Bit Offset
                            0x0000000000000000, // Address
                            ,)
                    },

                    ResourceTemplate ()
                    {
                        Register (SystemMemory,
                            0x00,               // Bit Width
                            0x00,               // Bit Offset
                            0x0000000000000000, // Address
                            ,)
                    },

                    "CorePwrDn"
                }
            })
            Device (CPU2)
            {
                Name (_HID, "ACPI0007" /* Processor Device */)  // _HID: Hardware ID
                Name (_UID, 0x02)  // _UID: Unique ID
                Method (_LPI, 0, NotSerialized)  // _LPI: Low Power Idle States
                {
                    Return (PLPI) /* \_SB_.CLU1.PLPI */
                }

                Name (_PSD, Package (0x01)  // _PSD: Power State Dependencies
                {
                    Package (0x05)
                    {
                        0x05,
                        Zero,
                        One,
                        0xFD,
                        0x04
                    }
                })

                Device (ETM2)
                {
                    Name (_HID, "ARMHC500")  // _HID: Hardware ID
                    Name (_CID, "ARMHC500")  // _CID: Compatible ID
                    Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                    {
                        Memory32Fixed (ReadWrite,
                            0x23040000,         // Address Base
                            0x00001000,         // Address Length
                            )
                    })
                    Name (_DSD, Package (0x02)  // _DSD: Device-Specific Data
                    {
                        ToUUID ("ab02a46b-74c7-45a2-bd68-f7d344ef2153") /* Device Graphs for _DSD */,
                        Package (0x03)
                        {
                            Zero,
                            One,
                            Package (0x04)
                            {
                                One,
                                ToUUID ("3ecbc8b6-1d0e-4fb3-8107-e627f805c6cd") /* ARM Coresight Graph */,
                                One,
                                Package (0x04)
                                {
                                    Zero,
                                    Zero,
                                    FUN1,
                                    One
                                }
                            }
                        }
                    })
                    Method (_PS0, 0, Serialized)  // _PS0: Power State 0
                    {
                        PS03 ()
                    }

                    Method (_PS3, 0, Serialized)  // _PS3: Power State 3
                    {
                        PS03 ()
                    }

                    Method (_PSC, 0, Serialized)  // _PSC
                    {
                        Return (3)
                    }
                }
            }

            Device (CPU3)
            {
                Name (_HID, "ACPI0007" /* Processor Device */)  // _HID: Hardware ID
                Name (_UID, 0x03)  // _UID: Unique ID
                Method (_LPI, 0, NotSerialized)  // _LPI: Low Power Idle States
                {
                    Return (PLPI) /* \_SB_.CLU1.PLPI */
                }

                Name (_PSD, Package (0x01)  // _PSD: Power State Dependencies
                {
                    Package (0x05)
                    {
                        0x05,
                        Zero,
                        One,
                        0xFD,
                        0x04
                    }
                })

                Device (ETM3)
                {
                    Name (_HID, "ARMHC500")  // _HID: Hardware ID
                    Name (_CID, "ARMHC500")  // _CID: Compatible ID
                    Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                    {
                        Memory32Fixed (ReadWrite,
                            0x23140000,         // Address Base
                            0x00001000,         // Address Length
                            )
                    })
                    Name (_DSD, Package (0x02)  // _DSD: Device-Specific Data
                    {
                        ToUUID ("ab02a46b-74c7-45a2-bd68-f7d344ef2153") /* Device Graphs for _DSD */,
                        Package (0x03)
                        {
                            Zero,
                            One,
                            Package (0x04)
                            {
                                One,
                                ToUUID ("3ecbc8b6-1d0e-4fb3-8107-e627f805c6cd") /* ARM Coresight Graph */,
                                One,
                                Package (0x04)
                                {
                                    Zero,
                                    One,
                                    FUN1,
                                    One
                                }
                            }
                        }
                    })
                    Method (_PS0, 0, Serialized)  // _PS0: Power State 0
                    {
                        PS03 ()
                    }

                    Method (_PS3, 0, Serialized)  // _PS3: Power State 3
                    {
                        PS03 ()
                    }

                    Method (_PSC, 0, Serialized)  // _PSC
                    {
                        Return (3)
                    }
                }
            }

            Device (CPU4)
            {
                Name (_HID, "ACPI0007" /* Processor Device */)  // _HID: Hardware ID
                Name (_UID, 0x04)  // _UID: Unique ID
                Method (_LPI, 0, NotSerialized)  // _LPI: Low Power Idle States
                {
                    Return (PLPI) /* \_SB_.CLU1.PLPI */
                }

                Name (_PSD, Package (0x01)  // _PSD: Power State Dependencies
                {
                    Package (0x05)
                    {
                        0x05,
                        Zero,
                        One,
                        0xFD,
                        0x04
                    }
                })

                Device (ETM4)
                {
                    Name (_HID, "ARMHC500")  // _HID: Hardware ID
                    Name (_CID, "ARMHC500")  // _CID: Compatible ID
                    Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                    {
                        Memory32Fixed (ReadWrite,
                            0x23240000,         // Address Base
                            0x00001000,         // Address Length
                            )
                    })
                    Name (_DSD, Package (0x02)  // _DSD: Device-Specific Data
                    {
                        ToUUID ("ab02a46b-74c7-45a2-bd68-f7d344ef2153") /* Device Graphs for _DSD */,
                        Package (0x03)
                        {
                            Zero,
                            One,
                            Package (0x04)
                            {
                                One,
                                ToUUID ("3ecbc8b6-1d0e-4fb3-8107-e627f805c6cd") /* ARM Coresight Graph */,
                                One,
                                Package (0x04)
                                {
                                    Zero,
                                    0x02,
                                    FUN1,
                                    One
                                }
                            }
                        }
                    })
                    Method (_PS0, 0, Serialized)  // _PS0: Power State 0
                    {
                        PS03 ()
                    }

                    Method (_PS3, 0, Serialized)  // _PS3: Power State 3
                    {
                        PS03 ()
                    }

                    Method (_PSC, 0, Serialized)  // _PSC
                    {
                        Return (3)
                    }
                }
            }

            Device (CPU5)
            {
                Name (_HID, "ACPI0007" /* Processor Device */)  // _HID: Hardware ID
                Name (_UID, 0x05)  // _UID: Unique ID
                Method (_LPI, 0, NotSerialized)  // _LPI: Low Power Idle States
                {
                    Return (PLPI) /* \_SB_.CLU1.PLPI */
                }

                Name (_PSD, Package (0x01)  // _PSD: Power State Dependencies
                {
                    Package (0x05)
                    {
                        0x05,
                        Zero,
                        One,
                        0xFD,
                        0x04
                    }
                })

                Device (ETM5)
                {
                    Name (_HID, "ARMHC500")  // _HID: Hardware ID
                    Name (_CID, "ARMHC500")  // _CID: Compatible ID
                    Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                    {
                        Memory32Fixed (ReadWrite,
                            0x23340000,         // Address Base
                            0x00001000,         // Address Length
                            )
                    })
                    Name (_DSD, Package (0x02)  // _DSD: Device-Specific Data
                    {
                        ToUUID ("ab02a46b-74c7-45a2-bd68-f7d344ef2153") /* Device Graphs for _DSD */,
                        Package (0x03)
                        {
                            Zero,
                            One,
                            Package (0x04)
                            {
                                One,
                                ToUUID ("3ecbc8b6-1d0e-4fb3-8107-e627f805c6cd") /* ARM Coresight Graph */,
                                One,
                                Package (0x04)
                                {
                                    Zero,
                                    0x03,
                                    FUN1,
                                    One
                                }
                            }
                        }
                    })
                    Method (_PS0, 0, Serialized)  // _PS0: Power State 0
                    {
                        PS03 ()
                    }

                    Method (_PS3, 0, Serialized)  // _PS3: Power State 3
                    {
                        PS03 ()
                    }

                    Method (_PSC, 0, Serialized)  // _PSC
                    {
                        Return (3)
                    }
                }
            }

            Device (FUN1)
            {
                Name (_HID, "ARMHC9FF")  // _HID: Hardware ID
                Name (_CID, "ARMHC9FF")  // _CID: Compatible ID
                Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                {
                    Memory32Fixed (ReadWrite,
                        0x230C0000,         // Address Base
                        0x00001000,         // Address Length
                        )
                })
                Name (_DSD, Package (0x02)  // _DSD: Device-Specific Data
                {
                    ToUUID ("ab02a46b-74c7-45a2-bd68-f7d344ef2153") /* Device Graphs for _DSD */,
                    Package (0x03)
                    {
                        Zero,
                        One,
                        Package (0x08)
                        {
                            One,
                            ToUUID ("3ecbc8b6-1d0e-4fb3-8107-e627f805c6cd") /* ARM Coresight Graph */,
                            0x05,
                            Package (0x04)
                            {
                                Zero,
                                One,
                                MFUN,
                                One
                            },

                            Package (0x04)
                            {
                                Zero,
                                Zero,
                                ^CPU2.ETM2,
                                Zero
                            },

                            Package (0x04)
                            {
                                One,
                                Zero,
                                ^CPU3.ETM3,
                                Zero
                            },

                            Package (0x04)
                            {
                                0x02,
                                Zero,
                                ^CPU4.ETM4,
                                Zero
                            },

                            Package (0x04)
                            {
                                0x03,
                                Zero,
                                ^CPU5.ETM5,
                                Zero
                            }
                        }
                    }
                })
                Method (_PS0, 0, Serialized)  // _PS0: Power State 0
                {
                    PS03 ()
                }

                Method (_PS3, 0, Serialized)  // _PS3: Power State 3
                {
                    PS03 ()
                }

	        Method (_PSC, 0, Serialized)  // _PSC
	        {
		    Return (3)
	        }
            }
        }

        Device (STM0)
        {
            Name (_HID, "ARMHC502")  // _HID: Hardware ID
            Name (_CID, "ARMHC502")  // _CID: Compatible ID
            Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
            {
                Memory32Fixed (ReadWrite,
                    0x20100000,         // Address Base
                    0x00001000,         // Address Length
                    )
                Memory32Fixed (ReadWrite,
                    0x28000000,         // Address Base
                    0x01000000,         // Address Length
                    )
            })
            Name (_DSD, Package (0x02)  // _DSD: Device-Specific Data
            {
                ToUUID ("ab02a46b-74c7-45a2-bd68-f7d344ef2153") /* Device Graphs for _DSD */,
                Package (0x03)
                {
                    Zero,
                    One,
                    Package (0x04)
                    {
                        One,
                        ToUUID ("3ecbc8b6-1d0e-4fb3-8107-e627f805c6cd") /* ARM Coresight Graph */,
                        One,
                        Package (0x04)
                        {
                            Zero,
                            0x02,
                            MFUN,
                            One
                        }
                    }
                }
            })
            Method (_PS0, 0, Serialized)  // _PS0: Power State 0
            {
                PS03 ()
            }

            Method (_PS3, 0, Serialized)  // _PS3: Power State 3
            {
                PS03 ()
            }

	    Method (_PSC, 0, Serialized)  // _PSC
	    {
		Return (3)
	    }
        }

        Device (MFUN)
        {
            Name (_HID, "ARMHC9FF")  // _HID: Hardware ID
            Name (_CID, "ARMHC9FF")  // _CID: Compatible ID
            Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
            {
                Memory32Fixed (ReadWrite,
                    0x20040000,         // Address Base
                    0x00001000,         // Address Length
                    )
            })
            Name (_DSD, Package (0x02)  // _DSD: Device-Specific Data
            {
                ToUUID ("ab02a46b-74c7-45a2-bd68-f7d344ef2153") /* Device Graphs for _DSD */,
                Package (0x03)
                {
                    Zero,
                    One,
                    Package (0x07)
                    {
                        One,
                        ToUUID ("3ecbc8b6-1d0e-4fb3-8107-e627f805c6cd") /* ARM Coresight Graph */,
                        0x04,
                        Package (0x04)
                        {
                            Zero,
                            Zero,
                            ETF0,
                            One
                        },

                        Package (0x04)
                        {
                            Zero,
                            Zero,
                            ^CLU0.FUN0,
                            Zero
                        },

                        Package (0x04)
                        {
                            One,
                            Zero,
                            ^CLU1.FUN1,
                            Zero
                        },

                        Package (0x04)
                        {
                            0x02,
                            Zero,
                            STM0,
                            Zero
                        }
                    }
                }
            })
            Method (_PS0, 0, Serialized)  // _PS0: Power State 0
            {
                PS03 ()
            }

            Method (_PS3, 0, Serialized)  // _PS3: Power State 3
            {
                PS03 ()
            }

	    Method (_PSC, 0, Serialized)  // _PSC
	    {
		Return (3)
	    }
        }

        Device (ETF0)
        {
            Name (_HID, "ARMHC97C")  // _HID: Hardware ID
            Name (_CID, "ARMHC97C")  // _CID: Compatible ID
            Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
            {
                Memory32Fixed (ReadWrite,
                    0x20010000,         // Address Base
                    0x00001000,         // Address Length
                    )
            })
            Name (_DSD, Package (0x02)  // _DSD: Device-Specific Data
            {
                ToUUID ("ab02a46b-74c7-45a2-bd68-f7d344ef2153") /* Device Graphs for _DSD */,
                Package (0x03)
                {
                    Zero,
                    One,
                    Package (0x05)
                    {
                        One,
                        ToUUID ("3ecbc8b6-1d0e-4fb3-8107-e627f805c6cd") /* ARM Coresight Graph */,
                        0x02,
                        Package (0x04)
                        {
                            Zero,
                            One,
                            RPL,
                            One
                        },

                        Package (0x04)
                        {
                            Zero,
                            Zero,
                            MFUN,
                            Zero
                        }
                    }
                }
            })
            Method (_PS0, 0, Serialized)  // _PS0: Power State 0
            {
                PS03 ()
            }

            Method (_PS3, 0, Serialized)  // _PS3: Power State 3
            {
                PS03 ()
            }

	    Method (_PSC, 0, Serialized)  // _PSC
	    {
		Return (3)
	    }
        }

        Device (RPL)
        {
            Name (_HID, "ARMHC98D")  // _HID: Hardware ID
            Name (_CID, "ARMHC98D")  // _CID: Compatible ID
            Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
            {
                Memory32Fixed (ReadWrite,
                    0x20120000,         // Address Base
                    0x00001000,         // Address Length
                    )
            })
            Name (_DSD, Package (0x02)  // _DSD: Device-Specific Data
            {
                ToUUID ("ab02a46b-74c7-45a2-bd68-f7d344ef2153") /* Device Graphs for _DSD */,
                Package (0x03)
                {
                    Zero,
                    One,
                    Package (0x06)
                    {
                        One,
                        ToUUID ("3ecbc8b6-1d0e-4fb3-8107-e627f805c6cd") /* ARM Coresight Graph */,
                        0x03,
                        Package (0x04)
                        {
                            Zero,
                            Zero,
                            TPIU,
                            One
                        },

                        Package (0x04)
                        {
                            One,
                            Zero,
                            ETR,
                            One
                        },

                        Package (0x04)
                        {
                            Zero,
                            Zero,
                            ETF0,
                            Zero
                        }
                    }
                }
            })
            Method (_PS0, 0, Serialized)  // _PS0: Power State 0
            {
                PS03 ()
            }

            Method (_PS3, 0, Serialized)  // _PS3: Power State 3
            {
                PS03 ()
            }

	    Method (_PSC, 0, Serialized)  // _PSC
	    {
		Return (3)
	    }
        }

        Device (ETR)
        {
            Name (_HID, "ARMHC501")  // _HID: Hardware ID
            Name (_CID, "ARMHC501")  // _CID: Compatible ID
            Name (_CCA, Zero)  // _CCA: Cache Coherency Attribute
            Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
            {
                Memory32Fixed (ReadWrite,
                    0x20070000,         // Address Base
                    0x00001000,         // Address Length
                    )
            })
            Name (_DSD, Package (0x02)  // _DSD: Device-Specific Data
            {
                ToUUID ("ab02a46b-74c7-45a2-bd68-f7d344ef2153") /* Device Graphs for _DSD */,
                Package (0x03)
                {
                    Zero,
                    One,
                    Package (0x04)
                    {
                        One,
                        ToUUID ("3ecbc8b6-1d0e-4fb3-8107-e627f805c6cd") /* ARM Coresight Graph */,
                        One,
                        Package (0x04)
                        {
                            Zero,
                            One,
                            RPL,
                            Zero
                        }
                    }
                }
            })
            Method (_PS0, 0, Serialized)  // _PS0: Power State 0
            {
                PS03 ()
            }

            Method (_PS3, 0, Serialized)  // _PS3: Power State 3
            {
                PS03 ()
            }

	    Method (_PSC, 0, Serialized)  // _PSC
	    {
		Return (3)
	    }
        }

        Device (TPIU)
        {
            Name (_HID, "ARMHC979")  // _HID: Hardware ID
            Name (_CID, "ARMHC979")  // _CID: Compatible ID
            Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
            {
                Memory32Fixed (ReadWrite,
                    0x20030000,         // Address Base
                    0x00001000,         // Address Length
                    )
            })
            Name (_DSD, Package (0x02)  // _DSD: Device-Specific Data
            {
                ToUUID ("ab02a46b-74c7-45a2-bd68-f7d344ef2153") /* Device Graphs for _DSD */,
                Package (0x03)
                {
                    Zero,
                    One,
                    Package (0x04)
                    {
                        One,
                        ToUUID ("3ecbc8b6-1d0e-4fb3-8107-e627f805c6cd") /* ARM Coresight Graph */,
                        One,
                        Package (0x04)
                        {
                            Zero,
                            Zero,
                            RPL,
                            Zero
                        }
                    }
                }
            })
            Method (_PS0, 0, Serialized)  // _PS0: Power State 0
            {
                PS03 ()
            }

            Method (_PS3, 0, Serialized)  // _PS3: Power State 3
            {
                PS03 ()
            }

	    Method (_PSC, 0, Serialized)  // _PSC
	    {
		Return (3)
	    }
        }
    }
}

