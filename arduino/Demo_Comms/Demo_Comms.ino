//opcode macros
#define MODE_OP     0x30
#define BUS8        0x00
#define BUS16       0x02
#define BUS32       0x04

#define GEN         0x00
#define ADD         0x08
#define MUL         0x10
#define DIV         0x18
#define LOG         0x21
#define DBG         0x28

#define EEE         0x00
#define EEP         0x01
#define EPE         0x02
#define EPP         0x03
#define PEE         0x04 //hehehehe
#define PEP         0x05
#define PPE         0x06
#define PPP         0x07

//bus info/config
#define BUS_SIZE    0x08
#define DATA_PINS   {17, 16, 3, 4, 5, 6, 7, 8}
#define INT         2
#define INTA        9
#define START       10
#define TCLK        11
#define READY       12
#define ERR         13
#define RST         15

const uint8_t data_pins[BUS_SIZE] = DATA_PINS;
const uint8_t bus_size = BUS_SIZE;
volatile uint8_t vec = 0;
volatile uint8_t err = 0;
volatile uint8_t intd = 0; //interrupt detected;
volatile uint8_t bus_mode = 0;
volatile uint8_t op_size = 0;

void setup() {
    op_size = 8;

    //data pins
    pinMode(0, OUTPUT);
    pinMode(1, OUTPUT);
    pinMode(3, OUTPUT);
    pinMode(4, OUTPUT);
    pinMode(5, OUTPUT);
    pinMode(6, OUTPUT);
    pinMode(7, OUTPUT);
    pinMode(8, OUTPUT);

    pinMode(INT, INPUT); //INT
    pinMode(INTA, OUTPUT); //INTA
    pinMode(START, OUTPUT); //START
    pinMode(TCLK, OUTPUT); //TCLK
    pinMode(READY, INPUT); //READY
    pinMode(ERR, INPUT); //ERR 
    pinMode(RST, OUTPUT); 
    pinMode(14, OUTPUT);  
    pinMode(A0, OUTPUT);  
    digitalWrite(TCLK, LOW);
    clearBus();
    attachInterrupt(digitalPinToInterrupt(INT), isr, RISING);
    delay(100);
    Serial.begin(2000000);
    delay(100);
    setMode(BUS8);
}

volatile uint8_t serial_size = 0;

void loop() {

        //uint8_t a = Serial.read();
        //uint8_t serial_size = 0;
        char buf[20] = "";
        while(serial_size == 0){
            serial_size = Serial.available();
            delay(50);
        }
        Serial.readBytes(buf, serial_size);
        String bufString = String(buf);
        delay(50);
        if(String(buf) == "rst\n"){
            rst();
            if(digitalRead(READY) == HIGH){
                Serial.println("Reset Successful");
            }
            vec = 0;
        }else if(bufString.substring(0, 4) == "mode"){
            uint8_t space1 = bufString.indexOf(' ');
            uint8_t arg1 = bufString.substring(space1 + 1).toInt();
            setMode(arg1);
        }else if(bufString == "clk\n"){
            clk_blip();
        }else if(bufString.substring(0, 3) == "log"){
            uint8_t space1 = bufString.indexOf(' ');
            uint8_t endLine = bufString.length() - 1;
            uint16_t arg1 = bufString.substring(space1 + 1, endLine).toInt();
            gLog(arg1);   
        }else if(bufString.substring(0, 3) == "add"){
            uint8_t space1 = bufString.indexOf(' ');
            uint8_t space2 = bufString.indexOf(' ', space1 + 1);
            uint8_t space3 = bufString.indexOf(' ', space2 + 1);
            uint8_t endLine = bufString.length() - 1;
            uint16_t arg1 = bufString.substring(space1 + 1, space2).toInt();
            uint16_t arg2 = bufString.substring(space2 + 1, space3).toInt();
            uint16_t arg3 = bufString.substring(space3 + 1, endLine).toInt();
            add(arg1, arg2, arg3);
        }else if(bufString.substring(0, 3) == "sub"){
            uint8_t space1 = bufString.indexOf(' ');
            uint8_t space2 = bufString.indexOf(' ', space1 + 1);
            uint8_t space3 = bufString.indexOf(' ', space2);
            uint8_t endLine = bufString.length() - 1;
            uint16_t arg1 = bufString.substring(space1 + 1, space2).toInt();
            uint16_t arg2 = bufString.substring(space2 + 1, space3).toInt();
            uint16_t arg3 = bufString.substring(space3 + 1, endLine).toInt();
            sub(arg1, arg2, arg3);
        }else if(bufString.substring(0, 3) == "mul"){
            uint8_t space1 = bufString.indexOf(' ');
            uint8_t space2 = bufString.indexOf(' ', space1 + 1);
            uint8_t space3 = bufString.indexOf(' ', space2 + 1);
            uint8_t endLine = bufString.length() - 1;
            uint16_t arg1 = bufString.substring(space1 + 1, space2).toInt();
            uint16_t arg2 = bufString.substring(space2 + 1, space3).toInt();
            uint16_t arg3 = bufString.substring(space3 + 1, endLine).toInt();
            mul(arg1, arg2, arg3);
        }else if(bufString.substring(0, 3) == "div"){
            uint8_t space1 = bufString.indexOf(' ');
            uint8_t space2 = bufString.indexOf(' ', space1 + 1);
            uint8_t space3 = bufString.indexOf(' ', space2 + 1);
            uint8_t endLine = bufString.length() - 1;
            uint16_t arg1 = bufString.substring(space1 + 1, space2).toInt();
            uint16_t arg2 = bufString.substring(space2 + 1, space3).toInt();
            uint16_t arg3 = bufString.substring(space3 + 1, endLine).toInt();
            div(arg1, arg2, arg3);
        }else if(bufString.substring(0, 3) == "gen"){
            uint8_t space1 = bufString.indexOf(' ');
            uint8_t space2 = bufString.indexOf(' ', space1 + 1);
            uint8_t endLine = bufString.length() - 1;
            uint16_t arg1 = bufString.substring(space1 + 1, space2).toInt();
            uint16_t arg2 = bufString.substring(space2 + 1, endLine).toInt();
            gen(arg1, arg2);
        }else if(bufString.substring(0, 3) == "dbg"){
            uint8_t space1 = bufString.indexOf(' ');
            uint16_t arg1 = bufString.substring(space1 + 1).toInt();
            setDbgOutput(arg1);
        }else if(bufString == "testAdd\n"){
            testAdd();
        }else if(bufString == "testMul\n"){
            testMul();
        }else if(bufString == "testDiv\n"){
            testDiv();
        }else{
            Serial.println("Invalid");
        }    
        serial_size = 0;
}

void rst() {
    digitalWrite(RST, HIGH);
    clk_blip();
    digitalWrite(RST, LOW);
}


void setDbgOutput(uint8_t sel){
    Serial.print("Setting dbg output to ");
    Serial.println(sel, DEC);
    uint8_t opcode = DBG | (sel & 0x07);
    writeUint8(opcode);
    start();
}

//swap bus direction to:
//0: INPUT
//ELSE: OUTPUT
void swapDirections(uint8_t i){
    if(i == 0){
        for(int i = 0; i < BUS_SIZE; i++){
            pinMode(data_pins[i], INPUT);
        }
    }else{
        for(int i = 0; i < BUS_SIZE; i++){
            pinMode(data_pins[i], OUTPUT);
        }
    }
}

void writeUint8(uint8_t input){ 
    swapDirections(1);
    for(uint8_t i = 0; i < 8; i++){
        digitalWrite(data_pins[i], (input >> i) & 0x01);
    }   
}

uint8_t readUint8(){
    uint8_t ret = 0;
    for(uint8_t i = 0; i < 8; i++){
        //Serial.print("PIN ");
        //Serial.print(String(data_pins[i]));
        //Serial.print(": ");
        //Serial.println(String(digitalRead(data_pins[i])));
        ret |= (digitalRead(data_pins[i]) << i);
    }
    return ret;
}

void isr(){
    noInterrupts();
    swapDirections(0);
    digitalWrite(TCLK, LOW);
    clk_blip();
    err = digitalRead(ERR);
    vec = readUint8();
    intd = 1;
    digitalWrite(INTA, HIGH);
    clk_blip();
    digitalWrite(INTA, LOW);
    interrupts();
}

void setMode(uint8_t mode){
    mode &= 0x07; //clear all but bottom 3 bits;
    bus_mode = mode; //assign bus mode
    uint8_t op = MODE_OP | mode;
    writeUint8(op);
    start();
}

uint8_t gen(uint8_t size, uint16_t poly){
    op_size = size;
    uint8_t op = GEN;
    writeUint8(op);
    start();
    writeUint8(size & 0x0F);
    clk_blip();
    write1Op(poly);
    swapDirections(0);
    while(intd == 0){}
    intd = 0;
    Serial.println("ISR Exited");
    clk_blip();
    digitalWrite(INTA, LOW);
}

uint8_t gLog(uint16_t opand){
    uint8_t opcode = LOG;
    Serial.println("Log");
    writeUint8(opcode);
    start();
    writeUint8(opand & 0xFF);
    clk_blip();
    digitalWrite(TCLK, HIGH);
    while(intd == 0){}
    intd = 0;
    clk_blip();
    digitalWrite(INTA, LOW);
    clk_blip();
    digitalWrite(INTA, LOW);
    clk_blip();
}

uint8_t add(uint16_t op1, uint16_t op2, uint8_t conv){
    uint8_t operand = ADD | (conv & 0x07);
    writeUint8(operand);
    start();

    if(write2Ops(op1, op2)){
        return 0;
    }else{
        
        while(!intd){}
        intd = 0;
 
        clk_blip();
               return vec;
    }
    
    return 0;
}

uint8_t sub(uint16_t op1, uint16_t op2, uint8_t conv){
    uint8_t operand = ADD | (conv & 0x07);
    writeUint8(operand);
    start();

    if(write2Ops(op1, op2)){
        return 0;
    }else{
        
        while(!intd){}
        intd = 0;
        clk_blip();
        clk_blip();
        return vec;
    }
    
    return 0;
}

uint8_t mul(uint16_t op1, uint16_t op2, uint8_t conv){
    uint8_t operand = MUL | (conv & 0x07);
    writeUint8(operand);
    start();

    if(write2Ops(op1, op2)){
        return 0;
    }else{
        
        while(!intd){}
        intd = 0;
        vec = readUint8();
        clk_blip();
        clk_blip();
        return vec;
    }
    
    return 0;
}

uint8_t div(uint16_t op1, uint16_t op2, uint8_t conv){
    uint8_t operand = DIV | (conv & 0x07);
    writeUint8(operand);
    start();

    if(write2Ops(op1, op2)){
        return 0;
    }else{
        
        while(!intd){}
        intd = 0;
        vec = readUint8();
        clk_blip();
        clk_blip();
        return vec;
    }
    
    return 0;
}

uint8_t write2Ops(uint16_t op1, uint16_t op2){
    if(bus_mode == 0){
        if((op_size & 0x0F) <= 4){
            writeUint8(op1 | (op2 << 4));
            digitalWrite(TCLK, HIGH);
        }else if((op_size & 0x0F) <= 8){
            writeUint8(op1 & 0x00FF);
            clk_blip();
            writeUint8(op2 & 0x00FF);
            digitalWrite(TCLK, HIGH);
        }else if((op_size & 0x0F) < 13){
            writeUint8(op1 & 0xFF);
            clk_blip();
            writeUint8(((op1 >> 8) & 0x0F) | ((op2 << 4) & 0xF0));
            clk_blip();
            writeUint8(((op2 >> 4) & 0xFF));
            digitalWrite(TCLK, HIGH);
        }else{
            writeUint8(op1 & 0xFF);
            clk_blip();
            writeUint8((op1 >> 8) & 0xFF);
            clk_blip();
            writeUint8(op2 & 0xFF);
            clk_blip();
            writeUint8((op2 >> 8) & 0xFF);
            digitalWrite(TCLK, HIGH);
        }
        return 0;
        
    }else{ //must be in bus_mode 0
        return 1;
    }
}

uint8_t write1Op(uint16_t op1){
    if(bus_mode == 0){
        if((op_size & 0x0F) <= 8){
            writeUint8(op1 & 0xFF);
            clk_blip();
        }else{
            writeUint8(op1 & 0xFF);
            clk_blip();
            writeUint8((op1 >> 8) & 0xFF);
            clk_blip();
        }
    }
}

void start(){
    digitalWrite(START, HIGH);
    digitalWrite(TCLK, HIGH);
    delay(1);
    digitalWrite(TCLK,LOW);
    digitalWrite(START, LOW);
}

void clk_blip(){
    digitalWrite(TCLK, HIGH);
    delay(1);
    digitalWrite(TCLK, LOW);
}

void clearBus(){
    digitalWrite(START, LOW);
    digitalWrite(TCLK, LOW);
    digitalWrite(INTA, LOW);
    for(int i = 0; i < 8; i++){
        digitalWrite(data_pins[i], LOW);
    }
}

void testAdd(){
    gen(8, 142);
    for(int i = 50; i < 255; i++){
        for(int j = 0; j < 255; j++){
            delay(10);
            uint8_t k = add(i, j, 7);
            Serial.print("add ");
            Serial.print(String(i));
            Serial.print(" ");
            Serial.print(String(j));
            Serial.print(" ");
            Serial.println(String(k));
        }
    }
}

void testMul(){
    gen(8, 142);
    for(int i = 50; i < 255; i++){
        for(int j = 0; j < 255; j++){
            delay(10);
            uint8_t k = add(i, j, 7);
            Serial.print("mul ");
            Serial.print(String(i));
            Serial.print(" ");
            Serial.print(String(j));
            Serial.print(" ");
            Serial.println(String(k));
        }
    }
}

void testDiv(){
    gen(8, 142);
    for(int i = 50; i < 255; i++){
        for(int j = 0; j < 255; j++){
            delay(10);
            uint8_t k = div(i, j, 7);
            Serial.print("div ");
            Serial.print(String(i));
            Serial.print(" ");
            Serial.print(String(j));
            Serial.print(" ");
            Serial.println(String(k));
        }
    }
}


