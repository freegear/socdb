// i2c.h

BOOL EEPROM2RAM(void);
BOOL RAM2EEPROM(void);
void DumpEEPROM(void);
BOOL i2cWrite(BYTE b);
BYTE i2cRead(void);
void i2cHbit(void);
void i2cQbit(void);
void EepromSecure(void);
void EepromUnsecure(void);

