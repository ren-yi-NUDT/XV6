
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	1e013103          	ld	sp,480(sp) # 8000b1e0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	076000ef          	jal	8000008c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    8000003a:	6318                	ld	a4,0(a4)
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	9732                	add	a4,a4,a2
    80000046:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00259693          	slli	a3,a1,0x2
    8000004c:	96ae                	add	a3,a3,a1
    8000004e:	068e                	slli	a3,a3,0x3
    80000050:	0000b717          	auipc	a4,0xb
    80000054:	1f070713          	addi	a4,a4,496 # 8000b240 <timer_scratch>
    80000058:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005c:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000005e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000062:	00006797          	auipc	a5,0x6
    80000066:	d4e78793          	addi	a5,a5,-690 # 80005db0 <timervec>
    8000006a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000072:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000076:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000007e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000082:	30479073          	csrw	mie,a5
}
    80000086:	6422                	ld	s0,8(sp)
    80000088:	0141                	addi	sp,sp,16
    8000008a:	8082                	ret

000000008000008c <start>:
{
    8000008c:	1141                	addi	sp,sp,-16
    8000008e:	e406                	sd	ra,8(sp)
    80000090:	e022                	sd	s0,0(sp)
    80000092:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000094:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000098:	7779                	lui	a4,0xffffe
    8000009a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffda11f>
    8000009e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a0:	6705                	lui	a4,0x1
    800000a2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ac:	00001797          	auipc	a5,0x1
    800000b0:	e3e78793          	addi	a5,a5,-450 # 80000eea <main>
    800000b4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b8:	4781                	li	a5,0
    800000ba:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000be:	67c1                	lui	a5,0x10
    800000c0:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000ca:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000ce:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d6:	57fd                	li	a5,-1
    800000d8:	83a9                	srli	a5,a5,0xa
    800000da:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000de:	47bd                	li	a5,15
    800000e0:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e4:	00000097          	auipc	ra,0x0
    800000e8:	f38080e7          	jalr	-200(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ec:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000f2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f4:	30200073          	mret
}
    800000f8:	60a2                	ld	ra,8(sp)
    800000fa:	6402                	ld	s0,0(sp)
    800000fc:	0141                	addi	sp,sp,16
    800000fe:	8082                	ret

0000000080000100 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80000100:	715d                	addi	sp,sp,-80
    80000102:	e486                	sd	ra,72(sp)
    80000104:	e0a2                	sd	s0,64(sp)
    80000106:	f84a                	sd	s2,48(sp)
    80000108:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000010a:	04c05663          	blez	a2,80000156 <consolewrite+0x56>
    8000010e:	fc26                	sd	s1,56(sp)
    80000110:	f44e                	sd	s3,40(sp)
    80000112:	f052                	sd	s4,32(sp)
    80000114:	ec56                	sd	s5,24(sp)
    80000116:	8a2a                	mv	s4,a0
    80000118:	84ae                	mv	s1,a1
    8000011a:	89b2                	mv	s3,a2
    8000011c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000011e:	5afd                	li	s5,-1
    80000120:	4685                	li	a3,1
    80000122:	8626                	mv	a2,s1
    80000124:	85d2                	mv	a1,s4
    80000126:	fbf40513          	addi	a0,s0,-65
    8000012a:	00002097          	auipc	ra,0x2
    8000012e:	460080e7          	jalr	1120(ra) # 8000258a <either_copyin>
    80000132:	03550463          	beq	a0,s5,8000015a <consolewrite+0x5a>
      break;
    uartputc(c);
    80000136:	fbf44503          	lbu	a0,-65(s0)
    8000013a:	00000097          	auipc	ra,0x0
    8000013e:	7fc080e7          	jalr	2044(ra) # 80000936 <uartputc>
  for(i = 0; i < n; i++){
    80000142:	2905                	addiw	s2,s2,1
    80000144:	0485                	addi	s1,s1,1
    80000146:	fd299de3          	bne	s3,s2,80000120 <consolewrite+0x20>
    8000014a:	894e                	mv	s2,s3
    8000014c:	74e2                	ld	s1,56(sp)
    8000014e:	79a2                	ld	s3,40(sp)
    80000150:	7a02                	ld	s4,32(sp)
    80000152:	6ae2                	ld	s5,24(sp)
    80000154:	a039                	j	80000162 <consolewrite+0x62>
    80000156:	4901                	li	s2,0
    80000158:	a029                	j	80000162 <consolewrite+0x62>
    8000015a:	74e2                	ld	s1,56(sp)
    8000015c:	79a2                	ld	s3,40(sp)
    8000015e:	7a02                	ld	s4,32(sp)
    80000160:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80000162:	854a                	mv	a0,s2
    80000164:	60a6                	ld	ra,72(sp)
    80000166:	6406                	ld	s0,64(sp)
    80000168:	7942                	ld	s2,48(sp)
    8000016a:	6161                	addi	sp,sp,80
    8000016c:	8082                	ret

000000008000016e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000016e:	711d                	addi	sp,sp,-96
    80000170:	ec86                	sd	ra,88(sp)
    80000172:	e8a2                	sd	s0,80(sp)
    80000174:	e4a6                	sd	s1,72(sp)
    80000176:	e0ca                	sd	s2,64(sp)
    80000178:	fc4e                	sd	s3,56(sp)
    8000017a:	f852                	sd	s4,48(sp)
    8000017c:	f456                	sd	s5,40(sp)
    8000017e:	f05a                	sd	s6,32(sp)
    80000180:	1080                	addi	s0,sp,96
    80000182:	8aaa                	mv	s5,a0
    80000184:	8a2e                	mv	s4,a1
    80000186:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000188:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000018c:	00013517          	auipc	a0,0x13
    80000190:	1f450513          	addi	a0,a0,500 # 80013380 <cons>
    80000194:	00001097          	auipc	ra,0x1
    80000198:	abc080e7          	jalr	-1348(ra) # 80000c50 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019c:	00013497          	auipc	s1,0x13
    800001a0:	1e448493          	addi	s1,s1,484 # 80013380 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a4:	00013917          	auipc	s2,0x13
    800001a8:	27490913          	addi	s2,s2,628 # 80013418 <cons+0x98>
  while(n > 0){
    800001ac:	0d305763          	blez	s3,8000027a <consoleread+0x10c>
    while(cons.r == cons.w){
    800001b0:	0984a783          	lw	a5,152(s1)
    800001b4:	09c4a703          	lw	a4,156(s1)
    800001b8:	0af71c63          	bne	a4,a5,80000270 <consoleread+0x102>
      if(killed(myproc())){
    800001bc:	00002097          	auipc	ra,0x2
    800001c0:	8a6080e7          	jalr	-1882(ra) # 80001a62 <myproc>
    800001c4:	00002097          	auipc	ra,0x2
    800001c8:	210080e7          	jalr	528(ra) # 800023d4 <killed>
    800001cc:	e52d                	bnez	a0,80000236 <consoleread+0xc8>
      sleep(&cons.r, &cons.lock);
    800001ce:	85a6                	mv	a1,s1
    800001d0:	854a                	mv	a0,s2
    800001d2:	00002097          	auipc	ra,0x2
    800001d6:	f5a080e7          	jalr	-166(ra) # 8000212c <sleep>
    while(cons.r == cons.w){
    800001da:	0984a783          	lw	a5,152(s1)
    800001de:	09c4a703          	lw	a4,156(s1)
    800001e2:	fcf70de3          	beq	a4,a5,800001bc <consoleread+0x4e>
    800001e6:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001e8:	00013717          	auipc	a4,0x13
    800001ec:	19870713          	addi	a4,a4,408 # 80013380 <cons>
    800001f0:	0017869b          	addiw	a3,a5,1
    800001f4:	08d72c23          	sw	a3,152(a4)
    800001f8:	07f7f693          	andi	a3,a5,127
    800001fc:	9736                	add	a4,a4,a3
    800001fe:	01874703          	lbu	a4,24(a4)
    80000202:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80000206:	4691                	li	a3,4
    80000208:	04db8a63          	beq	s7,a3,8000025c <consoleread+0xee>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    8000020c:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000210:	4685                	li	a3,1
    80000212:	faf40613          	addi	a2,s0,-81
    80000216:	85d2                	mv	a1,s4
    80000218:	8556                	mv	a0,s5
    8000021a:	00002097          	auipc	ra,0x2
    8000021e:	31a080e7          	jalr	794(ra) # 80002534 <either_copyout>
    80000222:	57fd                	li	a5,-1
    80000224:	04f50a63          	beq	a0,a5,80000278 <consoleread+0x10a>
      break;

    dst++;
    80000228:	0a05                	addi	s4,s4,1
    --n;
    8000022a:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000022c:	47a9                	li	a5,10
    8000022e:	06fb8163          	beq	s7,a5,80000290 <consoleread+0x122>
    80000232:	6be2                	ld	s7,24(sp)
    80000234:	bfa5                	j	800001ac <consoleread+0x3e>
        release(&cons.lock);
    80000236:	00013517          	auipc	a0,0x13
    8000023a:	14a50513          	addi	a0,a0,330 # 80013380 <cons>
    8000023e:	00001097          	auipc	ra,0x1
    80000242:	ac6080e7          	jalr	-1338(ra) # 80000d04 <release>
        return -1;
    80000246:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80000248:	60e6                	ld	ra,88(sp)
    8000024a:	6446                	ld	s0,80(sp)
    8000024c:	64a6                	ld	s1,72(sp)
    8000024e:	6906                	ld	s2,64(sp)
    80000250:	79e2                	ld	s3,56(sp)
    80000252:	7a42                	ld	s4,48(sp)
    80000254:	7aa2                	ld	s5,40(sp)
    80000256:	7b02                	ld	s6,32(sp)
    80000258:	6125                	addi	sp,sp,96
    8000025a:	8082                	ret
      if(n < target){
    8000025c:	0009871b          	sext.w	a4,s3
    80000260:	01677a63          	bgeu	a4,s6,80000274 <consoleread+0x106>
        cons.r--;
    80000264:	00013717          	auipc	a4,0x13
    80000268:	1af72a23          	sw	a5,436(a4) # 80013418 <cons+0x98>
    8000026c:	6be2                	ld	s7,24(sp)
    8000026e:	a031                	j	8000027a <consoleread+0x10c>
    80000270:	ec5e                	sd	s7,24(sp)
    80000272:	bf9d                	j	800001e8 <consoleread+0x7a>
    80000274:	6be2                	ld	s7,24(sp)
    80000276:	a011                	j	8000027a <consoleread+0x10c>
    80000278:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    8000027a:	00013517          	auipc	a0,0x13
    8000027e:	10650513          	addi	a0,a0,262 # 80013380 <cons>
    80000282:	00001097          	auipc	ra,0x1
    80000286:	a82080e7          	jalr	-1406(ra) # 80000d04 <release>
  return target - n;
    8000028a:	413b053b          	subw	a0,s6,s3
    8000028e:	bf6d                	j	80000248 <consoleread+0xda>
    80000290:	6be2                	ld	s7,24(sp)
    80000292:	b7e5                	j	8000027a <consoleread+0x10c>

0000000080000294 <consputc>:
{
    80000294:	1141                	addi	sp,sp,-16
    80000296:	e406                	sd	ra,8(sp)
    80000298:	e022                	sd	s0,0(sp)
    8000029a:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000029c:	10000793          	li	a5,256
    800002a0:	00f50a63          	beq	a0,a5,800002b4 <consputc+0x20>
    uartputc_sync(c);
    800002a4:	00000097          	auipc	ra,0x0
    800002a8:	5b4080e7          	jalr	1460(ra) # 80000858 <uartputc_sync>
}
    800002ac:	60a2                	ld	ra,8(sp)
    800002ae:	6402                	ld	s0,0(sp)
    800002b0:	0141                	addi	sp,sp,16
    800002b2:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800002b4:	4521                	li	a0,8
    800002b6:	00000097          	auipc	ra,0x0
    800002ba:	5a2080e7          	jalr	1442(ra) # 80000858 <uartputc_sync>
    800002be:	02000513          	li	a0,32
    800002c2:	00000097          	auipc	ra,0x0
    800002c6:	596080e7          	jalr	1430(ra) # 80000858 <uartputc_sync>
    800002ca:	4521                	li	a0,8
    800002cc:	00000097          	auipc	ra,0x0
    800002d0:	58c080e7          	jalr	1420(ra) # 80000858 <uartputc_sync>
    800002d4:	bfe1                	j	800002ac <consputc+0x18>

00000000800002d6 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002d6:	1101                	addi	sp,sp,-32
    800002d8:	ec06                	sd	ra,24(sp)
    800002da:	e822                	sd	s0,16(sp)
    800002dc:	e426                	sd	s1,8(sp)
    800002de:	1000                	addi	s0,sp,32
    800002e0:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002e2:	00013517          	auipc	a0,0x13
    800002e6:	09e50513          	addi	a0,a0,158 # 80013380 <cons>
    800002ea:	00001097          	auipc	ra,0x1
    800002ee:	966080e7          	jalr	-1690(ra) # 80000c50 <acquire>

  switch(c){
    800002f2:	47d5                	li	a5,21
    800002f4:	0af48563          	beq	s1,a5,8000039e <consoleintr+0xc8>
    800002f8:	0297c963          	blt	a5,s1,8000032a <consoleintr+0x54>
    800002fc:	47a1                	li	a5,8
    800002fe:	0ef48c63          	beq	s1,a5,800003f6 <consoleintr+0x120>
    80000302:	47c1                	li	a5,16
    80000304:	10f49f63          	bne	s1,a5,80000422 <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80000308:	00002097          	auipc	ra,0x2
    8000030c:	2d8080e7          	jalr	728(ra) # 800025e0 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80000310:	00013517          	auipc	a0,0x13
    80000314:	07050513          	addi	a0,a0,112 # 80013380 <cons>
    80000318:	00001097          	auipc	ra,0x1
    8000031c:	9ec080e7          	jalr	-1556(ra) # 80000d04 <release>
}
    80000320:	60e2                	ld	ra,24(sp)
    80000322:	6442                	ld	s0,16(sp)
    80000324:	64a2                	ld	s1,8(sp)
    80000326:	6105                	addi	sp,sp,32
    80000328:	8082                	ret
  switch(c){
    8000032a:	07f00793          	li	a5,127
    8000032e:	0cf48463          	beq	s1,a5,800003f6 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000332:	00013717          	auipc	a4,0x13
    80000336:	04e70713          	addi	a4,a4,78 # 80013380 <cons>
    8000033a:	0a072783          	lw	a5,160(a4)
    8000033e:	09872703          	lw	a4,152(a4)
    80000342:	9f99                	subw	a5,a5,a4
    80000344:	07f00713          	li	a4,127
    80000348:	fcf764e3          	bltu	a4,a5,80000310 <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    8000034c:	47b5                	li	a5,13
    8000034e:	0cf48d63          	beq	s1,a5,80000428 <consoleintr+0x152>
      consputc(c);
    80000352:	8526                	mv	a0,s1
    80000354:	00000097          	auipc	ra,0x0
    80000358:	f40080e7          	jalr	-192(ra) # 80000294 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000035c:	00013797          	auipc	a5,0x13
    80000360:	02478793          	addi	a5,a5,36 # 80013380 <cons>
    80000364:	0a07a683          	lw	a3,160(a5)
    80000368:	0016871b          	addiw	a4,a3,1
    8000036c:	0007061b          	sext.w	a2,a4
    80000370:	0ae7a023          	sw	a4,160(a5)
    80000374:	07f6f693          	andi	a3,a3,127
    80000378:	97b6                	add	a5,a5,a3
    8000037a:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000037e:	47a9                	li	a5,10
    80000380:	0cf48b63          	beq	s1,a5,80000456 <consoleintr+0x180>
    80000384:	4791                	li	a5,4
    80000386:	0cf48863          	beq	s1,a5,80000456 <consoleintr+0x180>
    8000038a:	00013797          	auipc	a5,0x13
    8000038e:	08e7a783          	lw	a5,142(a5) # 80013418 <cons+0x98>
    80000392:	9f1d                	subw	a4,a4,a5
    80000394:	08000793          	li	a5,128
    80000398:	f6f71ce3          	bne	a4,a5,80000310 <consoleintr+0x3a>
    8000039c:	a86d                	j	80000456 <consoleintr+0x180>
    8000039e:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    800003a0:	00013717          	auipc	a4,0x13
    800003a4:	fe070713          	addi	a4,a4,-32 # 80013380 <cons>
    800003a8:	0a072783          	lw	a5,160(a4)
    800003ac:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003b0:	00013497          	auipc	s1,0x13
    800003b4:	fd048493          	addi	s1,s1,-48 # 80013380 <cons>
    while(cons.e != cons.w &&
    800003b8:	4929                	li	s2,10
    800003ba:	02f70a63          	beq	a4,a5,800003ee <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003be:	37fd                	addiw	a5,a5,-1
    800003c0:	07f7f713          	andi	a4,a5,127
    800003c4:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003c6:	01874703          	lbu	a4,24(a4)
    800003ca:	03270463          	beq	a4,s2,800003f2 <consoleintr+0x11c>
      cons.e--;
    800003ce:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003d2:	10000513          	li	a0,256
    800003d6:	00000097          	auipc	ra,0x0
    800003da:	ebe080e7          	jalr	-322(ra) # 80000294 <consputc>
    while(cons.e != cons.w &&
    800003de:	0a04a783          	lw	a5,160(s1)
    800003e2:	09c4a703          	lw	a4,156(s1)
    800003e6:	fcf71ce3          	bne	a4,a5,800003be <consoleintr+0xe8>
    800003ea:	6902                	ld	s2,0(sp)
    800003ec:	b715                	j	80000310 <consoleintr+0x3a>
    800003ee:	6902                	ld	s2,0(sp)
    800003f0:	b705                	j	80000310 <consoleintr+0x3a>
    800003f2:	6902                	ld	s2,0(sp)
    800003f4:	bf31                	j	80000310 <consoleintr+0x3a>
    if(cons.e != cons.w){
    800003f6:	00013717          	auipc	a4,0x13
    800003fa:	f8a70713          	addi	a4,a4,-118 # 80013380 <cons>
    800003fe:	0a072783          	lw	a5,160(a4)
    80000402:	09c72703          	lw	a4,156(a4)
    80000406:	f0f705e3          	beq	a4,a5,80000310 <consoleintr+0x3a>
      cons.e--;
    8000040a:	37fd                	addiw	a5,a5,-1
    8000040c:	00013717          	auipc	a4,0x13
    80000410:	00f72a23          	sw	a5,20(a4) # 80013420 <cons+0xa0>
      consputc(BACKSPACE);
    80000414:	10000513          	li	a0,256
    80000418:	00000097          	auipc	ra,0x0
    8000041c:	e7c080e7          	jalr	-388(ra) # 80000294 <consputc>
    80000420:	bdc5                	j	80000310 <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000422:	ee0487e3          	beqz	s1,80000310 <consoleintr+0x3a>
    80000426:	b731                	j	80000332 <consoleintr+0x5c>
      consputc(c);
    80000428:	4529                	li	a0,10
    8000042a:	00000097          	auipc	ra,0x0
    8000042e:	e6a080e7          	jalr	-406(ra) # 80000294 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000432:	00013797          	auipc	a5,0x13
    80000436:	f4e78793          	addi	a5,a5,-178 # 80013380 <cons>
    8000043a:	0a07a703          	lw	a4,160(a5)
    8000043e:	0017069b          	addiw	a3,a4,1
    80000442:	0006861b          	sext.w	a2,a3
    80000446:	0ad7a023          	sw	a3,160(a5)
    8000044a:	07f77713          	andi	a4,a4,127
    8000044e:	97ba                	add	a5,a5,a4
    80000450:	4729                	li	a4,10
    80000452:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000456:	00013797          	auipc	a5,0x13
    8000045a:	fcc7a323          	sw	a2,-58(a5) # 8001341c <cons+0x9c>
        wakeup(&cons.r);
    8000045e:	00013517          	auipc	a0,0x13
    80000462:	fba50513          	addi	a0,a0,-70 # 80013418 <cons+0x98>
    80000466:	00002097          	auipc	ra,0x2
    8000046a:	d2a080e7          	jalr	-726(ra) # 80002190 <wakeup>
    8000046e:	b54d                	j	80000310 <consoleintr+0x3a>

0000000080000470 <consoleinit>:

void
consoleinit(void)
{
    80000470:	1141                	addi	sp,sp,-16
    80000472:	e406                	sd	ra,8(sp)
    80000474:	e022                	sd	s0,0(sp)
    80000476:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000478:	00008597          	auipc	a1,0x8
    8000047c:	b8858593          	addi	a1,a1,-1144 # 80008000 <etext>
    80000480:	00013517          	auipc	a0,0x13
    80000484:	f0050513          	addi	a0,a0,-256 # 80013380 <cons>
    80000488:	00000097          	auipc	ra,0x0
    8000048c:	738080e7          	jalr	1848(ra) # 80000bc0 <initlock>

  uartinit();
    80000490:	00000097          	auipc	ra,0x0
    80000494:	36c080e7          	jalr	876(ra) # 800007fc <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000498:	00023797          	auipc	a5,0x23
    8000049c:	0b078793          	addi	a5,a5,176 # 80023548 <devsw>
    800004a0:	00000717          	auipc	a4,0x0
    800004a4:	cce70713          	addi	a4,a4,-818 # 8000016e <consoleread>
    800004a8:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800004aa:	00000717          	auipc	a4,0x0
    800004ae:	c5670713          	addi	a4,a4,-938 # 80000100 <consolewrite>
    800004b2:	ef98                	sd	a4,24(a5)
}
    800004b4:	60a2                	ld	ra,8(sp)
    800004b6:	6402                	ld	s0,0(sp)
    800004b8:	0141                	addi	sp,sp,16
    800004ba:	8082                	ret

00000000800004bc <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004bc:	7179                	addi	sp,sp,-48
    800004be:	f406                	sd	ra,40(sp)
    800004c0:	f022                	sd	s0,32(sp)
    800004c2:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004c4:	c219                	beqz	a2,800004ca <printint+0xe>
    800004c6:	08054963          	bltz	a0,80000558 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    800004ca:	2501                	sext.w	a0,a0
    800004cc:	4881                	li	a7,0
    800004ce:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004d2:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004d4:	2581                	sext.w	a1,a1
    800004d6:	00008617          	auipc	a2,0x8
    800004da:	26260613          	addi	a2,a2,610 # 80008738 <digits>
    800004de:	883a                	mv	a6,a4
    800004e0:	2705                	addiw	a4,a4,1
    800004e2:	02b577bb          	remuw	a5,a0,a1
    800004e6:	1782                	slli	a5,a5,0x20
    800004e8:	9381                	srli	a5,a5,0x20
    800004ea:	97b2                	add	a5,a5,a2
    800004ec:	0007c783          	lbu	a5,0(a5)
    800004f0:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004f4:	0005079b          	sext.w	a5,a0
    800004f8:	02b5553b          	divuw	a0,a0,a1
    800004fc:	0685                	addi	a3,a3,1
    800004fe:	feb7f0e3          	bgeu	a5,a1,800004de <printint+0x22>

  if(sign)
    80000502:	00088c63          	beqz	a7,8000051a <printint+0x5e>
    buf[i++] = '-';
    80000506:	fe070793          	addi	a5,a4,-32
    8000050a:	00878733          	add	a4,a5,s0
    8000050e:	02d00793          	li	a5,45
    80000512:	fef70823          	sb	a5,-16(a4)
    80000516:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    8000051a:	02e05b63          	blez	a4,80000550 <printint+0x94>
    8000051e:	ec26                	sd	s1,24(sp)
    80000520:	e84a                	sd	s2,16(sp)
    80000522:	fd040793          	addi	a5,s0,-48
    80000526:	00e784b3          	add	s1,a5,a4
    8000052a:	fff78913          	addi	s2,a5,-1
    8000052e:	993a                	add	s2,s2,a4
    80000530:	377d                	addiw	a4,a4,-1
    80000532:	1702                	slli	a4,a4,0x20
    80000534:	9301                	srli	a4,a4,0x20
    80000536:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000053a:	fff4c503          	lbu	a0,-1(s1)
    8000053e:	00000097          	auipc	ra,0x0
    80000542:	d56080e7          	jalr	-682(ra) # 80000294 <consputc>
  while(--i >= 0)
    80000546:	14fd                	addi	s1,s1,-1
    80000548:	ff2499e3          	bne	s1,s2,8000053a <printint+0x7e>
    8000054c:	64e2                	ld	s1,24(sp)
    8000054e:	6942                	ld	s2,16(sp)
}
    80000550:	70a2                	ld	ra,40(sp)
    80000552:	7402                	ld	s0,32(sp)
    80000554:	6145                	addi	sp,sp,48
    80000556:	8082                	ret
    x = -xx;
    80000558:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000055c:	4885                	li	a7,1
    x = -xx;
    8000055e:	bf85                	j	800004ce <printint+0x12>

0000000080000560 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80000560:	1101                	addi	sp,sp,-32
    80000562:	ec06                	sd	ra,24(sp)
    80000564:	e822                	sd	s0,16(sp)
    80000566:	e426                	sd	s1,8(sp)
    80000568:	1000                	addi	s0,sp,32
    8000056a:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000056c:	00013797          	auipc	a5,0x13
    80000570:	ec07aa23          	sw	zero,-300(a5) # 80013440 <pr+0x18>
  printf("panic: ");
    80000574:	00008517          	auipc	a0,0x8
    80000578:	a9450513          	addi	a0,a0,-1388 # 80008008 <etext+0x8>
    8000057c:	00000097          	auipc	ra,0x0
    80000580:	02e080e7          	jalr	46(ra) # 800005aa <printf>
  printf(s);
    80000584:	8526                	mv	a0,s1
    80000586:	00000097          	auipc	ra,0x0
    8000058a:	024080e7          	jalr	36(ra) # 800005aa <printf>
  printf("\n");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	a8250513          	addi	a0,a0,-1406 # 80008010 <etext+0x10>
    80000596:	00000097          	auipc	ra,0x0
    8000059a:	014080e7          	jalr	20(ra) # 800005aa <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000059e:	4785                	li	a5,1
    800005a0:	0000b717          	auipc	a4,0xb
    800005a4:	c6f72023          	sw	a5,-928(a4) # 8000b200 <panicked>
  for(;;)
    800005a8:	a001                	j	800005a8 <panic+0x48>

00000000800005aa <printf>:
{
    800005aa:	7131                	addi	sp,sp,-192
    800005ac:	fc86                	sd	ra,120(sp)
    800005ae:	f8a2                	sd	s0,112(sp)
    800005b0:	e8d2                	sd	s4,80(sp)
    800005b2:	f06a                	sd	s10,32(sp)
    800005b4:	0100                	addi	s0,sp,128
    800005b6:	8a2a                	mv	s4,a0
    800005b8:	e40c                	sd	a1,8(s0)
    800005ba:	e810                	sd	a2,16(s0)
    800005bc:	ec14                	sd	a3,24(s0)
    800005be:	f018                	sd	a4,32(s0)
    800005c0:	f41c                	sd	a5,40(s0)
    800005c2:	03043823          	sd	a6,48(s0)
    800005c6:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005ca:	00013d17          	auipc	s10,0x13
    800005ce:	e76d2d03          	lw	s10,-394(s10) # 80013440 <pr+0x18>
  if(locking)
    800005d2:	040d1463          	bnez	s10,8000061a <printf+0x70>
  if (fmt == 0)
    800005d6:	040a0b63          	beqz	s4,8000062c <printf+0x82>
  va_start(ap, fmt);
    800005da:	00840793          	addi	a5,s0,8
    800005de:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005e2:	000a4503          	lbu	a0,0(s4)
    800005e6:	18050b63          	beqz	a0,8000077c <printf+0x1d2>
    800005ea:	f4a6                	sd	s1,104(sp)
    800005ec:	f0ca                	sd	s2,96(sp)
    800005ee:	ecce                	sd	s3,88(sp)
    800005f0:	e4d6                	sd	s5,72(sp)
    800005f2:	e0da                	sd	s6,64(sp)
    800005f4:	fc5e                	sd	s7,56(sp)
    800005f6:	f862                	sd	s8,48(sp)
    800005f8:	f466                	sd	s9,40(sp)
    800005fa:	ec6e                	sd	s11,24(sp)
    800005fc:	4981                	li	s3,0
    if(c != '%'){
    800005fe:	02500b13          	li	s6,37
    switch(c){
    80000602:	07000b93          	li	s7,112
  consputc('x');
    80000606:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000608:	00008a97          	auipc	s5,0x8
    8000060c:	130a8a93          	addi	s5,s5,304 # 80008738 <digits>
    switch(c){
    80000610:	07300c13          	li	s8,115
    80000614:	06400d93          	li	s11,100
    80000618:	a0b1                	j	80000664 <printf+0xba>
    acquire(&pr.lock);
    8000061a:	00013517          	auipc	a0,0x13
    8000061e:	e0e50513          	addi	a0,a0,-498 # 80013428 <pr>
    80000622:	00000097          	auipc	ra,0x0
    80000626:	62e080e7          	jalr	1582(ra) # 80000c50 <acquire>
    8000062a:	b775                	j	800005d6 <printf+0x2c>
    8000062c:	f4a6                	sd	s1,104(sp)
    8000062e:	f0ca                	sd	s2,96(sp)
    80000630:	ecce                	sd	s3,88(sp)
    80000632:	e4d6                	sd	s5,72(sp)
    80000634:	e0da                	sd	s6,64(sp)
    80000636:	fc5e                	sd	s7,56(sp)
    80000638:	f862                	sd	s8,48(sp)
    8000063a:	f466                	sd	s9,40(sp)
    8000063c:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    8000063e:	00008517          	auipc	a0,0x8
    80000642:	9e250513          	addi	a0,a0,-1566 # 80008020 <etext+0x20>
    80000646:	00000097          	auipc	ra,0x0
    8000064a:	f1a080e7          	jalr	-230(ra) # 80000560 <panic>
      consputc(c);
    8000064e:	00000097          	auipc	ra,0x0
    80000652:	c46080e7          	jalr	-954(ra) # 80000294 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000656:	2985                	addiw	s3,s3,1
    80000658:	013a07b3          	add	a5,s4,s3
    8000065c:	0007c503          	lbu	a0,0(a5)
    80000660:	10050563          	beqz	a0,8000076a <printf+0x1c0>
    if(c != '%'){
    80000664:	ff6515e3          	bne	a0,s6,8000064e <printf+0xa4>
    c = fmt[++i] & 0xff;
    80000668:	2985                	addiw	s3,s3,1
    8000066a:	013a07b3          	add	a5,s4,s3
    8000066e:	0007c783          	lbu	a5,0(a5)
    80000672:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80000676:	10078b63          	beqz	a5,8000078c <printf+0x1e2>
    switch(c){
    8000067a:	05778a63          	beq	a5,s7,800006ce <printf+0x124>
    8000067e:	02fbf663          	bgeu	s7,a5,800006aa <printf+0x100>
    80000682:	09878863          	beq	a5,s8,80000712 <printf+0x168>
    80000686:	07800713          	li	a4,120
    8000068a:	0ce79563          	bne	a5,a4,80000754 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    8000068e:	f8843783          	ld	a5,-120(s0)
    80000692:	00878713          	addi	a4,a5,8
    80000696:	f8e43423          	sd	a4,-120(s0)
    8000069a:	4605                	li	a2,1
    8000069c:	85e6                	mv	a1,s9
    8000069e:	4388                	lw	a0,0(a5)
    800006a0:	00000097          	auipc	ra,0x0
    800006a4:	e1c080e7          	jalr	-484(ra) # 800004bc <printint>
      break;
    800006a8:	b77d                	j	80000656 <printf+0xac>
    switch(c){
    800006aa:	09678f63          	beq	a5,s6,80000748 <printf+0x19e>
    800006ae:	0bb79363          	bne	a5,s11,80000754 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    800006b2:	f8843783          	ld	a5,-120(s0)
    800006b6:	00878713          	addi	a4,a5,8
    800006ba:	f8e43423          	sd	a4,-120(s0)
    800006be:	4605                	li	a2,1
    800006c0:	45a9                	li	a1,10
    800006c2:	4388                	lw	a0,0(a5)
    800006c4:	00000097          	auipc	ra,0x0
    800006c8:	df8080e7          	jalr	-520(ra) # 800004bc <printint>
      break;
    800006cc:	b769                	j	80000656 <printf+0xac>
      printptr(va_arg(ap, uint64));
    800006ce:	f8843783          	ld	a5,-120(s0)
    800006d2:	00878713          	addi	a4,a5,8
    800006d6:	f8e43423          	sd	a4,-120(s0)
    800006da:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006de:	03000513          	li	a0,48
    800006e2:	00000097          	auipc	ra,0x0
    800006e6:	bb2080e7          	jalr	-1102(ra) # 80000294 <consputc>
  consputc('x');
    800006ea:	07800513          	li	a0,120
    800006ee:	00000097          	auipc	ra,0x0
    800006f2:	ba6080e7          	jalr	-1114(ra) # 80000294 <consputc>
    800006f6:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006f8:	03c95793          	srli	a5,s2,0x3c
    800006fc:	97d6                	add	a5,a5,s5
    800006fe:	0007c503          	lbu	a0,0(a5)
    80000702:	00000097          	auipc	ra,0x0
    80000706:	b92080e7          	jalr	-1134(ra) # 80000294 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000070a:	0912                	slli	s2,s2,0x4
    8000070c:	34fd                	addiw	s1,s1,-1
    8000070e:	f4ed                	bnez	s1,800006f8 <printf+0x14e>
    80000710:	b799                	j	80000656 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80000712:	f8843783          	ld	a5,-120(s0)
    80000716:	00878713          	addi	a4,a5,8
    8000071a:	f8e43423          	sd	a4,-120(s0)
    8000071e:	6384                	ld	s1,0(a5)
    80000720:	cc89                	beqz	s1,8000073a <printf+0x190>
      for(; *s; s++)
    80000722:	0004c503          	lbu	a0,0(s1)
    80000726:	d905                	beqz	a0,80000656 <printf+0xac>
        consputc(*s);
    80000728:	00000097          	auipc	ra,0x0
    8000072c:	b6c080e7          	jalr	-1172(ra) # 80000294 <consputc>
      for(; *s; s++)
    80000730:	0485                	addi	s1,s1,1
    80000732:	0004c503          	lbu	a0,0(s1)
    80000736:	f96d                	bnez	a0,80000728 <printf+0x17e>
    80000738:	bf39                	j	80000656 <printf+0xac>
        s = "(null)";
    8000073a:	00008497          	auipc	s1,0x8
    8000073e:	8de48493          	addi	s1,s1,-1826 # 80008018 <etext+0x18>
      for(; *s; s++)
    80000742:	02800513          	li	a0,40
    80000746:	b7cd                	j	80000728 <printf+0x17e>
      consputc('%');
    80000748:	855a                	mv	a0,s6
    8000074a:	00000097          	auipc	ra,0x0
    8000074e:	b4a080e7          	jalr	-1206(ra) # 80000294 <consputc>
      break;
    80000752:	b711                	j	80000656 <printf+0xac>
      consputc('%');
    80000754:	855a                	mv	a0,s6
    80000756:	00000097          	auipc	ra,0x0
    8000075a:	b3e080e7          	jalr	-1218(ra) # 80000294 <consputc>
      consputc(c);
    8000075e:	8526                	mv	a0,s1
    80000760:	00000097          	auipc	ra,0x0
    80000764:	b34080e7          	jalr	-1228(ra) # 80000294 <consputc>
      break;
    80000768:	b5fd                	j	80000656 <printf+0xac>
    8000076a:	74a6                	ld	s1,104(sp)
    8000076c:	7906                	ld	s2,96(sp)
    8000076e:	69e6                	ld	s3,88(sp)
    80000770:	6aa6                	ld	s5,72(sp)
    80000772:	6b06                	ld	s6,64(sp)
    80000774:	7be2                	ld	s7,56(sp)
    80000776:	7c42                	ld	s8,48(sp)
    80000778:	7ca2                	ld	s9,40(sp)
    8000077a:	6de2                	ld	s11,24(sp)
  if(locking)
    8000077c:	020d1263          	bnez	s10,800007a0 <printf+0x1f6>
}
    80000780:	70e6                	ld	ra,120(sp)
    80000782:	7446                	ld	s0,112(sp)
    80000784:	6a46                	ld	s4,80(sp)
    80000786:	7d02                	ld	s10,32(sp)
    80000788:	6129                	addi	sp,sp,192
    8000078a:	8082                	ret
    8000078c:	74a6                	ld	s1,104(sp)
    8000078e:	7906                	ld	s2,96(sp)
    80000790:	69e6                	ld	s3,88(sp)
    80000792:	6aa6                	ld	s5,72(sp)
    80000794:	6b06                	ld	s6,64(sp)
    80000796:	7be2                	ld	s7,56(sp)
    80000798:	7c42                	ld	s8,48(sp)
    8000079a:	7ca2                	ld	s9,40(sp)
    8000079c:	6de2                	ld	s11,24(sp)
    8000079e:	bff9                	j	8000077c <printf+0x1d2>
    release(&pr.lock);
    800007a0:	00013517          	auipc	a0,0x13
    800007a4:	c8850513          	addi	a0,a0,-888 # 80013428 <pr>
    800007a8:	00000097          	auipc	ra,0x0
    800007ac:	55c080e7          	jalr	1372(ra) # 80000d04 <release>
}
    800007b0:	bfc1                	j	80000780 <printf+0x1d6>

00000000800007b2 <printfinit>:
    ;
}

void
printfinit(void)
{
    800007b2:	1101                	addi	sp,sp,-32
    800007b4:	ec06                	sd	ra,24(sp)
    800007b6:	e822                	sd	s0,16(sp)
    800007b8:	e426                	sd	s1,8(sp)
    800007ba:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800007bc:	00013497          	auipc	s1,0x13
    800007c0:	c6c48493          	addi	s1,s1,-916 # 80013428 <pr>
    800007c4:	00008597          	auipc	a1,0x8
    800007c8:	86c58593          	addi	a1,a1,-1940 # 80008030 <etext+0x30>
    800007cc:	8526                	mv	a0,s1
    800007ce:	00000097          	auipc	ra,0x0
    800007d2:	3f2080e7          	jalr	1010(ra) # 80000bc0 <initlock>
  pr.locking = 1;
    800007d6:	4785                	li	a5,1
    800007d8:	cc9c                	sw	a5,24(s1)

  initsleeplock(&print_lock, "userprint");
    800007da:	00008597          	auipc	a1,0x8
    800007de:	85e58593          	addi	a1,a1,-1954 # 80008038 <etext+0x38>
    800007e2:	00013517          	auipc	a0,0x13
    800007e6:	c6650513          	addi	a0,a0,-922 # 80013448 <print_lock>
    800007ea:	00004097          	auipc	ra,0x4
    800007ee:	c2a080e7          	jalr	-982(ra) # 80004414 <initsleeplock>
}
    800007f2:	60e2                	ld	ra,24(sp)
    800007f4:	6442                	ld	s0,16(sp)
    800007f6:	64a2                	ld	s1,8(sp)
    800007f8:	6105                	addi	sp,sp,32
    800007fa:	8082                	ret

00000000800007fc <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007fc:	1141                	addi	sp,sp,-16
    800007fe:	e406                	sd	ra,8(sp)
    80000800:	e022                	sd	s0,0(sp)
    80000802:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80000804:	100007b7          	lui	a5,0x10000
    80000808:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000080c:	10000737          	lui	a4,0x10000
    80000810:	f8000693          	li	a3,-128
    80000814:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000818:	468d                	li	a3,3
    8000081a:	10000637          	lui	a2,0x10000
    8000081e:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000822:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000826:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000082a:	10000737          	lui	a4,0x10000
    8000082e:	461d                	li	a2,7
    80000830:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80000834:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000838:	00008597          	auipc	a1,0x8
    8000083c:	81058593          	addi	a1,a1,-2032 # 80008048 <etext+0x48>
    80000840:	00013517          	auipc	a0,0x13
    80000844:	c3850513          	addi	a0,a0,-968 # 80013478 <uart_tx_lock>
    80000848:	00000097          	auipc	ra,0x0
    8000084c:	378080e7          	jalr	888(ra) # 80000bc0 <initlock>
}
    80000850:	60a2                	ld	ra,8(sp)
    80000852:	6402                	ld	s0,0(sp)
    80000854:	0141                	addi	sp,sp,16
    80000856:	8082                	ret

0000000080000858 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000858:	1101                	addi	sp,sp,-32
    8000085a:	ec06                	sd	ra,24(sp)
    8000085c:	e822                	sd	s0,16(sp)
    8000085e:	e426                	sd	s1,8(sp)
    80000860:	1000                	addi	s0,sp,32
    80000862:	84aa                	mv	s1,a0
  push_off();
    80000864:	00000097          	auipc	ra,0x0
    80000868:	3a0080e7          	jalr	928(ra) # 80000c04 <push_off>

  if(panicked){
    8000086c:	0000b797          	auipc	a5,0xb
    80000870:	9947a783          	lw	a5,-1644(a5) # 8000b200 <panicked>
    80000874:	eb85                	bnez	a5,800008a4 <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000876:	10000737          	lui	a4,0x10000
    8000087a:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    8000087c:	00074783          	lbu	a5,0(a4)
    80000880:	0207f793          	andi	a5,a5,32
    80000884:	dfe5                	beqz	a5,8000087c <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000886:	0ff4f513          	zext.b	a0,s1
    8000088a:	100007b7          	lui	a5,0x10000
    8000088e:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000892:	00000097          	auipc	ra,0x0
    80000896:	412080e7          	jalr	1042(ra) # 80000ca4 <pop_off>
}
    8000089a:	60e2                	ld	ra,24(sp)
    8000089c:	6442                	ld	s0,16(sp)
    8000089e:	64a2                	ld	s1,8(sp)
    800008a0:	6105                	addi	sp,sp,32
    800008a2:	8082                	ret
    for(;;)
    800008a4:	a001                	j	800008a4 <uartputc_sync+0x4c>

00000000800008a6 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800008a6:	0000b797          	auipc	a5,0xb
    800008aa:	9627b783          	ld	a5,-1694(a5) # 8000b208 <uart_tx_r>
    800008ae:	0000b717          	auipc	a4,0xb
    800008b2:	96273703          	ld	a4,-1694(a4) # 8000b210 <uart_tx_w>
    800008b6:	06f70f63          	beq	a4,a5,80000934 <uartstart+0x8e>
{
    800008ba:	7139                	addi	sp,sp,-64
    800008bc:	fc06                	sd	ra,56(sp)
    800008be:	f822                	sd	s0,48(sp)
    800008c0:	f426                	sd	s1,40(sp)
    800008c2:	f04a                	sd	s2,32(sp)
    800008c4:	ec4e                	sd	s3,24(sp)
    800008c6:	e852                	sd	s4,16(sp)
    800008c8:	e456                	sd	s5,8(sp)
    800008ca:	e05a                	sd	s6,0(sp)
    800008cc:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008ce:	10000937          	lui	s2,0x10000
    800008d2:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008d4:	00013a97          	auipc	s5,0x13
    800008d8:	ba4a8a93          	addi	s5,s5,-1116 # 80013478 <uart_tx_lock>
    uart_tx_r += 1;
    800008dc:	0000b497          	auipc	s1,0xb
    800008e0:	92c48493          	addi	s1,s1,-1748 # 8000b208 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008e4:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008e8:	0000b997          	auipc	s3,0xb
    800008ec:	92898993          	addi	s3,s3,-1752 # 8000b210 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008f0:	00094703          	lbu	a4,0(s2)
    800008f4:	02077713          	andi	a4,a4,32
    800008f8:	c705                	beqz	a4,80000920 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008fa:	01f7f713          	andi	a4,a5,31
    800008fe:	9756                	add	a4,a4,s5
    80000900:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80000904:	0785                	addi	a5,a5,1
    80000906:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    80000908:	8526                	mv	a0,s1
    8000090a:	00002097          	auipc	ra,0x2
    8000090e:	886080e7          	jalr	-1914(ra) # 80002190 <wakeup>
    WriteReg(THR, c);
    80000912:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80000916:	609c                	ld	a5,0(s1)
    80000918:	0009b703          	ld	a4,0(s3)
    8000091c:	fcf71ae3          	bne	a4,a5,800008f0 <uartstart+0x4a>
  }
}
    80000920:	70e2                	ld	ra,56(sp)
    80000922:	7442                	ld	s0,48(sp)
    80000924:	74a2                	ld	s1,40(sp)
    80000926:	7902                	ld	s2,32(sp)
    80000928:	69e2                	ld	s3,24(sp)
    8000092a:	6a42                	ld	s4,16(sp)
    8000092c:	6aa2                	ld	s5,8(sp)
    8000092e:	6b02                	ld	s6,0(sp)
    80000930:	6121                	addi	sp,sp,64
    80000932:	8082                	ret
    80000934:	8082                	ret

0000000080000936 <uartputc>:
{
    80000936:	7179                	addi	sp,sp,-48
    80000938:	f406                	sd	ra,40(sp)
    8000093a:	f022                	sd	s0,32(sp)
    8000093c:	ec26                	sd	s1,24(sp)
    8000093e:	e84a                	sd	s2,16(sp)
    80000940:	e44e                	sd	s3,8(sp)
    80000942:	e052                	sd	s4,0(sp)
    80000944:	1800                	addi	s0,sp,48
    80000946:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80000948:	00013517          	auipc	a0,0x13
    8000094c:	b3050513          	addi	a0,a0,-1232 # 80013478 <uart_tx_lock>
    80000950:	00000097          	auipc	ra,0x0
    80000954:	300080e7          	jalr	768(ra) # 80000c50 <acquire>
  if(panicked){
    80000958:	0000b797          	auipc	a5,0xb
    8000095c:	8a87a783          	lw	a5,-1880(a5) # 8000b200 <panicked>
    80000960:	e7c9                	bnez	a5,800009ea <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000962:	0000b717          	auipc	a4,0xb
    80000966:	8ae73703          	ld	a4,-1874(a4) # 8000b210 <uart_tx_w>
    8000096a:	0000b797          	auipc	a5,0xb
    8000096e:	89e7b783          	ld	a5,-1890(a5) # 8000b208 <uart_tx_r>
    80000972:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000976:	00013997          	auipc	s3,0x13
    8000097a:	b0298993          	addi	s3,s3,-1278 # 80013478 <uart_tx_lock>
    8000097e:	0000b497          	auipc	s1,0xb
    80000982:	88a48493          	addi	s1,s1,-1910 # 8000b208 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000986:	0000b917          	auipc	s2,0xb
    8000098a:	88a90913          	addi	s2,s2,-1910 # 8000b210 <uart_tx_w>
    8000098e:	00e79f63          	bne	a5,a4,800009ac <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000992:	85ce                	mv	a1,s3
    80000994:	8526                	mv	a0,s1
    80000996:	00001097          	auipc	ra,0x1
    8000099a:	796080e7          	jalr	1942(ra) # 8000212c <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000099e:	00093703          	ld	a4,0(s2)
    800009a2:	609c                	ld	a5,0(s1)
    800009a4:	02078793          	addi	a5,a5,32
    800009a8:	fee785e3          	beq	a5,a4,80000992 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800009ac:	00013497          	auipc	s1,0x13
    800009b0:	acc48493          	addi	s1,s1,-1332 # 80013478 <uart_tx_lock>
    800009b4:	01f77793          	andi	a5,a4,31
    800009b8:	97a6                	add	a5,a5,s1
    800009ba:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009be:	0705                	addi	a4,a4,1
    800009c0:	0000b797          	auipc	a5,0xb
    800009c4:	84e7b823          	sd	a4,-1968(a5) # 8000b210 <uart_tx_w>
  uartstart();
    800009c8:	00000097          	auipc	ra,0x0
    800009cc:	ede080e7          	jalr	-290(ra) # 800008a6 <uartstart>
  release(&uart_tx_lock);
    800009d0:	8526                	mv	a0,s1
    800009d2:	00000097          	auipc	ra,0x0
    800009d6:	332080e7          	jalr	818(ra) # 80000d04 <release>
}
    800009da:	70a2                	ld	ra,40(sp)
    800009dc:	7402                	ld	s0,32(sp)
    800009de:	64e2                	ld	s1,24(sp)
    800009e0:	6942                	ld	s2,16(sp)
    800009e2:	69a2                	ld	s3,8(sp)
    800009e4:	6a02                	ld	s4,0(sp)
    800009e6:	6145                	addi	sp,sp,48
    800009e8:	8082                	ret
    for(;;)
    800009ea:	a001                	j	800009ea <uartputc+0xb4>

00000000800009ec <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009ec:	1141                	addi	sp,sp,-16
    800009ee:	e422                	sd	s0,8(sp)
    800009f0:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009f2:	100007b7          	lui	a5,0x10000
    800009f6:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800009f8:	0007c783          	lbu	a5,0(a5)
    800009fc:	8b85                	andi	a5,a5,1
    800009fe:	cb81                	beqz	a5,80000a0e <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80000a00:	100007b7          	lui	a5,0x10000
    80000a04:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80000a08:	6422                	ld	s0,8(sp)
    80000a0a:	0141                	addi	sp,sp,16
    80000a0c:	8082                	ret
    return -1;
    80000a0e:	557d                	li	a0,-1
    80000a10:	bfe5                	j	80000a08 <uartgetc+0x1c>

0000000080000a12 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000a12:	1101                	addi	sp,sp,-32
    80000a14:	ec06                	sd	ra,24(sp)
    80000a16:	e822                	sd	s0,16(sp)
    80000a18:	e426                	sd	s1,8(sp)
    80000a1a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a1c:	54fd                	li	s1,-1
    80000a1e:	a029                	j	80000a28 <uartintr+0x16>
      break;
    consoleintr(c);
    80000a20:	00000097          	auipc	ra,0x0
    80000a24:	8b6080e7          	jalr	-1866(ra) # 800002d6 <consoleintr>
    int c = uartgetc();
    80000a28:	00000097          	auipc	ra,0x0
    80000a2c:	fc4080e7          	jalr	-60(ra) # 800009ec <uartgetc>
    if(c == -1)
    80000a30:	fe9518e3          	bne	a0,s1,80000a20 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a34:	00013497          	auipc	s1,0x13
    80000a38:	a4448493          	addi	s1,s1,-1468 # 80013478 <uart_tx_lock>
    80000a3c:	8526                	mv	a0,s1
    80000a3e:	00000097          	auipc	ra,0x0
    80000a42:	212080e7          	jalr	530(ra) # 80000c50 <acquire>
  uartstart();
    80000a46:	00000097          	auipc	ra,0x0
    80000a4a:	e60080e7          	jalr	-416(ra) # 800008a6 <uartstart>
  release(&uart_tx_lock);
    80000a4e:	8526                	mv	a0,s1
    80000a50:	00000097          	auipc	ra,0x0
    80000a54:	2b4080e7          	jalr	692(ra) # 80000d04 <release>
}
    80000a58:	60e2                	ld	ra,24(sp)
    80000a5a:	6442                	ld	s0,16(sp)
    80000a5c:	64a2                	ld	s1,8(sp)
    80000a5e:	6105                	addi	sp,sp,32
    80000a60:	8082                	ret

0000000080000a62 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a62:	1101                	addi	sp,sp,-32
    80000a64:	ec06                	sd	ra,24(sp)
    80000a66:	e822                	sd	s0,16(sp)
    80000a68:	e426                	sd	s1,8(sp)
    80000a6a:	e04a                	sd	s2,0(sp)
    80000a6c:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a6e:	03451793          	slli	a5,a0,0x34
    80000a72:	ebb9                	bnez	a5,80000ac8 <kfree+0x66>
    80000a74:	84aa                	mv	s1,a0
    80000a76:	00024797          	auipc	a5,0x24
    80000a7a:	c6a78793          	addi	a5,a5,-918 # 800246e0 <end>
    80000a7e:	04f56563          	bltu	a0,a5,80000ac8 <kfree+0x66>
    80000a82:	47c5                	li	a5,17
    80000a84:	07ee                	slli	a5,a5,0x1b
    80000a86:	04f57163          	bgeu	a0,a5,80000ac8 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a8a:	6605                	lui	a2,0x1
    80000a8c:	4585                	li	a1,1
    80000a8e:	00000097          	auipc	ra,0x0
    80000a92:	2be080e7          	jalr	702(ra) # 80000d4c <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a96:	00013917          	auipc	s2,0x13
    80000a9a:	a1a90913          	addi	s2,s2,-1510 # 800134b0 <kmem>
    80000a9e:	854a                	mv	a0,s2
    80000aa0:	00000097          	auipc	ra,0x0
    80000aa4:	1b0080e7          	jalr	432(ra) # 80000c50 <acquire>
  r->next = kmem.freelist;
    80000aa8:	01893783          	ld	a5,24(s2)
    80000aac:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000aae:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000ab2:	854a                	mv	a0,s2
    80000ab4:	00000097          	auipc	ra,0x0
    80000ab8:	250080e7          	jalr	592(ra) # 80000d04 <release>
}
    80000abc:	60e2                	ld	ra,24(sp)
    80000abe:	6442                	ld	s0,16(sp)
    80000ac0:	64a2                	ld	s1,8(sp)
    80000ac2:	6902                	ld	s2,0(sp)
    80000ac4:	6105                	addi	sp,sp,32
    80000ac6:	8082                	ret
    panic("kfree");
    80000ac8:	00007517          	auipc	a0,0x7
    80000acc:	58850513          	addi	a0,a0,1416 # 80008050 <etext+0x50>
    80000ad0:	00000097          	auipc	ra,0x0
    80000ad4:	a90080e7          	jalr	-1392(ra) # 80000560 <panic>

0000000080000ad8 <freerange>:
{
    80000ad8:	7179                	addi	sp,sp,-48
    80000ada:	f406                	sd	ra,40(sp)
    80000adc:	f022                	sd	s0,32(sp)
    80000ade:	ec26                	sd	s1,24(sp)
    80000ae0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000ae2:	6785                	lui	a5,0x1
    80000ae4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ae8:	00e504b3          	add	s1,a0,a4
    80000aec:	777d                	lui	a4,0xfffff
    80000aee:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000af0:	94be                	add	s1,s1,a5
    80000af2:	0295e463          	bltu	a1,s1,80000b1a <freerange+0x42>
    80000af6:	e84a                	sd	s2,16(sp)
    80000af8:	e44e                	sd	s3,8(sp)
    80000afa:	e052                	sd	s4,0(sp)
    80000afc:	892e                	mv	s2,a1
    kfree(p);
    80000afe:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000b00:	6985                	lui	s3,0x1
    kfree(p);
    80000b02:	01448533          	add	a0,s1,s4
    80000b06:	00000097          	auipc	ra,0x0
    80000b0a:	f5c080e7          	jalr	-164(ra) # 80000a62 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000b0e:	94ce                	add	s1,s1,s3
    80000b10:	fe9979e3          	bgeu	s2,s1,80000b02 <freerange+0x2a>
    80000b14:	6942                	ld	s2,16(sp)
    80000b16:	69a2                	ld	s3,8(sp)
    80000b18:	6a02                	ld	s4,0(sp)
}
    80000b1a:	70a2                	ld	ra,40(sp)
    80000b1c:	7402                	ld	s0,32(sp)
    80000b1e:	64e2                	ld	s1,24(sp)
    80000b20:	6145                	addi	sp,sp,48
    80000b22:	8082                	ret

0000000080000b24 <kinit>:
{
    80000b24:	1141                	addi	sp,sp,-16
    80000b26:	e406                	sd	ra,8(sp)
    80000b28:	e022                	sd	s0,0(sp)
    80000b2a:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000b2c:	00007597          	auipc	a1,0x7
    80000b30:	52c58593          	addi	a1,a1,1324 # 80008058 <etext+0x58>
    80000b34:	00013517          	auipc	a0,0x13
    80000b38:	97c50513          	addi	a0,a0,-1668 # 800134b0 <kmem>
    80000b3c:	00000097          	auipc	ra,0x0
    80000b40:	084080e7          	jalr	132(ra) # 80000bc0 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b44:	45c5                	li	a1,17
    80000b46:	05ee                	slli	a1,a1,0x1b
    80000b48:	00024517          	auipc	a0,0x24
    80000b4c:	b9850513          	addi	a0,a0,-1128 # 800246e0 <end>
    80000b50:	00000097          	auipc	ra,0x0
    80000b54:	f88080e7          	jalr	-120(ra) # 80000ad8 <freerange>
}
    80000b58:	60a2                	ld	ra,8(sp)
    80000b5a:	6402                	ld	s0,0(sp)
    80000b5c:	0141                	addi	sp,sp,16
    80000b5e:	8082                	ret

0000000080000b60 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b60:	1101                	addi	sp,sp,-32
    80000b62:	ec06                	sd	ra,24(sp)
    80000b64:	e822                	sd	s0,16(sp)
    80000b66:	e426                	sd	s1,8(sp)
    80000b68:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b6a:	00013497          	auipc	s1,0x13
    80000b6e:	94648493          	addi	s1,s1,-1722 # 800134b0 <kmem>
    80000b72:	8526                	mv	a0,s1
    80000b74:	00000097          	auipc	ra,0x0
    80000b78:	0dc080e7          	jalr	220(ra) # 80000c50 <acquire>
  r = kmem.freelist;
    80000b7c:	6c84                	ld	s1,24(s1)
  if(r)
    80000b7e:	c885                	beqz	s1,80000bae <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b80:	609c                	ld	a5,0(s1)
    80000b82:	00013517          	auipc	a0,0x13
    80000b86:	92e50513          	addi	a0,a0,-1746 # 800134b0 <kmem>
    80000b8a:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b8c:	00000097          	auipc	ra,0x0
    80000b90:	178080e7          	jalr	376(ra) # 80000d04 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b94:	6605                	lui	a2,0x1
    80000b96:	4595                	li	a1,5
    80000b98:	8526                	mv	a0,s1
    80000b9a:	00000097          	auipc	ra,0x0
    80000b9e:	1b2080e7          	jalr	434(ra) # 80000d4c <memset>
  return (void*)r;
}
    80000ba2:	8526                	mv	a0,s1
    80000ba4:	60e2                	ld	ra,24(sp)
    80000ba6:	6442                	ld	s0,16(sp)
    80000ba8:	64a2                	ld	s1,8(sp)
    80000baa:	6105                	addi	sp,sp,32
    80000bac:	8082                	ret
  release(&kmem.lock);
    80000bae:	00013517          	auipc	a0,0x13
    80000bb2:	90250513          	addi	a0,a0,-1790 # 800134b0 <kmem>
    80000bb6:	00000097          	auipc	ra,0x0
    80000bba:	14e080e7          	jalr	334(ra) # 80000d04 <release>
  if(r)
    80000bbe:	b7d5                	j	80000ba2 <kalloc+0x42>

0000000080000bc0 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000bc0:	1141                	addi	sp,sp,-16
    80000bc2:	e422                	sd	s0,8(sp)
    80000bc4:	0800                	addi	s0,sp,16
  lk->name = name;
    80000bc6:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000bc8:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000bcc:	00053823          	sd	zero,16(a0)
}
    80000bd0:	6422                	ld	s0,8(sp)
    80000bd2:	0141                	addi	sp,sp,16
    80000bd4:	8082                	ret

0000000080000bd6 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000bd6:	411c                	lw	a5,0(a0)
    80000bd8:	e399                	bnez	a5,80000bde <holding+0x8>
    80000bda:	4501                	li	a0,0
  return r;
}
    80000bdc:	8082                	ret
{
    80000bde:	1101                	addi	sp,sp,-32
    80000be0:	ec06                	sd	ra,24(sp)
    80000be2:	e822                	sd	s0,16(sp)
    80000be4:	e426                	sd	s1,8(sp)
    80000be6:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000be8:	6904                	ld	s1,16(a0)
    80000bea:	00001097          	auipc	ra,0x1
    80000bee:	e5c080e7          	jalr	-420(ra) # 80001a46 <mycpu>
    80000bf2:	40a48533          	sub	a0,s1,a0
    80000bf6:	00153513          	seqz	a0,a0
}
    80000bfa:	60e2                	ld	ra,24(sp)
    80000bfc:	6442                	ld	s0,16(sp)
    80000bfe:	64a2                	ld	s1,8(sp)
    80000c00:	6105                	addi	sp,sp,32
    80000c02:	8082                	ret

0000000080000c04 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000c04:	1101                	addi	sp,sp,-32
    80000c06:	ec06                	sd	ra,24(sp)
    80000c08:	e822                	sd	s0,16(sp)
    80000c0a:	e426                	sd	s1,8(sp)
    80000c0c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c0e:	100024f3          	csrr	s1,sstatus
    80000c12:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000c16:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c18:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000c1c:	00001097          	auipc	ra,0x1
    80000c20:	e2a080e7          	jalr	-470(ra) # 80001a46 <mycpu>
    80000c24:	5d3c                	lw	a5,120(a0)
    80000c26:	cf89                	beqz	a5,80000c40 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c28:	00001097          	auipc	ra,0x1
    80000c2c:	e1e080e7          	jalr	-482(ra) # 80001a46 <mycpu>
    80000c30:	5d3c                	lw	a5,120(a0)
    80000c32:	2785                	addiw	a5,a5,1
    80000c34:	dd3c                	sw	a5,120(a0)
}
    80000c36:	60e2                	ld	ra,24(sp)
    80000c38:	6442                	ld	s0,16(sp)
    80000c3a:	64a2                	ld	s1,8(sp)
    80000c3c:	6105                	addi	sp,sp,32
    80000c3e:	8082                	ret
    mycpu()->intena = old;
    80000c40:	00001097          	auipc	ra,0x1
    80000c44:	e06080e7          	jalr	-506(ra) # 80001a46 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000c48:	8085                	srli	s1,s1,0x1
    80000c4a:	8885                	andi	s1,s1,1
    80000c4c:	dd64                	sw	s1,124(a0)
    80000c4e:	bfe9                	j	80000c28 <push_off+0x24>

0000000080000c50 <acquire>:
{
    80000c50:	1101                	addi	sp,sp,-32
    80000c52:	ec06                	sd	ra,24(sp)
    80000c54:	e822                	sd	s0,16(sp)
    80000c56:	e426                	sd	s1,8(sp)
    80000c58:	1000                	addi	s0,sp,32
    80000c5a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c5c:	00000097          	auipc	ra,0x0
    80000c60:	fa8080e7          	jalr	-88(ra) # 80000c04 <push_off>
  if(holding(lk))
    80000c64:	8526                	mv	a0,s1
    80000c66:	00000097          	auipc	ra,0x0
    80000c6a:	f70080e7          	jalr	-144(ra) # 80000bd6 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c6e:	4705                	li	a4,1
  if(holding(lk))
    80000c70:	e115                	bnez	a0,80000c94 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c72:	87ba                	mv	a5,a4
    80000c74:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c78:	2781                	sext.w	a5,a5
    80000c7a:	ffe5                	bnez	a5,80000c72 <acquire+0x22>
  __sync_synchronize();
    80000c7c:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000c80:	00001097          	auipc	ra,0x1
    80000c84:	dc6080e7          	jalr	-570(ra) # 80001a46 <mycpu>
    80000c88:	e888                	sd	a0,16(s1)
}
    80000c8a:	60e2                	ld	ra,24(sp)
    80000c8c:	6442                	ld	s0,16(sp)
    80000c8e:	64a2                	ld	s1,8(sp)
    80000c90:	6105                	addi	sp,sp,32
    80000c92:	8082                	ret
    panic("acquire");
    80000c94:	00007517          	auipc	a0,0x7
    80000c98:	3cc50513          	addi	a0,a0,972 # 80008060 <etext+0x60>
    80000c9c:	00000097          	auipc	ra,0x0
    80000ca0:	8c4080e7          	jalr	-1852(ra) # 80000560 <panic>

0000000080000ca4 <pop_off>:

void
pop_off(void)
{
    80000ca4:	1141                	addi	sp,sp,-16
    80000ca6:	e406                	sd	ra,8(sp)
    80000ca8:	e022                	sd	s0,0(sp)
    80000caa:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000cac:	00001097          	auipc	ra,0x1
    80000cb0:	d9a080e7          	jalr	-614(ra) # 80001a46 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000cb4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000cb8:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000cba:	e78d                	bnez	a5,80000ce4 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000cbc:	5d3c                	lw	a5,120(a0)
    80000cbe:	02f05b63          	blez	a5,80000cf4 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000cc2:	37fd                	addiw	a5,a5,-1
    80000cc4:	0007871b          	sext.w	a4,a5
    80000cc8:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000cca:	eb09                	bnez	a4,80000cdc <pop_off+0x38>
    80000ccc:	5d7c                	lw	a5,124(a0)
    80000cce:	c799                	beqz	a5,80000cdc <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000cd0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000cd4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000cd8:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000cdc:	60a2                	ld	ra,8(sp)
    80000cde:	6402                	ld	s0,0(sp)
    80000ce0:	0141                	addi	sp,sp,16
    80000ce2:	8082                	ret
    panic("pop_off - interruptible");
    80000ce4:	00007517          	auipc	a0,0x7
    80000ce8:	38450513          	addi	a0,a0,900 # 80008068 <etext+0x68>
    80000cec:	00000097          	auipc	ra,0x0
    80000cf0:	874080e7          	jalr	-1932(ra) # 80000560 <panic>
    panic("pop_off");
    80000cf4:	00007517          	auipc	a0,0x7
    80000cf8:	38c50513          	addi	a0,a0,908 # 80008080 <etext+0x80>
    80000cfc:	00000097          	auipc	ra,0x0
    80000d00:	864080e7          	jalr	-1948(ra) # 80000560 <panic>

0000000080000d04 <release>:
{
    80000d04:	1101                	addi	sp,sp,-32
    80000d06:	ec06                	sd	ra,24(sp)
    80000d08:	e822                	sd	s0,16(sp)
    80000d0a:	e426                	sd	s1,8(sp)
    80000d0c:	1000                	addi	s0,sp,32
    80000d0e:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000d10:	00000097          	auipc	ra,0x0
    80000d14:	ec6080e7          	jalr	-314(ra) # 80000bd6 <holding>
    80000d18:	c115                	beqz	a0,80000d3c <release+0x38>
  lk->cpu = 0;
    80000d1a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000d1e:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000d22:	0310000f          	fence	rw,w
    80000d26:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000d2a:	00000097          	auipc	ra,0x0
    80000d2e:	f7a080e7          	jalr	-134(ra) # 80000ca4 <pop_off>
}
    80000d32:	60e2                	ld	ra,24(sp)
    80000d34:	6442                	ld	s0,16(sp)
    80000d36:	64a2                	ld	s1,8(sp)
    80000d38:	6105                	addi	sp,sp,32
    80000d3a:	8082                	ret
    panic("release");
    80000d3c:	00007517          	auipc	a0,0x7
    80000d40:	34c50513          	addi	a0,a0,844 # 80008088 <etext+0x88>
    80000d44:	00000097          	auipc	ra,0x0
    80000d48:	81c080e7          	jalr	-2020(ra) # 80000560 <panic>

0000000080000d4c <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000d4c:	1141                	addi	sp,sp,-16
    80000d4e:	e422                	sd	s0,8(sp)
    80000d50:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d52:	ca19                	beqz	a2,80000d68 <memset+0x1c>
    80000d54:	87aa                	mv	a5,a0
    80000d56:	1602                	slli	a2,a2,0x20
    80000d58:	9201                	srli	a2,a2,0x20
    80000d5a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000d5e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000d62:	0785                	addi	a5,a5,1
    80000d64:	fee79de3          	bne	a5,a4,80000d5e <memset+0x12>
  }
  return dst;
}
    80000d68:	6422                	ld	s0,8(sp)
    80000d6a:	0141                	addi	sp,sp,16
    80000d6c:	8082                	ret

0000000080000d6e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d6e:	1141                	addi	sp,sp,-16
    80000d70:	e422                	sd	s0,8(sp)
    80000d72:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d74:	ca05                	beqz	a2,80000da4 <memcmp+0x36>
    80000d76:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000d7a:	1682                	slli	a3,a3,0x20
    80000d7c:	9281                	srli	a3,a3,0x20
    80000d7e:	0685                	addi	a3,a3,1
    80000d80:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d82:	00054783          	lbu	a5,0(a0)
    80000d86:	0005c703          	lbu	a4,0(a1)
    80000d8a:	00e79863          	bne	a5,a4,80000d9a <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d8e:	0505                	addi	a0,a0,1
    80000d90:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d92:	fed518e3          	bne	a0,a3,80000d82 <memcmp+0x14>
  }

  return 0;
    80000d96:	4501                	li	a0,0
    80000d98:	a019                	j	80000d9e <memcmp+0x30>
      return *s1 - *s2;
    80000d9a:	40e7853b          	subw	a0,a5,a4
}
    80000d9e:	6422                	ld	s0,8(sp)
    80000da0:	0141                	addi	sp,sp,16
    80000da2:	8082                	ret
  return 0;
    80000da4:	4501                	li	a0,0
    80000da6:	bfe5                	j	80000d9e <memcmp+0x30>

0000000080000da8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000da8:	1141                	addi	sp,sp,-16
    80000daa:	e422                	sd	s0,8(sp)
    80000dac:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000dae:	c205                	beqz	a2,80000dce <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000db0:	02a5e263          	bltu	a1,a0,80000dd4 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000db4:	1602                	slli	a2,a2,0x20
    80000db6:	9201                	srli	a2,a2,0x20
    80000db8:	00c587b3          	add	a5,a1,a2
{
    80000dbc:	872a                	mv	a4,a0
      *d++ = *s++;
    80000dbe:	0585                	addi	a1,a1,1
    80000dc0:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffda921>
    80000dc2:	fff5c683          	lbu	a3,-1(a1)
    80000dc6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000dca:	feb79ae3          	bne	a5,a1,80000dbe <memmove+0x16>

  return dst;
}
    80000dce:	6422                	ld	s0,8(sp)
    80000dd0:	0141                	addi	sp,sp,16
    80000dd2:	8082                	ret
  if(s < d && s + n > d){
    80000dd4:	02061693          	slli	a3,a2,0x20
    80000dd8:	9281                	srli	a3,a3,0x20
    80000dda:	00d58733          	add	a4,a1,a3
    80000dde:	fce57be3          	bgeu	a0,a4,80000db4 <memmove+0xc>
    d += n;
    80000de2:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000de4:	fff6079b          	addiw	a5,a2,-1
    80000de8:	1782                	slli	a5,a5,0x20
    80000dea:	9381                	srli	a5,a5,0x20
    80000dec:	fff7c793          	not	a5,a5
    80000df0:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000df2:	177d                	addi	a4,a4,-1
    80000df4:	16fd                	addi	a3,a3,-1
    80000df6:	00074603          	lbu	a2,0(a4)
    80000dfa:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000dfe:	fef71ae3          	bne	a4,a5,80000df2 <memmove+0x4a>
    80000e02:	b7f1                	j	80000dce <memmove+0x26>

0000000080000e04 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000e04:	1141                	addi	sp,sp,-16
    80000e06:	e406                	sd	ra,8(sp)
    80000e08:	e022                	sd	s0,0(sp)
    80000e0a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000e0c:	00000097          	auipc	ra,0x0
    80000e10:	f9c080e7          	jalr	-100(ra) # 80000da8 <memmove>
}
    80000e14:	60a2                	ld	ra,8(sp)
    80000e16:	6402                	ld	s0,0(sp)
    80000e18:	0141                	addi	sp,sp,16
    80000e1a:	8082                	ret

0000000080000e1c <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000e1c:	1141                	addi	sp,sp,-16
    80000e1e:	e422                	sd	s0,8(sp)
    80000e20:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000e22:	ce11                	beqz	a2,80000e3e <strncmp+0x22>
    80000e24:	00054783          	lbu	a5,0(a0)
    80000e28:	cf89                	beqz	a5,80000e42 <strncmp+0x26>
    80000e2a:	0005c703          	lbu	a4,0(a1)
    80000e2e:	00f71a63          	bne	a4,a5,80000e42 <strncmp+0x26>
    n--, p++, q++;
    80000e32:	367d                	addiw	a2,a2,-1
    80000e34:	0505                	addi	a0,a0,1
    80000e36:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000e38:	f675                	bnez	a2,80000e24 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000e3a:	4501                	li	a0,0
    80000e3c:	a801                	j	80000e4c <strncmp+0x30>
    80000e3e:	4501                	li	a0,0
    80000e40:	a031                	j	80000e4c <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000e42:	00054503          	lbu	a0,0(a0)
    80000e46:	0005c783          	lbu	a5,0(a1)
    80000e4a:	9d1d                	subw	a0,a0,a5
}
    80000e4c:	6422                	ld	s0,8(sp)
    80000e4e:	0141                	addi	sp,sp,16
    80000e50:	8082                	ret

0000000080000e52 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e52:	1141                	addi	sp,sp,-16
    80000e54:	e422                	sd	s0,8(sp)
    80000e56:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e58:	87aa                	mv	a5,a0
    80000e5a:	86b2                	mv	a3,a2
    80000e5c:	367d                	addiw	a2,a2,-1
    80000e5e:	02d05563          	blez	a3,80000e88 <strncpy+0x36>
    80000e62:	0785                	addi	a5,a5,1
    80000e64:	0005c703          	lbu	a4,0(a1)
    80000e68:	fee78fa3          	sb	a4,-1(a5)
    80000e6c:	0585                	addi	a1,a1,1
    80000e6e:	f775                	bnez	a4,80000e5a <strncpy+0x8>
    ;
  while(n-- > 0)
    80000e70:	873e                	mv	a4,a5
    80000e72:	9fb5                	addw	a5,a5,a3
    80000e74:	37fd                	addiw	a5,a5,-1
    80000e76:	00c05963          	blez	a2,80000e88 <strncpy+0x36>
    *s++ = 0;
    80000e7a:	0705                	addi	a4,a4,1
    80000e7c:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000e80:	40e786bb          	subw	a3,a5,a4
    80000e84:	fed04be3          	bgtz	a3,80000e7a <strncpy+0x28>
  return os;
}
    80000e88:	6422                	ld	s0,8(sp)
    80000e8a:	0141                	addi	sp,sp,16
    80000e8c:	8082                	ret

0000000080000e8e <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e8e:	1141                	addi	sp,sp,-16
    80000e90:	e422                	sd	s0,8(sp)
    80000e92:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e94:	02c05363          	blez	a2,80000eba <safestrcpy+0x2c>
    80000e98:	fff6069b          	addiw	a3,a2,-1
    80000e9c:	1682                	slli	a3,a3,0x20
    80000e9e:	9281                	srli	a3,a3,0x20
    80000ea0:	96ae                	add	a3,a3,a1
    80000ea2:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000ea4:	00d58963          	beq	a1,a3,80000eb6 <safestrcpy+0x28>
    80000ea8:	0585                	addi	a1,a1,1
    80000eaa:	0785                	addi	a5,a5,1
    80000eac:	fff5c703          	lbu	a4,-1(a1)
    80000eb0:	fee78fa3          	sb	a4,-1(a5)
    80000eb4:	fb65                	bnez	a4,80000ea4 <safestrcpy+0x16>
    ;
  *s = 0;
    80000eb6:	00078023          	sb	zero,0(a5)
  return os;
}
    80000eba:	6422                	ld	s0,8(sp)
    80000ebc:	0141                	addi	sp,sp,16
    80000ebe:	8082                	ret

0000000080000ec0 <strlen>:

int
strlen(const char *s)
{
    80000ec0:	1141                	addi	sp,sp,-16
    80000ec2:	e422                	sd	s0,8(sp)
    80000ec4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000ec6:	00054783          	lbu	a5,0(a0)
    80000eca:	cf91                	beqz	a5,80000ee6 <strlen+0x26>
    80000ecc:	0505                	addi	a0,a0,1
    80000ece:	87aa                	mv	a5,a0
    80000ed0:	86be                	mv	a3,a5
    80000ed2:	0785                	addi	a5,a5,1
    80000ed4:	fff7c703          	lbu	a4,-1(a5)
    80000ed8:	ff65                	bnez	a4,80000ed0 <strlen+0x10>
    80000eda:	40a6853b          	subw	a0,a3,a0
    80000ede:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000ee0:	6422                	ld	s0,8(sp)
    80000ee2:	0141                	addi	sp,sp,16
    80000ee4:	8082                	ret
  for(n = 0; s[n]; n++)
    80000ee6:	4501                	li	a0,0
    80000ee8:	bfe5                	j	80000ee0 <strlen+0x20>

0000000080000eea <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000eea:	1141                	addi	sp,sp,-16
    80000eec:	e406                	sd	ra,8(sp)
    80000eee:	e022                	sd	s0,0(sp)
    80000ef0:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000ef2:	00001097          	auipc	ra,0x1
    80000ef6:	b44080e7          	jalr	-1212(ra) # 80001a36 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000efa:	0000a717          	auipc	a4,0xa
    80000efe:	31e70713          	addi	a4,a4,798 # 8000b218 <started>
  if(cpuid() == 0){
    80000f02:	c139                	beqz	a0,80000f48 <main+0x5e>
    while(started == 0)
    80000f04:	431c                	lw	a5,0(a4)
    80000f06:	2781                	sext.w	a5,a5
    80000f08:	dff5                	beqz	a5,80000f04 <main+0x1a>
      ;
    __sync_synchronize();
    80000f0a:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000f0e:	00001097          	auipc	ra,0x1
    80000f12:	b28080e7          	jalr	-1240(ra) # 80001a36 <cpuid>
    80000f16:	85aa                	mv	a1,a0
    80000f18:	00007517          	auipc	a0,0x7
    80000f1c:	19050513          	addi	a0,a0,400 # 800080a8 <etext+0xa8>
    80000f20:	fffff097          	auipc	ra,0xfffff
    80000f24:	68a080e7          	jalr	1674(ra) # 800005aa <printf>
    kvminithart();    // turn on paging
    80000f28:	00000097          	auipc	ra,0x0
    80000f2c:	0d8080e7          	jalr	216(ra) # 80001000 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000f30:	00001097          	auipc	ra,0x1
    80000f34:	7f2080e7          	jalr	2034(ra) # 80002722 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f38:	00005097          	auipc	ra,0x5
    80000f3c:	ebc080e7          	jalr	-324(ra) # 80005df4 <plicinithart>
  }

  scheduler();        
    80000f40:	00001097          	auipc	ra,0x1
    80000f44:	01a080e7          	jalr	26(ra) # 80001f5a <scheduler>
    consoleinit();
    80000f48:	fffff097          	auipc	ra,0xfffff
    80000f4c:	528080e7          	jalr	1320(ra) # 80000470 <consoleinit>
    printfinit();
    80000f50:	00000097          	auipc	ra,0x0
    80000f54:	862080e7          	jalr	-1950(ra) # 800007b2 <printfinit>
    printf("\n");
    80000f58:	00007517          	auipc	a0,0x7
    80000f5c:	0b850513          	addi	a0,a0,184 # 80008010 <etext+0x10>
    80000f60:	fffff097          	auipc	ra,0xfffff
    80000f64:	64a080e7          	jalr	1610(ra) # 800005aa <printf>
    printf("xv6 kernel is booting\n");
    80000f68:	00007517          	auipc	a0,0x7
    80000f6c:	12850513          	addi	a0,a0,296 # 80008090 <etext+0x90>
    80000f70:	fffff097          	auipc	ra,0xfffff
    80000f74:	63a080e7          	jalr	1594(ra) # 800005aa <printf>
    printf("\n");
    80000f78:	00007517          	auipc	a0,0x7
    80000f7c:	09850513          	addi	a0,a0,152 # 80008010 <etext+0x10>
    80000f80:	fffff097          	auipc	ra,0xfffff
    80000f84:	62a080e7          	jalr	1578(ra) # 800005aa <printf>
    kinit();         // physical page allocator
    80000f88:	00000097          	auipc	ra,0x0
    80000f8c:	b9c080e7          	jalr	-1124(ra) # 80000b24 <kinit>
    kvminit();       // create kernel page table
    80000f90:	00000097          	auipc	ra,0x0
    80000f94:	326080e7          	jalr	806(ra) # 800012b6 <kvminit>
    kvminithart();   // turn on paging
    80000f98:	00000097          	auipc	ra,0x0
    80000f9c:	068080e7          	jalr	104(ra) # 80001000 <kvminithart>
    procinit();      // process table
    80000fa0:	00001097          	auipc	ra,0x1
    80000fa4:	9d4080e7          	jalr	-1580(ra) # 80001974 <procinit>
    trapinit();      // trap vectors
    80000fa8:	00001097          	auipc	ra,0x1
    80000fac:	752080e7          	jalr	1874(ra) # 800026fa <trapinit>
    trapinithart();  // install kernel trap vector
    80000fb0:	00001097          	auipc	ra,0x1
    80000fb4:	772080e7          	jalr	1906(ra) # 80002722 <trapinithart>
    plicinit();      // set up interrupt controller
    80000fb8:	00005097          	auipc	ra,0x5
    80000fbc:	e22080e7          	jalr	-478(ra) # 80005dda <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000fc0:	00005097          	auipc	ra,0x5
    80000fc4:	e34080e7          	jalr	-460(ra) # 80005df4 <plicinithart>
    binit();         // buffer cache
    80000fc8:	00002097          	auipc	ra,0x2
    80000fcc:	f00080e7          	jalr	-256(ra) # 80002ec8 <binit>
    iinit();         // inode table
    80000fd0:	00002097          	auipc	ra,0x2
    80000fd4:	5b6080e7          	jalr	1462(ra) # 80003586 <iinit>
    fileinit();      // file table
    80000fd8:	00003097          	auipc	ra,0x3
    80000fdc:	566080e7          	jalr	1382(ra) # 8000453e <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000fe0:	00005097          	auipc	ra,0x5
    80000fe4:	f1c080e7          	jalr	-228(ra) # 80005efc <virtio_disk_init>
    userinit();      // first user process
    80000fe8:	00001097          	auipc	ra,0x1
    80000fec:	d52080e7          	jalr	-686(ra) # 80001d3a <userinit>
    __sync_synchronize();
    80000ff0:	0330000f          	fence	rw,rw
    started = 1;
    80000ff4:	4785                	li	a5,1
    80000ff6:	0000a717          	auipc	a4,0xa
    80000ffa:	22f72123          	sw	a5,546(a4) # 8000b218 <started>
    80000ffe:	b789                	j	80000f40 <main+0x56>

0000000080001000 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80001000:	1141                	addi	sp,sp,-16
    80001002:	e422                	sd	s0,8(sp)
    80001004:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80001006:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000100a:	0000a797          	auipc	a5,0xa
    8000100e:	2167b783          	ld	a5,534(a5) # 8000b220 <kernel_pagetable>
    80001012:	83b1                	srli	a5,a5,0xc
    80001014:	577d                	li	a4,-1
    80001016:	177e                	slli	a4,a4,0x3f
    80001018:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000101a:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000101e:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80001022:	6422                	ld	s0,8(sp)
    80001024:	0141                	addi	sp,sp,16
    80001026:	8082                	ret

0000000080001028 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80001028:	7139                	addi	sp,sp,-64
    8000102a:	fc06                	sd	ra,56(sp)
    8000102c:	f822                	sd	s0,48(sp)
    8000102e:	f426                	sd	s1,40(sp)
    80001030:	f04a                	sd	s2,32(sp)
    80001032:	ec4e                	sd	s3,24(sp)
    80001034:	e852                	sd	s4,16(sp)
    80001036:	e456                	sd	s5,8(sp)
    80001038:	e05a                	sd	s6,0(sp)
    8000103a:	0080                	addi	s0,sp,64
    8000103c:	84aa                	mv	s1,a0
    8000103e:	89ae                	mv	s3,a1
    80001040:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80001042:	57fd                	li	a5,-1
    80001044:	83e9                	srli	a5,a5,0x1a
    80001046:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80001048:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000104a:	04b7f263          	bgeu	a5,a1,8000108e <walk+0x66>
    panic("walk");
    8000104e:	00007517          	auipc	a0,0x7
    80001052:	07250513          	addi	a0,a0,114 # 800080c0 <etext+0xc0>
    80001056:	fffff097          	auipc	ra,0xfffff
    8000105a:	50a080e7          	jalr	1290(ra) # 80000560 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000105e:	060a8663          	beqz	s5,800010ca <walk+0xa2>
    80001062:	00000097          	auipc	ra,0x0
    80001066:	afe080e7          	jalr	-1282(ra) # 80000b60 <kalloc>
    8000106a:	84aa                	mv	s1,a0
    8000106c:	c529                	beqz	a0,800010b6 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000106e:	6605                	lui	a2,0x1
    80001070:	4581                	li	a1,0
    80001072:	00000097          	auipc	ra,0x0
    80001076:	cda080e7          	jalr	-806(ra) # 80000d4c <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000107a:	00c4d793          	srli	a5,s1,0xc
    8000107e:	07aa                	slli	a5,a5,0xa
    80001080:	0017e793          	ori	a5,a5,1
    80001084:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001088:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffda917>
    8000108a:	036a0063          	beq	s4,s6,800010aa <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    8000108e:	0149d933          	srl	s2,s3,s4
    80001092:	1ff97913          	andi	s2,s2,511
    80001096:	090e                	slli	s2,s2,0x3
    80001098:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000109a:	00093483          	ld	s1,0(s2)
    8000109e:	0014f793          	andi	a5,s1,1
    800010a2:	dfd5                	beqz	a5,8000105e <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800010a4:	80a9                	srli	s1,s1,0xa
    800010a6:	04b2                	slli	s1,s1,0xc
    800010a8:	b7c5                	j	80001088 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800010aa:	00c9d513          	srli	a0,s3,0xc
    800010ae:	1ff57513          	andi	a0,a0,511
    800010b2:	050e                	slli	a0,a0,0x3
    800010b4:	9526                	add	a0,a0,s1
}
    800010b6:	70e2                	ld	ra,56(sp)
    800010b8:	7442                	ld	s0,48(sp)
    800010ba:	74a2                	ld	s1,40(sp)
    800010bc:	7902                	ld	s2,32(sp)
    800010be:	69e2                	ld	s3,24(sp)
    800010c0:	6a42                	ld	s4,16(sp)
    800010c2:	6aa2                	ld	s5,8(sp)
    800010c4:	6b02                	ld	s6,0(sp)
    800010c6:	6121                	addi	sp,sp,64
    800010c8:	8082                	ret
        return 0;
    800010ca:	4501                	li	a0,0
    800010cc:	b7ed                	j	800010b6 <walk+0x8e>

00000000800010ce <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800010ce:	57fd                	li	a5,-1
    800010d0:	83e9                	srli	a5,a5,0x1a
    800010d2:	00b7f463          	bgeu	a5,a1,800010da <walkaddr+0xc>
    return 0;
    800010d6:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800010d8:	8082                	ret
{
    800010da:	1141                	addi	sp,sp,-16
    800010dc:	e406                	sd	ra,8(sp)
    800010de:	e022                	sd	s0,0(sp)
    800010e0:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800010e2:	4601                	li	a2,0
    800010e4:	00000097          	auipc	ra,0x0
    800010e8:	f44080e7          	jalr	-188(ra) # 80001028 <walk>
  if(pte == 0)
    800010ec:	c105                	beqz	a0,8000110c <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800010ee:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800010f0:	0117f693          	andi	a3,a5,17
    800010f4:	4745                	li	a4,17
    return 0;
    800010f6:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800010f8:	00e68663          	beq	a3,a4,80001104 <walkaddr+0x36>
}
    800010fc:	60a2                	ld	ra,8(sp)
    800010fe:	6402                	ld	s0,0(sp)
    80001100:	0141                	addi	sp,sp,16
    80001102:	8082                	ret
  pa = PTE2PA(*pte);
    80001104:	83a9                	srli	a5,a5,0xa
    80001106:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000110a:	bfcd                	j	800010fc <walkaddr+0x2e>
    return 0;
    8000110c:	4501                	li	a0,0
    8000110e:	b7fd                	j	800010fc <walkaddr+0x2e>

0000000080001110 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001110:	715d                	addi	sp,sp,-80
    80001112:	e486                	sd	ra,72(sp)
    80001114:	e0a2                	sd	s0,64(sp)
    80001116:	fc26                	sd	s1,56(sp)
    80001118:	f84a                	sd	s2,48(sp)
    8000111a:	f44e                	sd	s3,40(sp)
    8000111c:	f052                	sd	s4,32(sp)
    8000111e:	ec56                	sd	s5,24(sp)
    80001120:	e85a                	sd	s6,16(sp)
    80001122:	e45e                	sd	s7,8(sp)
    80001124:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80001126:	c639                	beqz	a2,80001174 <mappages+0x64>
    80001128:	8aaa                	mv	s5,a0
    8000112a:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000112c:	777d                	lui	a4,0xfffff
    8000112e:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80001132:	fff58993          	addi	s3,a1,-1
    80001136:	99b2                	add	s3,s3,a2
    80001138:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    8000113c:	893e                	mv	s2,a5
    8000113e:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001142:	6b85                	lui	s7,0x1
    80001144:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80001148:	4605                	li	a2,1
    8000114a:	85ca                	mv	a1,s2
    8000114c:	8556                	mv	a0,s5
    8000114e:	00000097          	auipc	ra,0x0
    80001152:	eda080e7          	jalr	-294(ra) # 80001028 <walk>
    80001156:	cd1d                	beqz	a0,80001194 <mappages+0x84>
    if(*pte & PTE_V)
    80001158:	611c                	ld	a5,0(a0)
    8000115a:	8b85                	andi	a5,a5,1
    8000115c:	e785                	bnez	a5,80001184 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000115e:	80b1                	srli	s1,s1,0xc
    80001160:	04aa                	slli	s1,s1,0xa
    80001162:	0164e4b3          	or	s1,s1,s6
    80001166:	0014e493          	ori	s1,s1,1
    8000116a:	e104                	sd	s1,0(a0)
    if(a == last)
    8000116c:	05390063          	beq	s2,s3,800011ac <mappages+0x9c>
    a += PGSIZE;
    80001170:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001172:	bfc9                	j	80001144 <mappages+0x34>
    panic("mappages: size");
    80001174:	00007517          	auipc	a0,0x7
    80001178:	f5450513          	addi	a0,a0,-172 # 800080c8 <etext+0xc8>
    8000117c:	fffff097          	auipc	ra,0xfffff
    80001180:	3e4080e7          	jalr	996(ra) # 80000560 <panic>
      panic("mappages: remap");
    80001184:	00007517          	auipc	a0,0x7
    80001188:	f5450513          	addi	a0,a0,-172 # 800080d8 <etext+0xd8>
    8000118c:	fffff097          	auipc	ra,0xfffff
    80001190:	3d4080e7          	jalr	980(ra) # 80000560 <panic>
      return -1;
    80001194:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001196:	60a6                	ld	ra,72(sp)
    80001198:	6406                	ld	s0,64(sp)
    8000119a:	74e2                	ld	s1,56(sp)
    8000119c:	7942                	ld	s2,48(sp)
    8000119e:	79a2                	ld	s3,40(sp)
    800011a0:	7a02                	ld	s4,32(sp)
    800011a2:	6ae2                	ld	s5,24(sp)
    800011a4:	6b42                	ld	s6,16(sp)
    800011a6:	6ba2                	ld	s7,8(sp)
    800011a8:	6161                	addi	sp,sp,80
    800011aa:	8082                	ret
  return 0;
    800011ac:	4501                	li	a0,0
    800011ae:	b7e5                	j	80001196 <mappages+0x86>

00000000800011b0 <kvmmap>:
{
    800011b0:	1141                	addi	sp,sp,-16
    800011b2:	e406                	sd	ra,8(sp)
    800011b4:	e022                	sd	s0,0(sp)
    800011b6:	0800                	addi	s0,sp,16
    800011b8:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800011ba:	86b2                	mv	a3,a2
    800011bc:	863e                	mv	a2,a5
    800011be:	00000097          	auipc	ra,0x0
    800011c2:	f52080e7          	jalr	-174(ra) # 80001110 <mappages>
    800011c6:	e509                	bnez	a0,800011d0 <kvmmap+0x20>
}
    800011c8:	60a2                	ld	ra,8(sp)
    800011ca:	6402                	ld	s0,0(sp)
    800011cc:	0141                	addi	sp,sp,16
    800011ce:	8082                	ret
    panic("kvmmap");
    800011d0:	00007517          	auipc	a0,0x7
    800011d4:	f1850513          	addi	a0,a0,-232 # 800080e8 <etext+0xe8>
    800011d8:	fffff097          	auipc	ra,0xfffff
    800011dc:	388080e7          	jalr	904(ra) # 80000560 <panic>

00000000800011e0 <kvmmake>:
{
    800011e0:	1101                	addi	sp,sp,-32
    800011e2:	ec06                	sd	ra,24(sp)
    800011e4:	e822                	sd	s0,16(sp)
    800011e6:	e426                	sd	s1,8(sp)
    800011e8:	e04a                	sd	s2,0(sp)
    800011ea:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800011ec:	00000097          	auipc	ra,0x0
    800011f0:	974080e7          	jalr	-1676(ra) # 80000b60 <kalloc>
    800011f4:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800011f6:	6605                	lui	a2,0x1
    800011f8:	4581                	li	a1,0
    800011fa:	00000097          	auipc	ra,0x0
    800011fe:	b52080e7          	jalr	-1198(ra) # 80000d4c <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001202:	4719                	li	a4,6
    80001204:	6685                	lui	a3,0x1
    80001206:	10000637          	lui	a2,0x10000
    8000120a:	100005b7          	lui	a1,0x10000
    8000120e:	8526                	mv	a0,s1
    80001210:	00000097          	auipc	ra,0x0
    80001214:	fa0080e7          	jalr	-96(ra) # 800011b0 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001218:	4719                	li	a4,6
    8000121a:	6685                	lui	a3,0x1
    8000121c:	10001637          	lui	a2,0x10001
    80001220:	100015b7          	lui	a1,0x10001
    80001224:	8526                	mv	a0,s1
    80001226:	00000097          	auipc	ra,0x0
    8000122a:	f8a080e7          	jalr	-118(ra) # 800011b0 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000122e:	4719                	li	a4,6
    80001230:	004006b7          	lui	a3,0x400
    80001234:	0c000637          	lui	a2,0xc000
    80001238:	0c0005b7          	lui	a1,0xc000
    8000123c:	8526                	mv	a0,s1
    8000123e:	00000097          	auipc	ra,0x0
    80001242:	f72080e7          	jalr	-142(ra) # 800011b0 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001246:	00007917          	auipc	s2,0x7
    8000124a:	dba90913          	addi	s2,s2,-582 # 80008000 <etext>
    8000124e:	4729                	li	a4,10
    80001250:	80007697          	auipc	a3,0x80007
    80001254:	db068693          	addi	a3,a3,-592 # 8000 <_entry-0x7fff8000>
    80001258:	4605                	li	a2,1
    8000125a:	067e                	slli	a2,a2,0x1f
    8000125c:	85b2                	mv	a1,a2
    8000125e:	8526                	mv	a0,s1
    80001260:	00000097          	auipc	ra,0x0
    80001264:	f50080e7          	jalr	-176(ra) # 800011b0 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001268:	46c5                	li	a3,17
    8000126a:	06ee                	slli	a3,a3,0x1b
    8000126c:	4719                	li	a4,6
    8000126e:	412686b3          	sub	a3,a3,s2
    80001272:	864a                	mv	a2,s2
    80001274:	85ca                	mv	a1,s2
    80001276:	8526                	mv	a0,s1
    80001278:	00000097          	auipc	ra,0x0
    8000127c:	f38080e7          	jalr	-200(ra) # 800011b0 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001280:	4729                	li	a4,10
    80001282:	6685                	lui	a3,0x1
    80001284:	00006617          	auipc	a2,0x6
    80001288:	d7c60613          	addi	a2,a2,-644 # 80007000 <_trampoline>
    8000128c:	040005b7          	lui	a1,0x4000
    80001290:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001292:	05b2                	slli	a1,a1,0xc
    80001294:	8526                	mv	a0,s1
    80001296:	00000097          	auipc	ra,0x0
    8000129a:	f1a080e7          	jalr	-230(ra) # 800011b0 <kvmmap>
  proc_mapstacks(kpgtbl);
    8000129e:	8526                	mv	a0,s1
    800012a0:	00000097          	auipc	ra,0x0
    800012a4:	630080e7          	jalr	1584(ra) # 800018d0 <proc_mapstacks>
}
    800012a8:	8526                	mv	a0,s1
    800012aa:	60e2                	ld	ra,24(sp)
    800012ac:	6442                	ld	s0,16(sp)
    800012ae:	64a2                	ld	s1,8(sp)
    800012b0:	6902                	ld	s2,0(sp)
    800012b2:	6105                	addi	sp,sp,32
    800012b4:	8082                	ret

00000000800012b6 <kvminit>:
{
    800012b6:	1141                	addi	sp,sp,-16
    800012b8:	e406                	sd	ra,8(sp)
    800012ba:	e022                	sd	s0,0(sp)
    800012bc:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800012be:	00000097          	auipc	ra,0x0
    800012c2:	f22080e7          	jalr	-222(ra) # 800011e0 <kvmmake>
    800012c6:	0000a797          	auipc	a5,0xa
    800012ca:	f4a7bd23          	sd	a0,-166(a5) # 8000b220 <kernel_pagetable>
}
    800012ce:	60a2                	ld	ra,8(sp)
    800012d0:	6402                	ld	s0,0(sp)
    800012d2:	0141                	addi	sp,sp,16
    800012d4:	8082                	ret

00000000800012d6 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800012d6:	715d                	addi	sp,sp,-80
    800012d8:	e486                	sd	ra,72(sp)
    800012da:	e0a2                	sd	s0,64(sp)
    800012dc:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800012de:	03459793          	slli	a5,a1,0x34
    800012e2:	e39d                	bnez	a5,80001308 <uvmunmap+0x32>
    800012e4:	f84a                	sd	s2,48(sp)
    800012e6:	f44e                	sd	s3,40(sp)
    800012e8:	f052                	sd	s4,32(sp)
    800012ea:	ec56                	sd	s5,24(sp)
    800012ec:	e85a                	sd	s6,16(sp)
    800012ee:	e45e                	sd	s7,8(sp)
    800012f0:	8a2a                	mv	s4,a0
    800012f2:	892e                	mv	s2,a1
    800012f4:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012f6:	0632                	slli	a2,a2,0xc
    800012f8:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800012fc:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012fe:	6b05                	lui	s6,0x1
    80001300:	0935fb63          	bgeu	a1,s3,80001396 <uvmunmap+0xc0>
    80001304:	fc26                	sd	s1,56(sp)
    80001306:	a8a9                	j	80001360 <uvmunmap+0x8a>
    80001308:	fc26                	sd	s1,56(sp)
    8000130a:	f84a                	sd	s2,48(sp)
    8000130c:	f44e                	sd	s3,40(sp)
    8000130e:	f052                	sd	s4,32(sp)
    80001310:	ec56                	sd	s5,24(sp)
    80001312:	e85a                	sd	s6,16(sp)
    80001314:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80001316:	00007517          	auipc	a0,0x7
    8000131a:	dda50513          	addi	a0,a0,-550 # 800080f0 <etext+0xf0>
    8000131e:	fffff097          	auipc	ra,0xfffff
    80001322:	242080e7          	jalr	578(ra) # 80000560 <panic>
      panic("uvmunmap: walk");
    80001326:	00007517          	auipc	a0,0x7
    8000132a:	de250513          	addi	a0,a0,-542 # 80008108 <etext+0x108>
    8000132e:	fffff097          	auipc	ra,0xfffff
    80001332:	232080e7          	jalr	562(ra) # 80000560 <panic>
      panic("uvmunmap: not mapped");
    80001336:	00007517          	auipc	a0,0x7
    8000133a:	de250513          	addi	a0,a0,-542 # 80008118 <etext+0x118>
    8000133e:	fffff097          	auipc	ra,0xfffff
    80001342:	222080e7          	jalr	546(ra) # 80000560 <panic>
      panic("uvmunmap: not a leaf");
    80001346:	00007517          	auipc	a0,0x7
    8000134a:	dea50513          	addi	a0,a0,-534 # 80008130 <etext+0x130>
    8000134e:	fffff097          	auipc	ra,0xfffff
    80001352:	212080e7          	jalr	530(ra) # 80000560 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80001356:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000135a:	995a                	add	s2,s2,s6
    8000135c:	03397c63          	bgeu	s2,s3,80001394 <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001360:	4601                	li	a2,0
    80001362:	85ca                	mv	a1,s2
    80001364:	8552                	mv	a0,s4
    80001366:	00000097          	auipc	ra,0x0
    8000136a:	cc2080e7          	jalr	-830(ra) # 80001028 <walk>
    8000136e:	84aa                	mv	s1,a0
    80001370:	d95d                	beqz	a0,80001326 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    80001372:	6108                	ld	a0,0(a0)
    80001374:	00157793          	andi	a5,a0,1
    80001378:	dfdd                	beqz	a5,80001336 <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000137a:	3ff57793          	andi	a5,a0,1023
    8000137e:	fd7784e3          	beq	a5,s7,80001346 <uvmunmap+0x70>
    if(do_free){
    80001382:	fc0a8ae3          	beqz	s5,80001356 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    80001386:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001388:	0532                	slli	a0,a0,0xc
    8000138a:	fffff097          	auipc	ra,0xfffff
    8000138e:	6d8080e7          	jalr	1752(ra) # 80000a62 <kfree>
    80001392:	b7d1                	j	80001356 <uvmunmap+0x80>
    80001394:	74e2                	ld	s1,56(sp)
    80001396:	7942                	ld	s2,48(sp)
    80001398:	79a2                	ld	s3,40(sp)
    8000139a:	7a02                	ld	s4,32(sp)
    8000139c:	6ae2                	ld	s5,24(sp)
    8000139e:	6b42                	ld	s6,16(sp)
    800013a0:	6ba2                	ld	s7,8(sp)
  }
}
    800013a2:	60a6                	ld	ra,72(sp)
    800013a4:	6406                	ld	s0,64(sp)
    800013a6:	6161                	addi	sp,sp,80
    800013a8:	8082                	ret

00000000800013aa <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800013aa:	1101                	addi	sp,sp,-32
    800013ac:	ec06                	sd	ra,24(sp)
    800013ae:	e822                	sd	s0,16(sp)
    800013b0:	e426                	sd	s1,8(sp)
    800013b2:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800013b4:	fffff097          	auipc	ra,0xfffff
    800013b8:	7ac080e7          	jalr	1964(ra) # 80000b60 <kalloc>
    800013bc:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800013be:	c519                	beqz	a0,800013cc <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800013c0:	6605                	lui	a2,0x1
    800013c2:	4581                	li	a1,0
    800013c4:	00000097          	auipc	ra,0x0
    800013c8:	988080e7          	jalr	-1656(ra) # 80000d4c <memset>
  return pagetable;
}
    800013cc:	8526                	mv	a0,s1
    800013ce:	60e2                	ld	ra,24(sp)
    800013d0:	6442                	ld	s0,16(sp)
    800013d2:	64a2                	ld	s1,8(sp)
    800013d4:	6105                	addi	sp,sp,32
    800013d6:	8082                	ret

00000000800013d8 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800013d8:	7179                	addi	sp,sp,-48
    800013da:	f406                	sd	ra,40(sp)
    800013dc:	f022                	sd	s0,32(sp)
    800013de:	ec26                	sd	s1,24(sp)
    800013e0:	e84a                	sd	s2,16(sp)
    800013e2:	e44e                	sd	s3,8(sp)
    800013e4:	e052                	sd	s4,0(sp)
    800013e6:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800013e8:	6785                	lui	a5,0x1
    800013ea:	04f67863          	bgeu	a2,a5,8000143a <uvmfirst+0x62>
    800013ee:	8a2a                	mv	s4,a0
    800013f0:	89ae                	mv	s3,a1
    800013f2:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800013f4:	fffff097          	auipc	ra,0xfffff
    800013f8:	76c080e7          	jalr	1900(ra) # 80000b60 <kalloc>
    800013fc:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800013fe:	6605                	lui	a2,0x1
    80001400:	4581                	li	a1,0
    80001402:	00000097          	auipc	ra,0x0
    80001406:	94a080e7          	jalr	-1718(ra) # 80000d4c <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000140a:	4779                	li	a4,30
    8000140c:	86ca                	mv	a3,s2
    8000140e:	6605                	lui	a2,0x1
    80001410:	4581                	li	a1,0
    80001412:	8552                	mv	a0,s4
    80001414:	00000097          	auipc	ra,0x0
    80001418:	cfc080e7          	jalr	-772(ra) # 80001110 <mappages>
  memmove(mem, src, sz);
    8000141c:	8626                	mv	a2,s1
    8000141e:	85ce                	mv	a1,s3
    80001420:	854a                	mv	a0,s2
    80001422:	00000097          	auipc	ra,0x0
    80001426:	986080e7          	jalr	-1658(ra) # 80000da8 <memmove>
}
    8000142a:	70a2                	ld	ra,40(sp)
    8000142c:	7402                	ld	s0,32(sp)
    8000142e:	64e2                	ld	s1,24(sp)
    80001430:	6942                	ld	s2,16(sp)
    80001432:	69a2                	ld	s3,8(sp)
    80001434:	6a02                	ld	s4,0(sp)
    80001436:	6145                	addi	sp,sp,48
    80001438:	8082                	ret
    panic("uvmfirst: more than a page");
    8000143a:	00007517          	auipc	a0,0x7
    8000143e:	d0e50513          	addi	a0,a0,-754 # 80008148 <etext+0x148>
    80001442:	fffff097          	auipc	ra,0xfffff
    80001446:	11e080e7          	jalr	286(ra) # 80000560 <panic>

000000008000144a <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000144a:	1101                	addi	sp,sp,-32
    8000144c:	ec06                	sd	ra,24(sp)
    8000144e:	e822                	sd	s0,16(sp)
    80001450:	e426                	sd	s1,8(sp)
    80001452:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001454:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001456:	00b67d63          	bgeu	a2,a1,80001470 <uvmdealloc+0x26>
    8000145a:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000145c:	6785                	lui	a5,0x1
    8000145e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001460:	00f60733          	add	a4,a2,a5
    80001464:	76fd                	lui	a3,0xfffff
    80001466:	8f75                	and	a4,a4,a3
    80001468:	97ae                	add	a5,a5,a1
    8000146a:	8ff5                	and	a5,a5,a3
    8000146c:	00f76863          	bltu	a4,a5,8000147c <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001470:	8526                	mv	a0,s1
    80001472:	60e2                	ld	ra,24(sp)
    80001474:	6442                	ld	s0,16(sp)
    80001476:	64a2                	ld	s1,8(sp)
    80001478:	6105                	addi	sp,sp,32
    8000147a:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000147c:	8f99                	sub	a5,a5,a4
    8000147e:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001480:	4685                	li	a3,1
    80001482:	0007861b          	sext.w	a2,a5
    80001486:	85ba                	mv	a1,a4
    80001488:	00000097          	auipc	ra,0x0
    8000148c:	e4e080e7          	jalr	-434(ra) # 800012d6 <uvmunmap>
    80001490:	b7c5                	j	80001470 <uvmdealloc+0x26>

0000000080001492 <uvmalloc>:
  if(newsz < oldsz)
    80001492:	0ab66b63          	bltu	a2,a1,80001548 <uvmalloc+0xb6>
{
    80001496:	7139                	addi	sp,sp,-64
    80001498:	fc06                	sd	ra,56(sp)
    8000149a:	f822                	sd	s0,48(sp)
    8000149c:	ec4e                	sd	s3,24(sp)
    8000149e:	e852                	sd	s4,16(sp)
    800014a0:	e456                	sd	s5,8(sp)
    800014a2:	0080                	addi	s0,sp,64
    800014a4:	8aaa                	mv	s5,a0
    800014a6:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800014a8:	6785                	lui	a5,0x1
    800014aa:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800014ac:	95be                	add	a1,a1,a5
    800014ae:	77fd                	lui	a5,0xfffff
    800014b0:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800014b4:	08c9fc63          	bgeu	s3,a2,8000154c <uvmalloc+0xba>
    800014b8:	f426                	sd	s1,40(sp)
    800014ba:	f04a                	sd	s2,32(sp)
    800014bc:	e05a                	sd	s6,0(sp)
    800014be:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800014c0:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800014c4:	fffff097          	auipc	ra,0xfffff
    800014c8:	69c080e7          	jalr	1692(ra) # 80000b60 <kalloc>
    800014cc:	84aa                	mv	s1,a0
    if(mem == 0){
    800014ce:	c915                	beqz	a0,80001502 <uvmalloc+0x70>
    memset(mem, 0, PGSIZE);
    800014d0:	6605                	lui	a2,0x1
    800014d2:	4581                	li	a1,0
    800014d4:	00000097          	auipc	ra,0x0
    800014d8:	878080e7          	jalr	-1928(ra) # 80000d4c <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800014dc:	875a                	mv	a4,s6
    800014de:	86a6                	mv	a3,s1
    800014e0:	6605                	lui	a2,0x1
    800014e2:	85ca                	mv	a1,s2
    800014e4:	8556                	mv	a0,s5
    800014e6:	00000097          	auipc	ra,0x0
    800014ea:	c2a080e7          	jalr	-982(ra) # 80001110 <mappages>
    800014ee:	ed05                	bnez	a0,80001526 <uvmalloc+0x94>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800014f0:	6785                	lui	a5,0x1
    800014f2:	993e                	add	s2,s2,a5
    800014f4:	fd4968e3          	bltu	s2,s4,800014c4 <uvmalloc+0x32>
  return newsz;
    800014f8:	8552                	mv	a0,s4
    800014fa:	74a2                	ld	s1,40(sp)
    800014fc:	7902                	ld	s2,32(sp)
    800014fe:	6b02                	ld	s6,0(sp)
    80001500:	a821                	j	80001518 <uvmalloc+0x86>
      uvmdealloc(pagetable, a, oldsz);
    80001502:	864e                	mv	a2,s3
    80001504:	85ca                	mv	a1,s2
    80001506:	8556                	mv	a0,s5
    80001508:	00000097          	auipc	ra,0x0
    8000150c:	f42080e7          	jalr	-190(ra) # 8000144a <uvmdealloc>
      return 0;
    80001510:	4501                	li	a0,0
    80001512:	74a2                	ld	s1,40(sp)
    80001514:	7902                	ld	s2,32(sp)
    80001516:	6b02                	ld	s6,0(sp)
}
    80001518:	70e2                	ld	ra,56(sp)
    8000151a:	7442                	ld	s0,48(sp)
    8000151c:	69e2                	ld	s3,24(sp)
    8000151e:	6a42                	ld	s4,16(sp)
    80001520:	6aa2                	ld	s5,8(sp)
    80001522:	6121                	addi	sp,sp,64
    80001524:	8082                	ret
      kfree(mem);
    80001526:	8526                	mv	a0,s1
    80001528:	fffff097          	auipc	ra,0xfffff
    8000152c:	53a080e7          	jalr	1338(ra) # 80000a62 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001530:	864e                	mv	a2,s3
    80001532:	85ca                	mv	a1,s2
    80001534:	8556                	mv	a0,s5
    80001536:	00000097          	auipc	ra,0x0
    8000153a:	f14080e7          	jalr	-236(ra) # 8000144a <uvmdealloc>
      return 0;
    8000153e:	4501                	li	a0,0
    80001540:	74a2                	ld	s1,40(sp)
    80001542:	7902                	ld	s2,32(sp)
    80001544:	6b02                	ld	s6,0(sp)
    80001546:	bfc9                	j	80001518 <uvmalloc+0x86>
    return oldsz;
    80001548:	852e                	mv	a0,a1
}
    8000154a:	8082                	ret
  return newsz;
    8000154c:	8532                	mv	a0,a2
    8000154e:	b7e9                	j	80001518 <uvmalloc+0x86>

0000000080001550 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001550:	7179                	addi	sp,sp,-48
    80001552:	f406                	sd	ra,40(sp)
    80001554:	f022                	sd	s0,32(sp)
    80001556:	ec26                	sd	s1,24(sp)
    80001558:	e84a                	sd	s2,16(sp)
    8000155a:	e44e                	sd	s3,8(sp)
    8000155c:	e052                	sd	s4,0(sp)
    8000155e:	1800                	addi	s0,sp,48
    80001560:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001562:	84aa                	mv	s1,a0
    80001564:	6905                	lui	s2,0x1
    80001566:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001568:	4985                	li	s3,1
    8000156a:	a829                	j	80001584 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000156c:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000156e:	00c79513          	slli	a0,a5,0xc
    80001572:	00000097          	auipc	ra,0x0
    80001576:	fde080e7          	jalr	-34(ra) # 80001550 <freewalk>
      pagetable[i] = 0;
    8000157a:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000157e:	04a1                	addi	s1,s1,8
    80001580:	03248163          	beq	s1,s2,800015a2 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80001584:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001586:	00f7f713          	andi	a4,a5,15
    8000158a:	ff3701e3          	beq	a4,s3,8000156c <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000158e:	8b85                	andi	a5,a5,1
    80001590:	d7fd                	beqz	a5,8000157e <freewalk+0x2e>
      panic("freewalk: leaf");
    80001592:	00007517          	auipc	a0,0x7
    80001596:	bd650513          	addi	a0,a0,-1066 # 80008168 <etext+0x168>
    8000159a:	fffff097          	auipc	ra,0xfffff
    8000159e:	fc6080e7          	jalr	-58(ra) # 80000560 <panic>
    }
  }
  kfree((void*)pagetable);
    800015a2:	8552                	mv	a0,s4
    800015a4:	fffff097          	auipc	ra,0xfffff
    800015a8:	4be080e7          	jalr	1214(ra) # 80000a62 <kfree>
}
    800015ac:	70a2                	ld	ra,40(sp)
    800015ae:	7402                	ld	s0,32(sp)
    800015b0:	64e2                	ld	s1,24(sp)
    800015b2:	6942                	ld	s2,16(sp)
    800015b4:	69a2                	ld	s3,8(sp)
    800015b6:	6a02                	ld	s4,0(sp)
    800015b8:	6145                	addi	sp,sp,48
    800015ba:	8082                	ret

00000000800015bc <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800015bc:	1101                	addi	sp,sp,-32
    800015be:	ec06                	sd	ra,24(sp)
    800015c0:	e822                	sd	s0,16(sp)
    800015c2:	e426                	sd	s1,8(sp)
    800015c4:	1000                	addi	s0,sp,32
    800015c6:	84aa                	mv	s1,a0
  if(sz > 0)
    800015c8:	e999                	bnez	a1,800015de <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800015ca:	8526                	mv	a0,s1
    800015cc:	00000097          	auipc	ra,0x0
    800015d0:	f84080e7          	jalr	-124(ra) # 80001550 <freewalk>
}
    800015d4:	60e2                	ld	ra,24(sp)
    800015d6:	6442                	ld	s0,16(sp)
    800015d8:	64a2                	ld	s1,8(sp)
    800015da:	6105                	addi	sp,sp,32
    800015dc:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800015de:	6785                	lui	a5,0x1
    800015e0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800015e2:	95be                	add	a1,a1,a5
    800015e4:	4685                	li	a3,1
    800015e6:	00c5d613          	srli	a2,a1,0xc
    800015ea:	4581                	li	a1,0
    800015ec:	00000097          	auipc	ra,0x0
    800015f0:	cea080e7          	jalr	-790(ra) # 800012d6 <uvmunmap>
    800015f4:	bfd9                	j	800015ca <uvmfree+0xe>

00000000800015f6 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800015f6:	c679                	beqz	a2,800016c4 <uvmcopy+0xce>
{
    800015f8:	715d                	addi	sp,sp,-80
    800015fa:	e486                	sd	ra,72(sp)
    800015fc:	e0a2                	sd	s0,64(sp)
    800015fe:	fc26                	sd	s1,56(sp)
    80001600:	f84a                	sd	s2,48(sp)
    80001602:	f44e                	sd	s3,40(sp)
    80001604:	f052                	sd	s4,32(sp)
    80001606:	ec56                	sd	s5,24(sp)
    80001608:	e85a                	sd	s6,16(sp)
    8000160a:	e45e                	sd	s7,8(sp)
    8000160c:	0880                	addi	s0,sp,80
    8000160e:	8b2a                	mv	s6,a0
    80001610:	8aae                	mv	s5,a1
    80001612:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001614:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001616:	4601                	li	a2,0
    80001618:	85ce                	mv	a1,s3
    8000161a:	855a                	mv	a0,s6
    8000161c:	00000097          	auipc	ra,0x0
    80001620:	a0c080e7          	jalr	-1524(ra) # 80001028 <walk>
    80001624:	c531                	beqz	a0,80001670 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80001626:	6118                	ld	a4,0(a0)
    80001628:	00177793          	andi	a5,a4,1
    8000162c:	cbb1                	beqz	a5,80001680 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    8000162e:	00a75593          	srli	a1,a4,0xa
    80001632:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001636:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000163a:	fffff097          	auipc	ra,0xfffff
    8000163e:	526080e7          	jalr	1318(ra) # 80000b60 <kalloc>
    80001642:	892a                	mv	s2,a0
    80001644:	c939                	beqz	a0,8000169a <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001646:	6605                	lui	a2,0x1
    80001648:	85de                	mv	a1,s7
    8000164a:	fffff097          	auipc	ra,0xfffff
    8000164e:	75e080e7          	jalr	1886(ra) # 80000da8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001652:	8726                	mv	a4,s1
    80001654:	86ca                	mv	a3,s2
    80001656:	6605                	lui	a2,0x1
    80001658:	85ce                	mv	a1,s3
    8000165a:	8556                	mv	a0,s5
    8000165c:	00000097          	auipc	ra,0x0
    80001660:	ab4080e7          	jalr	-1356(ra) # 80001110 <mappages>
    80001664:	e515                	bnez	a0,80001690 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80001666:	6785                	lui	a5,0x1
    80001668:	99be                	add	s3,s3,a5
    8000166a:	fb49e6e3          	bltu	s3,s4,80001616 <uvmcopy+0x20>
    8000166e:	a081                	j	800016ae <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80001670:	00007517          	auipc	a0,0x7
    80001674:	b0850513          	addi	a0,a0,-1272 # 80008178 <etext+0x178>
    80001678:	fffff097          	auipc	ra,0xfffff
    8000167c:	ee8080e7          	jalr	-280(ra) # 80000560 <panic>
      panic("uvmcopy: page not present");
    80001680:	00007517          	auipc	a0,0x7
    80001684:	b1850513          	addi	a0,a0,-1256 # 80008198 <etext+0x198>
    80001688:	fffff097          	auipc	ra,0xfffff
    8000168c:	ed8080e7          	jalr	-296(ra) # 80000560 <panic>
      kfree(mem);
    80001690:	854a                	mv	a0,s2
    80001692:	fffff097          	auipc	ra,0xfffff
    80001696:	3d0080e7          	jalr	976(ra) # 80000a62 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    8000169a:	4685                	li	a3,1
    8000169c:	00c9d613          	srli	a2,s3,0xc
    800016a0:	4581                	li	a1,0
    800016a2:	8556                	mv	a0,s5
    800016a4:	00000097          	auipc	ra,0x0
    800016a8:	c32080e7          	jalr	-974(ra) # 800012d6 <uvmunmap>
  return -1;
    800016ac:	557d                	li	a0,-1
}
    800016ae:	60a6                	ld	ra,72(sp)
    800016b0:	6406                	ld	s0,64(sp)
    800016b2:	74e2                	ld	s1,56(sp)
    800016b4:	7942                	ld	s2,48(sp)
    800016b6:	79a2                	ld	s3,40(sp)
    800016b8:	7a02                	ld	s4,32(sp)
    800016ba:	6ae2                	ld	s5,24(sp)
    800016bc:	6b42                	ld	s6,16(sp)
    800016be:	6ba2                	ld	s7,8(sp)
    800016c0:	6161                	addi	sp,sp,80
    800016c2:	8082                	ret
  return 0;
    800016c4:	4501                	li	a0,0
}
    800016c6:	8082                	ret

00000000800016c8 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800016c8:	1141                	addi	sp,sp,-16
    800016ca:	e406                	sd	ra,8(sp)
    800016cc:	e022                	sd	s0,0(sp)
    800016ce:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800016d0:	4601                	li	a2,0
    800016d2:	00000097          	auipc	ra,0x0
    800016d6:	956080e7          	jalr	-1706(ra) # 80001028 <walk>
  if(pte == 0)
    800016da:	c901                	beqz	a0,800016ea <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800016dc:	611c                	ld	a5,0(a0)
    800016de:	9bbd                	andi	a5,a5,-17
    800016e0:	e11c                	sd	a5,0(a0)
}
    800016e2:	60a2                	ld	ra,8(sp)
    800016e4:	6402                	ld	s0,0(sp)
    800016e6:	0141                	addi	sp,sp,16
    800016e8:	8082                	ret
    panic("uvmclear");
    800016ea:	00007517          	auipc	a0,0x7
    800016ee:	ace50513          	addi	a0,a0,-1330 # 800081b8 <etext+0x1b8>
    800016f2:	fffff097          	auipc	ra,0xfffff
    800016f6:	e6e080e7          	jalr	-402(ra) # 80000560 <panic>

00000000800016fa <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800016fa:	c6bd                	beqz	a3,80001768 <copyout+0x6e>
{
    800016fc:	715d                	addi	sp,sp,-80
    800016fe:	e486                	sd	ra,72(sp)
    80001700:	e0a2                	sd	s0,64(sp)
    80001702:	fc26                	sd	s1,56(sp)
    80001704:	f84a                	sd	s2,48(sp)
    80001706:	f44e                	sd	s3,40(sp)
    80001708:	f052                	sd	s4,32(sp)
    8000170a:	ec56                	sd	s5,24(sp)
    8000170c:	e85a                	sd	s6,16(sp)
    8000170e:	e45e                	sd	s7,8(sp)
    80001710:	e062                	sd	s8,0(sp)
    80001712:	0880                	addi	s0,sp,80
    80001714:	8b2a                	mv	s6,a0
    80001716:	8c2e                	mv	s8,a1
    80001718:	8a32                	mv	s4,a2
    8000171a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000171c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    8000171e:	6a85                	lui	s5,0x1
    80001720:	a015                	j	80001744 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001722:	9562                	add	a0,a0,s8
    80001724:	0004861b          	sext.w	a2,s1
    80001728:	85d2                	mv	a1,s4
    8000172a:	41250533          	sub	a0,a0,s2
    8000172e:	fffff097          	auipc	ra,0xfffff
    80001732:	67a080e7          	jalr	1658(ra) # 80000da8 <memmove>

    len -= n;
    80001736:	409989b3          	sub	s3,s3,s1
    src += n;
    8000173a:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    8000173c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001740:	02098263          	beqz	s3,80001764 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80001744:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001748:	85ca                	mv	a1,s2
    8000174a:	855a                	mv	a0,s6
    8000174c:	00000097          	auipc	ra,0x0
    80001750:	982080e7          	jalr	-1662(ra) # 800010ce <walkaddr>
    if(pa0 == 0)
    80001754:	cd01                	beqz	a0,8000176c <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80001756:	418904b3          	sub	s1,s2,s8
    8000175a:	94d6                	add	s1,s1,s5
    if(n > len)
    8000175c:	fc99f3e3          	bgeu	s3,s1,80001722 <copyout+0x28>
    80001760:	84ce                	mv	s1,s3
    80001762:	b7c1                	j	80001722 <copyout+0x28>
  }
  return 0;
    80001764:	4501                	li	a0,0
    80001766:	a021                	j	8000176e <copyout+0x74>
    80001768:	4501                	li	a0,0
}
    8000176a:	8082                	ret
      return -1;
    8000176c:	557d                	li	a0,-1
}
    8000176e:	60a6                	ld	ra,72(sp)
    80001770:	6406                	ld	s0,64(sp)
    80001772:	74e2                	ld	s1,56(sp)
    80001774:	7942                	ld	s2,48(sp)
    80001776:	79a2                	ld	s3,40(sp)
    80001778:	7a02                	ld	s4,32(sp)
    8000177a:	6ae2                	ld	s5,24(sp)
    8000177c:	6b42                	ld	s6,16(sp)
    8000177e:	6ba2                	ld	s7,8(sp)
    80001780:	6c02                	ld	s8,0(sp)
    80001782:	6161                	addi	sp,sp,80
    80001784:	8082                	ret

0000000080001786 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001786:	caa5                	beqz	a3,800017f6 <copyin+0x70>
{
    80001788:	715d                	addi	sp,sp,-80
    8000178a:	e486                	sd	ra,72(sp)
    8000178c:	e0a2                	sd	s0,64(sp)
    8000178e:	fc26                	sd	s1,56(sp)
    80001790:	f84a                	sd	s2,48(sp)
    80001792:	f44e                	sd	s3,40(sp)
    80001794:	f052                	sd	s4,32(sp)
    80001796:	ec56                	sd	s5,24(sp)
    80001798:	e85a                	sd	s6,16(sp)
    8000179a:	e45e                	sd	s7,8(sp)
    8000179c:	e062                	sd	s8,0(sp)
    8000179e:	0880                	addi	s0,sp,80
    800017a0:	8b2a                	mv	s6,a0
    800017a2:	8a2e                	mv	s4,a1
    800017a4:	8c32                	mv	s8,a2
    800017a6:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800017a8:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800017aa:	6a85                	lui	s5,0x1
    800017ac:	a01d                	j	800017d2 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800017ae:	018505b3          	add	a1,a0,s8
    800017b2:	0004861b          	sext.w	a2,s1
    800017b6:	412585b3          	sub	a1,a1,s2
    800017ba:	8552                	mv	a0,s4
    800017bc:	fffff097          	auipc	ra,0xfffff
    800017c0:	5ec080e7          	jalr	1516(ra) # 80000da8 <memmove>

    len -= n;
    800017c4:	409989b3          	sub	s3,s3,s1
    dst += n;
    800017c8:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    800017ca:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800017ce:	02098263          	beqz	s3,800017f2 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    800017d2:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800017d6:	85ca                	mv	a1,s2
    800017d8:	855a                	mv	a0,s6
    800017da:	00000097          	auipc	ra,0x0
    800017de:	8f4080e7          	jalr	-1804(ra) # 800010ce <walkaddr>
    if(pa0 == 0)
    800017e2:	cd01                	beqz	a0,800017fa <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    800017e4:	418904b3          	sub	s1,s2,s8
    800017e8:	94d6                	add	s1,s1,s5
    if(n > len)
    800017ea:	fc99f2e3          	bgeu	s3,s1,800017ae <copyin+0x28>
    800017ee:	84ce                	mv	s1,s3
    800017f0:	bf7d                	j	800017ae <copyin+0x28>
  }
  return 0;
    800017f2:	4501                	li	a0,0
    800017f4:	a021                	j	800017fc <copyin+0x76>
    800017f6:	4501                	li	a0,0
}
    800017f8:	8082                	ret
      return -1;
    800017fa:	557d                	li	a0,-1
}
    800017fc:	60a6                	ld	ra,72(sp)
    800017fe:	6406                	ld	s0,64(sp)
    80001800:	74e2                	ld	s1,56(sp)
    80001802:	7942                	ld	s2,48(sp)
    80001804:	79a2                	ld	s3,40(sp)
    80001806:	7a02                	ld	s4,32(sp)
    80001808:	6ae2                	ld	s5,24(sp)
    8000180a:	6b42                	ld	s6,16(sp)
    8000180c:	6ba2                	ld	s7,8(sp)
    8000180e:	6c02                	ld	s8,0(sp)
    80001810:	6161                	addi	sp,sp,80
    80001812:	8082                	ret

0000000080001814 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001814:	cacd                	beqz	a3,800018c6 <copyinstr+0xb2>
{
    80001816:	715d                	addi	sp,sp,-80
    80001818:	e486                	sd	ra,72(sp)
    8000181a:	e0a2                	sd	s0,64(sp)
    8000181c:	fc26                	sd	s1,56(sp)
    8000181e:	f84a                	sd	s2,48(sp)
    80001820:	f44e                	sd	s3,40(sp)
    80001822:	f052                	sd	s4,32(sp)
    80001824:	ec56                	sd	s5,24(sp)
    80001826:	e85a                	sd	s6,16(sp)
    80001828:	e45e                	sd	s7,8(sp)
    8000182a:	0880                	addi	s0,sp,80
    8000182c:	8a2a                	mv	s4,a0
    8000182e:	8b2e                	mv	s6,a1
    80001830:	8bb2                	mv	s7,a2
    80001832:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80001834:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001836:	6985                	lui	s3,0x1
    80001838:	a825                	j	80001870 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    8000183a:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    8000183e:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001840:	37fd                	addiw	a5,a5,-1
    80001842:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001846:	60a6                	ld	ra,72(sp)
    80001848:	6406                	ld	s0,64(sp)
    8000184a:	74e2                	ld	s1,56(sp)
    8000184c:	7942                	ld	s2,48(sp)
    8000184e:	79a2                	ld	s3,40(sp)
    80001850:	7a02                	ld	s4,32(sp)
    80001852:	6ae2                	ld	s5,24(sp)
    80001854:	6b42                	ld	s6,16(sp)
    80001856:	6ba2                	ld	s7,8(sp)
    80001858:	6161                	addi	sp,sp,80
    8000185a:	8082                	ret
    8000185c:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80001860:	9742                	add	a4,a4,a6
      --max;
    80001862:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80001866:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    8000186a:	04e58663          	beq	a1,a4,800018b6 <copyinstr+0xa2>
{
    8000186e:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80001870:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80001874:	85a6                	mv	a1,s1
    80001876:	8552                	mv	a0,s4
    80001878:	00000097          	auipc	ra,0x0
    8000187c:	856080e7          	jalr	-1962(ra) # 800010ce <walkaddr>
    if(pa0 == 0)
    80001880:	cd0d                	beqz	a0,800018ba <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80001882:	417486b3          	sub	a3,s1,s7
    80001886:	96ce                	add	a3,a3,s3
    if(n > max)
    80001888:	00d97363          	bgeu	s2,a3,8000188e <copyinstr+0x7a>
    8000188c:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    8000188e:	955e                	add	a0,a0,s7
    80001890:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80001892:	c695                	beqz	a3,800018be <copyinstr+0xaa>
    80001894:	87da                	mv	a5,s6
    80001896:	885a                	mv	a6,s6
      if(*p == '\0'){
    80001898:	41650633          	sub	a2,a0,s6
    while(n > 0){
    8000189c:	96da                	add	a3,a3,s6
    8000189e:	85be                	mv	a1,a5
      if(*p == '\0'){
    800018a0:	00f60733          	add	a4,a2,a5
    800018a4:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffda920>
    800018a8:	db49                	beqz	a4,8000183a <copyinstr+0x26>
        *dst = *p;
    800018aa:	00e78023          	sb	a4,0(a5)
      dst++;
    800018ae:	0785                	addi	a5,a5,1
    while(n > 0){
    800018b0:	fed797e3          	bne	a5,a3,8000189e <copyinstr+0x8a>
    800018b4:	b765                	j	8000185c <copyinstr+0x48>
    800018b6:	4781                	li	a5,0
    800018b8:	b761                	j	80001840 <copyinstr+0x2c>
      return -1;
    800018ba:	557d                	li	a0,-1
    800018bc:	b769                	j	80001846 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    800018be:	6b85                	lui	s7,0x1
    800018c0:	9ba6                	add	s7,s7,s1
    800018c2:	87da                	mv	a5,s6
    800018c4:	b76d                	j	8000186e <copyinstr+0x5a>
  int got_null = 0;
    800018c6:	4781                	li	a5,0
  if(got_null){
    800018c8:	37fd                	addiw	a5,a5,-1
    800018ca:	0007851b          	sext.w	a0,a5
}
    800018ce:	8082                	ret

00000000800018d0 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    800018d0:	7139                	addi	sp,sp,-64
    800018d2:	fc06                	sd	ra,56(sp)
    800018d4:	f822                	sd	s0,48(sp)
    800018d6:	f426                	sd	s1,40(sp)
    800018d8:	f04a                	sd	s2,32(sp)
    800018da:	ec4e                	sd	s3,24(sp)
    800018dc:	e852                	sd	s4,16(sp)
    800018de:	e456                	sd	s5,8(sp)
    800018e0:	e05a                	sd	s6,0(sp)
    800018e2:	0080                	addi	s0,sp,64
    800018e4:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    800018e6:	00012497          	auipc	s1,0x12
    800018ea:	01a48493          	addi	s1,s1,26 # 80013900 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    800018ee:	8b26                	mv	s6,s1
    800018f0:	04fa5937          	lui	s2,0x4fa5
    800018f4:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    800018f8:	0932                	slli	s2,s2,0xc
    800018fa:	fa590913          	addi	s2,s2,-91
    800018fe:	0932                	slli	s2,s2,0xc
    80001900:	fa590913          	addi	s2,s2,-91
    80001904:	0932                	slli	s2,s2,0xc
    80001906:	fa590913          	addi	s2,s2,-91
    8000190a:	040009b7          	lui	s3,0x4000
    8000190e:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001910:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001912:	00018a97          	auipc	s5,0x18
    80001916:	9eea8a93          	addi	s5,s5,-1554 # 80019300 <tickslock>
    char *pa = kalloc();
    8000191a:	fffff097          	auipc	ra,0xfffff
    8000191e:	246080e7          	jalr	582(ra) # 80000b60 <kalloc>
    80001922:	862a                	mv	a2,a0
    if(pa == 0)
    80001924:	c121                	beqz	a0,80001964 <proc_mapstacks+0x94>
    uint64 va = KSTACK((int) (p - proc));
    80001926:	416485b3          	sub	a1,s1,s6
    8000192a:	858d                	srai	a1,a1,0x3
    8000192c:	032585b3          	mul	a1,a1,s2
    80001930:	2585                	addiw	a1,a1,1
    80001932:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001936:	4719                	li	a4,6
    80001938:	6685                	lui	a3,0x1
    8000193a:	40b985b3          	sub	a1,s3,a1
    8000193e:	8552                	mv	a0,s4
    80001940:	00000097          	auipc	ra,0x0
    80001944:	870080e7          	jalr	-1936(ra) # 800011b0 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001948:	16848493          	addi	s1,s1,360
    8000194c:	fd5497e3          	bne	s1,s5,8000191a <proc_mapstacks+0x4a>
  }
}
    80001950:	70e2                	ld	ra,56(sp)
    80001952:	7442                	ld	s0,48(sp)
    80001954:	74a2                	ld	s1,40(sp)
    80001956:	7902                	ld	s2,32(sp)
    80001958:	69e2                	ld	s3,24(sp)
    8000195a:	6a42                	ld	s4,16(sp)
    8000195c:	6aa2                	ld	s5,8(sp)
    8000195e:	6b02                	ld	s6,0(sp)
    80001960:	6121                	addi	sp,sp,64
    80001962:	8082                	ret
      panic("kalloc");
    80001964:	00007517          	auipc	a0,0x7
    80001968:	86450513          	addi	a0,a0,-1948 # 800081c8 <etext+0x1c8>
    8000196c:	fffff097          	auipc	ra,0xfffff
    80001970:	bf4080e7          	jalr	-1036(ra) # 80000560 <panic>

0000000080001974 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001974:	7139                	addi	sp,sp,-64
    80001976:	fc06                	sd	ra,56(sp)
    80001978:	f822                	sd	s0,48(sp)
    8000197a:	f426                	sd	s1,40(sp)
    8000197c:	f04a                	sd	s2,32(sp)
    8000197e:	ec4e                	sd	s3,24(sp)
    80001980:	e852                	sd	s4,16(sp)
    80001982:	e456                	sd	s5,8(sp)
    80001984:	e05a                	sd	s6,0(sp)
    80001986:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001988:	00007597          	auipc	a1,0x7
    8000198c:	84858593          	addi	a1,a1,-1976 # 800081d0 <etext+0x1d0>
    80001990:	00012517          	auipc	a0,0x12
    80001994:	b4050513          	addi	a0,a0,-1216 # 800134d0 <pid_lock>
    80001998:	fffff097          	auipc	ra,0xfffff
    8000199c:	228080e7          	jalr	552(ra) # 80000bc0 <initlock>
  initlock(&wait_lock, "wait_lock");
    800019a0:	00007597          	auipc	a1,0x7
    800019a4:	83858593          	addi	a1,a1,-1992 # 800081d8 <etext+0x1d8>
    800019a8:	00012517          	auipc	a0,0x12
    800019ac:	b4050513          	addi	a0,a0,-1216 # 800134e8 <wait_lock>
    800019b0:	fffff097          	auipc	ra,0xfffff
    800019b4:	210080e7          	jalr	528(ra) # 80000bc0 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    800019b8:	00012497          	auipc	s1,0x12
    800019bc:	f4848493          	addi	s1,s1,-184 # 80013900 <proc>
      initlock(&p->lock, "proc");
    800019c0:	00007b17          	auipc	s6,0x7
    800019c4:	828b0b13          	addi	s6,s6,-2008 # 800081e8 <etext+0x1e8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    800019c8:	8aa6                	mv	s5,s1
    800019ca:	04fa5937          	lui	s2,0x4fa5
    800019ce:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    800019d2:	0932                	slli	s2,s2,0xc
    800019d4:	fa590913          	addi	s2,s2,-91
    800019d8:	0932                	slli	s2,s2,0xc
    800019da:	fa590913          	addi	s2,s2,-91
    800019de:	0932                	slli	s2,s2,0xc
    800019e0:	fa590913          	addi	s2,s2,-91
    800019e4:	040009b7          	lui	s3,0x4000
    800019e8:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800019ea:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800019ec:	00018a17          	auipc	s4,0x18
    800019f0:	914a0a13          	addi	s4,s4,-1772 # 80019300 <tickslock>
      initlock(&p->lock, "proc");
    800019f4:	85da                	mv	a1,s6
    800019f6:	8526                	mv	a0,s1
    800019f8:	fffff097          	auipc	ra,0xfffff
    800019fc:	1c8080e7          	jalr	456(ra) # 80000bc0 <initlock>
      p->state = UNUSED;
    80001a00:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001a04:	415487b3          	sub	a5,s1,s5
    80001a08:	878d                	srai	a5,a5,0x3
    80001a0a:	032787b3          	mul	a5,a5,s2
    80001a0e:	2785                	addiw	a5,a5,1
    80001a10:	00d7979b          	slliw	a5,a5,0xd
    80001a14:	40f987b3          	sub	a5,s3,a5
    80001a18:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a1a:	16848493          	addi	s1,s1,360
    80001a1e:	fd449be3          	bne	s1,s4,800019f4 <procinit+0x80>
  }
}
    80001a22:	70e2                	ld	ra,56(sp)
    80001a24:	7442                	ld	s0,48(sp)
    80001a26:	74a2                	ld	s1,40(sp)
    80001a28:	7902                	ld	s2,32(sp)
    80001a2a:	69e2                	ld	s3,24(sp)
    80001a2c:	6a42                	ld	s4,16(sp)
    80001a2e:	6aa2                	ld	s5,8(sp)
    80001a30:	6b02                	ld	s6,0(sp)
    80001a32:	6121                	addi	sp,sp,64
    80001a34:	8082                	ret

0000000080001a36 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001a36:	1141                	addi	sp,sp,-16
    80001a38:	e422                	sd	s0,8(sp)
    80001a3a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001a3c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001a3e:	2501                	sext.w	a0,a0
    80001a40:	6422                	ld	s0,8(sp)
    80001a42:	0141                	addi	sp,sp,16
    80001a44:	8082                	ret

0000000080001a46 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80001a46:	1141                	addi	sp,sp,-16
    80001a48:	e422                	sd	s0,8(sp)
    80001a4a:	0800                	addi	s0,sp,16
    80001a4c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001a4e:	2781                	sext.w	a5,a5
    80001a50:	079e                	slli	a5,a5,0x7
  return c;
}
    80001a52:	00012517          	auipc	a0,0x12
    80001a56:	aae50513          	addi	a0,a0,-1362 # 80013500 <cpus>
    80001a5a:	953e                	add	a0,a0,a5
    80001a5c:	6422                	ld	s0,8(sp)
    80001a5e:	0141                	addi	sp,sp,16
    80001a60:	8082                	ret

0000000080001a62 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001a62:	1101                	addi	sp,sp,-32
    80001a64:	ec06                	sd	ra,24(sp)
    80001a66:	e822                	sd	s0,16(sp)
    80001a68:	e426                	sd	s1,8(sp)
    80001a6a:	1000                	addi	s0,sp,32
  push_off();
    80001a6c:	fffff097          	auipc	ra,0xfffff
    80001a70:	198080e7          	jalr	408(ra) # 80000c04 <push_off>
    80001a74:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001a76:	2781                	sext.w	a5,a5
    80001a78:	079e                	slli	a5,a5,0x7
    80001a7a:	00012717          	auipc	a4,0x12
    80001a7e:	a5670713          	addi	a4,a4,-1450 # 800134d0 <pid_lock>
    80001a82:	97ba                	add	a5,a5,a4
    80001a84:	7b84                	ld	s1,48(a5)
  pop_off();
    80001a86:	fffff097          	auipc	ra,0xfffff
    80001a8a:	21e080e7          	jalr	542(ra) # 80000ca4 <pop_off>
  return p;
}
    80001a8e:	8526                	mv	a0,s1
    80001a90:	60e2                	ld	ra,24(sp)
    80001a92:	6442                	ld	s0,16(sp)
    80001a94:	64a2                	ld	s1,8(sp)
    80001a96:	6105                	addi	sp,sp,32
    80001a98:	8082                	ret

0000000080001a9a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001a9a:	1141                	addi	sp,sp,-16
    80001a9c:	e406                	sd	ra,8(sp)
    80001a9e:	e022                	sd	s0,0(sp)
    80001aa0:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001aa2:	00000097          	auipc	ra,0x0
    80001aa6:	fc0080e7          	jalr	-64(ra) # 80001a62 <myproc>
    80001aaa:	fffff097          	auipc	ra,0xfffff
    80001aae:	25a080e7          	jalr	602(ra) # 80000d04 <release>

  if (first) {
    80001ab2:	00009797          	auipc	a5,0x9
    80001ab6:	6de7a783          	lw	a5,1758(a5) # 8000b190 <first.1>
    80001aba:	eb89                	bnez	a5,80001acc <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001abc:	00001097          	auipc	ra,0x1
    80001ac0:	c7e080e7          	jalr	-898(ra) # 8000273a <usertrapret>
}
    80001ac4:	60a2                	ld	ra,8(sp)
    80001ac6:	6402                	ld	s0,0(sp)
    80001ac8:	0141                	addi	sp,sp,16
    80001aca:	8082                	ret
    first = 0;
    80001acc:	00009797          	auipc	a5,0x9
    80001ad0:	6c07a223          	sw	zero,1732(a5) # 8000b190 <first.1>
    fsinit(ROOTDEV);
    80001ad4:	4505                	li	a0,1
    80001ad6:	00002097          	auipc	ra,0x2
    80001ada:	a30080e7          	jalr	-1488(ra) # 80003506 <fsinit>
    80001ade:	bff9                	j	80001abc <forkret+0x22>

0000000080001ae0 <allocpid>:
{
    80001ae0:	1101                	addi	sp,sp,-32
    80001ae2:	ec06                	sd	ra,24(sp)
    80001ae4:	e822                	sd	s0,16(sp)
    80001ae6:	e426                	sd	s1,8(sp)
    80001ae8:	e04a                	sd	s2,0(sp)
    80001aea:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001aec:	00012917          	auipc	s2,0x12
    80001af0:	9e490913          	addi	s2,s2,-1564 # 800134d0 <pid_lock>
    80001af4:	854a                	mv	a0,s2
    80001af6:	fffff097          	auipc	ra,0xfffff
    80001afa:	15a080e7          	jalr	346(ra) # 80000c50 <acquire>
  pid = nextpid;
    80001afe:	00009797          	auipc	a5,0x9
    80001b02:	69678793          	addi	a5,a5,1686 # 8000b194 <nextpid>
    80001b06:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001b08:	0014871b          	addiw	a4,s1,1
    80001b0c:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001b0e:	854a                	mv	a0,s2
    80001b10:	fffff097          	auipc	ra,0xfffff
    80001b14:	1f4080e7          	jalr	500(ra) # 80000d04 <release>
}
    80001b18:	8526                	mv	a0,s1
    80001b1a:	60e2                	ld	ra,24(sp)
    80001b1c:	6442                	ld	s0,16(sp)
    80001b1e:	64a2                	ld	s1,8(sp)
    80001b20:	6902                	ld	s2,0(sp)
    80001b22:	6105                	addi	sp,sp,32
    80001b24:	8082                	ret

0000000080001b26 <proc_pagetable>:
{
    80001b26:	1101                	addi	sp,sp,-32
    80001b28:	ec06                	sd	ra,24(sp)
    80001b2a:	e822                	sd	s0,16(sp)
    80001b2c:	e426                	sd	s1,8(sp)
    80001b2e:	e04a                	sd	s2,0(sp)
    80001b30:	1000                	addi	s0,sp,32
    80001b32:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001b34:	00000097          	auipc	ra,0x0
    80001b38:	876080e7          	jalr	-1930(ra) # 800013aa <uvmcreate>
    80001b3c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001b3e:	c121                	beqz	a0,80001b7e <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001b40:	4729                	li	a4,10
    80001b42:	00005697          	auipc	a3,0x5
    80001b46:	4be68693          	addi	a3,a3,1214 # 80007000 <_trampoline>
    80001b4a:	6605                	lui	a2,0x1
    80001b4c:	040005b7          	lui	a1,0x4000
    80001b50:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b52:	05b2                	slli	a1,a1,0xc
    80001b54:	fffff097          	auipc	ra,0xfffff
    80001b58:	5bc080e7          	jalr	1468(ra) # 80001110 <mappages>
    80001b5c:	02054863          	bltz	a0,80001b8c <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001b60:	4719                	li	a4,6
    80001b62:	05893683          	ld	a3,88(s2)
    80001b66:	6605                	lui	a2,0x1
    80001b68:	020005b7          	lui	a1,0x2000
    80001b6c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001b6e:	05b6                	slli	a1,a1,0xd
    80001b70:	8526                	mv	a0,s1
    80001b72:	fffff097          	auipc	ra,0xfffff
    80001b76:	59e080e7          	jalr	1438(ra) # 80001110 <mappages>
    80001b7a:	02054163          	bltz	a0,80001b9c <proc_pagetable+0x76>
}
    80001b7e:	8526                	mv	a0,s1
    80001b80:	60e2                	ld	ra,24(sp)
    80001b82:	6442                	ld	s0,16(sp)
    80001b84:	64a2                	ld	s1,8(sp)
    80001b86:	6902                	ld	s2,0(sp)
    80001b88:	6105                	addi	sp,sp,32
    80001b8a:	8082                	ret
    uvmfree(pagetable, 0);
    80001b8c:	4581                	li	a1,0
    80001b8e:	8526                	mv	a0,s1
    80001b90:	00000097          	auipc	ra,0x0
    80001b94:	a2c080e7          	jalr	-1492(ra) # 800015bc <uvmfree>
    return 0;
    80001b98:	4481                	li	s1,0
    80001b9a:	b7d5                	j	80001b7e <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b9c:	4681                	li	a3,0
    80001b9e:	4605                	li	a2,1
    80001ba0:	040005b7          	lui	a1,0x4000
    80001ba4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001ba6:	05b2                	slli	a1,a1,0xc
    80001ba8:	8526                	mv	a0,s1
    80001baa:	fffff097          	auipc	ra,0xfffff
    80001bae:	72c080e7          	jalr	1836(ra) # 800012d6 <uvmunmap>
    uvmfree(pagetable, 0);
    80001bb2:	4581                	li	a1,0
    80001bb4:	8526                	mv	a0,s1
    80001bb6:	00000097          	auipc	ra,0x0
    80001bba:	a06080e7          	jalr	-1530(ra) # 800015bc <uvmfree>
    return 0;
    80001bbe:	4481                	li	s1,0
    80001bc0:	bf7d                	j	80001b7e <proc_pagetable+0x58>

0000000080001bc2 <proc_freepagetable>:
{
    80001bc2:	1101                	addi	sp,sp,-32
    80001bc4:	ec06                	sd	ra,24(sp)
    80001bc6:	e822                	sd	s0,16(sp)
    80001bc8:	e426                	sd	s1,8(sp)
    80001bca:	e04a                	sd	s2,0(sp)
    80001bcc:	1000                	addi	s0,sp,32
    80001bce:	84aa                	mv	s1,a0
    80001bd0:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001bd2:	4681                	li	a3,0
    80001bd4:	4605                	li	a2,1
    80001bd6:	040005b7          	lui	a1,0x4000
    80001bda:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001bdc:	05b2                	slli	a1,a1,0xc
    80001bde:	fffff097          	auipc	ra,0xfffff
    80001be2:	6f8080e7          	jalr	1784(ra) # 800012d6 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001be6:	4681                	li	a3,0
    80001be8:	4605                	li	a2,1
    80001bea:	020005b7          	lui	a1,0x2000
    80001bee:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001bf0:	05b6                	slli	a1,a1,0xd
    80001bf2:	8526                	mv	a0,s1
    80001bf4:	fffff097          	auipc	ra,0xfffff
    80001bf8:	6e2080e7          	jalr	1762(ra) # 800012d6 <uvmunmap>
  uvmfree(pagetable, sz);
    80001bfc:	85ca                	mv	a1,s2
    80001bfe:	8526                	mv	a0,s1
    80001c00:	00000097          	auipc	ra,0x0
    80001c04:	9bc080e7          	jalr	-1604(ra) # 800015bc <uvmfree>
}
    80001c08:	60e2                	ld	ra,24(sp)
    80001c0a:	6442                	ld	s0,16(sp)
    80001c0c:	64a2                	ld	s1,8(sp)
    80001c0e:	6902                	ld	s2,0(sp)
    80001c10:	6105                	addi	sp,sp,32
    80001c12:	8082                	ret

0000000080001c14 <freeproc>:
{
    80001c14:	1101                	addi	sp,sp,-32
    80001c16:	ec06                	sd	ra,24(sp)
    80001c18:	e822                	sd	s0,16(sp)
    80001c1a:	e426                	sd	s1,8(sp)
    80001c1c:	1000                	addi	s0,sp,32
    80001c1e:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001c20:	6d28                	ld	a0,88(a0)
    80001c22:	c509                	beqz	a0,80001c2c <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001c24:	fffff097          	auipc	ra,0xfffff
    80001c28:	e3e080e7          	jalr	-450(ra) # 80000a62 <kfree>
  p->trapframe = 0;
    80001c2c:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001c30:	68a8                	ld	a0,80(s1)
    80001c32:	c511                	beqz	a0,80001c3e <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001c34:	64ac                	ld	a1,72(s1)
    80001c36:	00000097          	auipc	ra,0x0
    80001c3a:	f8c080e7          	jalr	-116(ra) # 80001bc2 <proc_freepagetable>
  p->pagetable = 0;
    80001c3e:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001c42:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001c46:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001c4a:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001c4e:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001c52:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001c56:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001c5a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001c5e:	0004ac23          	sw	zero,24(s1)
}
    80001c62:	60e2                	ld	ra,24(sp)
    80001c64:	6442                	ld	s0,16(sp)
    80001c66:	64a2                	ld	s1,8(sp)
    80001c68:	6105                	addi	sp,sp,32
    80001c6a:	8082                	ret

0000000080001c6c <allocproc>:
{
    80001c6c:	1101                	addi	sp,sp,-32
    80001c6e:	ec06                	sd	ra,24(sp)
    80001c70:	e822                	sd	s0,16(sp)
    80001c72:	e426                	sd	s1,8(sp)
    80001c74:	e04a                	sd	s2,0(sp)
    80001c76:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c78:	00012497          	auipc	s1,0x12
    80001c7c:	c8848493          	addi	s1,s1,-888 # 80013900 <proc>
    80001c80:	00017917          	auipc	s2,0x17
    80001c84:	68090913          	addi	s2,s2,1664 # 80019300 <tickslock>
    acquire(&p->lock);
    80001c88:	8526                	mv	a0,s1
    80001c8a:	fffff097          	auipc	ra,0xfffff
    80001c8e:	fc6080e7          	jalr	-58(ra) # 80000c50 <acquire>
    if(p->state == UNUSED) {
    80001c92:	4c9c                	lw	a5,24(s1)
    80001c94:	cf81                	beqz	a5,80001cac <allocproc+0x40>
      release(&p->lock);
    80001c96:	8526                	mv	a0,s1
    80001c98:	fffff097          	auipc	ra,0xfffff
    80001c9c:	06c080e7          	jalr	108(ra) # 80000d04 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ca0:	16848493          	addi	s1,s1,360
    80001ca4:	ff2492e3          	bne	s1,s2,80001c88 <allocproc+0x1c>
  return 0;
    80001ca8:	4481                	li	s1,0
    80001caa:	a889                	j	80001cfc <allocproc+0x90>
  p->pid = allocpid();
    80001cac:	00000097          	auipc	ra,0x0
    80001cb0:	e34080e7          	jalr	-460(ra) # 80001ae0 <allocpid>
    80001cb4:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001cb6:	4785                	li	a5,1
    80001cb8:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001cba:	fffff097          	auipc	ra,0xfffff
    80001cbe:	ea6080e7          	jalr	-346(ra) # 80000b60 <kalloc>
    80001cc2:	892a                	mv	s2,a0
    80001cc4:	eca8                	sd	a0,88(s1)
    80001cc6:	c131                	beqz	a0,80001d0a <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001cc8:	8526                	mv	a0,s1
    80001cca:	00000097          	auipc	ra,0x0
    80001cce:	e5c080e7          	jalr	-420(ra) # 80001b26 <proc_pagetable>
    80001cd2:	892a                	mv	s2,a0
    80001cd4:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001cd6:	c531                	beqz	a0,80001d22 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001cd8:	07000613          	li	a2,112
    80001cdc:	4581                	li	a1,0
    80001cde:	06048513          	addi	a0,s1,96
    80001ce2:	fffff097          	auipc	ra,0xfffff
    80001ce6:	06a080e7          	jalr	106(ra) # 80000d4c <memset>
  p->context.ra = (uint64)forkret;
    80001cea:	00000797          	auipc	a5,0x0
    80001cee:	db078793          	addi	a5,a5,-592 # 80001a9a <forkret>
    80001cf2:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001cf4:	60bc                	ld	a5,64(s1)
    80001cf6:	6705                	lui	a4,0x1
    80001cf8:	97ba                	add	a5,a5,a4
    80001cfa:	f4bc                	sd	a5,104(s1)
}
    80001cfc:	8526                	mv	a0,s1
    80001cfe:	60e2                	ld	ra,24(sp)
    80001d00:	6442                	ld	s0,16(sp)
    80001d02:	64a2                	ld	s1,8(sp)
    80001d04:	6902                	ld	s2,0(sp)
    80001d06:	6105                	addi	sp,sp,32
    80001d08:	8082                	ret
    freeproc(p);
    80001d0a:	8526                	mv	a0,s1
    80001d0c:	00000097          	auipc	ra,0x0
    80001d10:	f08080e7          	jalr	-248(ra) # 80001c14 <freeproc>
    release(&p->lock);
    80001d14:	8526                	mv	a0,s1
    80001d16:	fffff097          	auipc	ra,0xfffff
    80001d1a:	fee080e7          	jalr	-18(ra) # 80000d04 <release>
    return 0;
    80001d1e:	84ca                	mv	s1,s2
    80001d20:	bff1                	j	80001cfc <allocproc+0x90>
    freeproc(p);
    80001d22:	8526                	mv	a0,s1
    80001d24:	00000097          	auipc	ra,0x0
    80001d28:	ef0080e7          	jalr	-272(ra) # 80001c14 <freeproc>
    release(&p->lock);
    80001d2c:	8526                	mv	a0,s1
    80001d2e:	fffff097          	auipc	ra,0xfffff
    80001d32:	fd6080e7          	jalr	-42(ra) # 80000d04 <release>
    return 0;
    80001d36:	84ca                	mv	s1,s2
    80001d38:	b7d1                	j	80001cfc <allocproc+0x90>

0000000080001d3a <userinit>:
{
    80001d3a:	1101                	addi	sp,sp,-32
    80001d3c:	ec06                	sd	ra,24(sp)
    80001d3e:	e822                	sd	s0,16(sp)
    80001d40:	e426                	sd	s1,8(sp)
    80001d42:	1000                	addi	s0,sp,32
  p = allocproc();
    80001d44:	00000097          	auipc	ra,0x0
    80001d48:	f28080e7          	jalr	-216(ra) # 80001c6c <allocproc>
    80001d4c:	84aa                	mv	s1,a0
  initproc = p;
    80001d4e:	00009797          	auipc	a5,0x9
    80001d52:	4ca7bd23          	sd	a0,1242(a5) # 8000b228 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001d56:	03400613          	li	a2,52
    80001d5a:	00009597          	auipc	a1,0x9
    80001d5e:	44658593          	addi	a1,a1,1094 # 8000b1a0 <initcode>
    80001d62:	6928                	ld	a0,80(a0)
    80001d64:	fffff097          	auipc	ra,0xfffff
    80001d68:	674080e7          	jalr	1652(ra) # 800013d8 <uvmfirst>
  p->sz = PGSIZE;
    80001d6c:	6785                	lui	a5,0x1
    80001d6e:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001d70:	6cb8                	ld	a4,88(s1)
    80001d72:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001d76:	6cb8                	ld	a4,88(s1)
    80001d78:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001d7a:	4641                	li	a2,16
    80001d7c:	00006597          	auipc	a1,0x6
    80001d80:	47458593          	addi	a1,a1,1140 # 800081f0 <etext+0x1f0>
    80001d84:	15848513          	addi	a0,s1,344
    80001d88:	fffff097          	auipc	ra,0xfffff
    80001d8c:	106080e7          	jalr	262(ra) # 80000e8e <safestrcpy>
  p->cwd = namei("/");
    80001d90:	00006517          	auipc	a0,0x6
    80001d94:	47050513          	addi	a0,a0,1136 # 80008200 <etext+0x200>
    80001d98:	00002097          	auipc	ra,0x2
    80001d9c:	1c0080e7          	jalr	448(ra) # 80003f58 <namei>
    80001da0:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001da4:	478d                	li	a5,3
    80001da6:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001da8:	8526                	mv	a0,s1
    80001daa:	fffff097          	auipc	ra,0xfffff
    80001dae:	f5a080e7          	jalr	-166(ra) # 80000d04 <release>
}
    80001db2:	60e2                	ld	ra,24(sp)
    80001db4:	6442                	ld	s0,16(sp)
    80001db6:	64a2                	ld	s1,8(sp)
    80001db8:	6105                	addi	sp,sp,32
    80001dba:	8082                	ret

0000000080001dbc <growproc>:
{
    80001dbc:	1101                	addi	sp,sp,-32
    80001dbe:	ec06                	sd	ra,24(sp)
    80001dc0:	e822                	sd	s0,16(sp)
    80001dc2:	e426                	sd	s1,8(sp)
    80001dc4:	e04a                	sd	s2,0(sp)
    80001dc6:	1000                	addi	s0,sp,32
    80001dc8:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001dca:	00000097          	auipc	ra,0x0
    80001dce:	c98080e7          	jalr	-872(ra) # 80001a62 <myproc>
    80001dd2:	84aa                	mv	s1,a0
  sz = p->sz;
    80001dd4:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001dd6:	01204c63          	bgtz	s2,80001dee <growproc+0x32>
  } else if(n < 0){
    80001dda:	02094663          	bltz	s2,80001e06 <growproc+0x4a>
  p->sz = sz;
    80001dde:	e4ac                	sd	a1,72(s1)
  return 0;
    80001de0:	4501                	li	a0,0
}
    80001de2:	60e2                	ld	ra,24(sp)
    80001de4:	6442                	ld	s0,16(sp)
    80001de6:	64a2                	ld	s1,8(sp)
    80001de8:	6902                	ld	s2,0(sp)
    80001dea:	6105                	addi	sp,sp,32
    80001dec:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001dee:	4691                	li	a3,4
    80001df0:	00b90633          	add	a2,s2,a1
    80001df4:	6928                	ld	a0,80(a0)
    80001df6:	fffff097          	auipc	ra,0xfffff
    80001dfa:	69c080e7          	jalr	1692(ra) # 80001492 <uvmalloc>
    80001dfe:	85aa                	mv	a1,a0
    80001e00:	fd79                	bnez	a0,80001dde <growproc+0x22>
      return -1;
    80001e02:	557d                	li	a0,-1
    80001e04:	bff9                	j	80001de2 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001e06:	00b90633          	add	a2,s2,a1
    80001e0a:	6928                	ld	a0,80(a0)
    80001e0c:	fffff097          	auipc	ra,0xfffff
    80001e10:	63e080e7          	jalr	1598(ra) # 8000144a <uvmdealloc>
    80001e14:	85aa                	mv	a1,a0
    80001e16:	b7e1                	j	80001dde <growproc+0x22>

0000000080001e18 <fork>:
{
    80001e18:	7139                	addi	sp,sp,-64
    80001e1a:	fc06                	sd	ra,56(sp)
    80001e1c:	f822                	sd	s0,48(sp)
    80001e1e:	f04a                	sd	s2,32(sp)
    80001e20:	e456                	sd	s5,8(sp)
    80001e22:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001e24:	00000097          	auipc	ra,0x0
    80001e28:	c3e080e7          	jalr	-962(ra) # 80001a62 <myproc>
    80001e2c:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001e2e:	00000097          	auipc	ra,0x0
    80001e32:	e3e080e7          	jalr	-450(ra) # 80001c6c <allocproc>
    80001e36:	12050063          	beqz	a0,80001f56 <fork+0x13e>
    80001e3a:	e852                	sd	s4,16(sp)
    80001e3c:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001e3e:	048ab603          	ld	a2,72(s5)
    80001e42:	692c                	ld	a1,80(a0)
    80001e44:	050ab503          	ld	a0,80(s5)
    80001e48:	fffff097          	auipc	ra,0xfffff
    80001e4c:	7ae080e7          	jalr	1966(ra) # 800015f6 <uvmcopy>
    80001e50:	04054a63          	bltz	a0,80001ea4 <fork+0x8c>
    80001e54:	f426                	sd	s1,40(sp)
    80001e56:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001e58:	048ab783          	ld	a5,72(s5)
    80001e5c:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001e60:	058ab683          	ld	a3,88(s5)
    80001e64:	87b6                	mv	a5,a3
    80001e66:	058a3703          	ld	a4,88(s4)
    80001e6a:	12068693          	addi	a3,a3,288
    80001e6e:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001e72:	6788                	ld	a0,8(a5)
    80001e74:	6b8c                	ld	a1,16(a5)
    80001e76:	6f90                	ld	a2,24(a5)
    80001e78:	01073023          	sd	a6,0(a4)
    80001e7c:	e708                	sd	a0,8(a4)
    80001e7e:	eb0c                	sd	a1,16(a4)
    80001e80:	ef10                	sd	a2,24(a4)
    80001e82:	02078793          	addi	a5,a5,32
    80001e86:	02070713          	addi	a4,a4,32
    80001e8a:	fed792e3          	bne	a5,a3,80001e6e <fork+0x56>
  np->trapframe->a0 = 0;
    80001e8e:	058a3783          	ld	a5,88(s4)
    80001e92:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001e96:	0d0a8493          	addi	s1,s5,208
    80001e9a:	0d0a0913          	addi	s2,s4,208
    80001e9e:	150a8993          	addi	s3,s5,336
    80001ea2:	a015                	j	80001ec6 <fork+0xae>
    freeproc(np);
    80001ea4:	8552                	mv	a0,s4
    80001ea6:	00000097          	auipc	ra,0x0
    80001eaa:	d6e080e7          	jalr	-658(ra) # 80001c14 <freeproc>
    release(&np->lock);
    80001eae:	8552                	mv	a0,s4
    80001eb0:	fffff097          	auipc	ra,0xfffff
    80001eb4:	e54080e7          	jalr	-428(ra) # 80000d04 <release>
    return -1;
    80001eb8:	597d                	li	s2,-1
    80001eba:	6a42                	ld	s4,16(sp)
    80001ebc:	a071                	j	80001f48 <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    80001ebe:	04a1                	addi	s1,s1,8
    80001ec0:	0921                	addi	s2,s2,8
    80001ec2:	01348b63          	beq	s1,s3,80001ed8 <fork+0xc0>
    if(p->ofile[i])
    80001ec6:	6088                	ld	a0,0(s1)
    80001ec8:	d97d                	beqz	a0,80001ebe <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80001eca:	00002097          	auipc	ra,0x2
    80001ece:	706080e7          	jalr	1798(ra) # 800045d0 <filedup>
    80001ed2:	00a93023          	sd	a0,0(s2)
    80001ed6:	b7e5                	j	80001ebe <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001ed8:	150ab503          	ld	a0,336(s5)
    80001edc:	00002097          	auipc	ra,0x2
    80001ee0:	870080e7          	jalr	-1936(ra) # 8000374c <idup>
    80001ee4:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001ee8:	4641                	li	a2,16
    80001eea:	158a8593          	addi	a1,s5,344
    80001eee:	158a0513          	addi	a0,s4,344
    80001ef2:	fffff097          	auipc	ra,0xfffff
    80001ef6:	f9c080e7          	jalr	-100(ra) # 80000e8e <safestrcpy>
  pid = np->pid;
    80001efa:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001efe:	8552                	mv	a0,s4
    80001f00:	fffff097          	auipc	ra,0xfffff
    80001f04:	e04080e7          	jalr	-508(ra) # 80000d04 <release>
  acquire(&wait_lock);
    80001f08:	00011497          	auipc	s1,0x11
    80001f0c:	5e048493          	addi	s1,s1,1504 # 800134e8 <wait_lock>
    80001f10:	8526                	mv	a0,s1
    80001f12:	fffff097          	auipc	ra,0xfffff
    80001f16:	d3e080e7          	jalr	-706(ra) # 80000c50 <acquire>
  np->parent = p;
    80001f1a:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001f1e:	8526                	mv	a0,s1
    80001f20:	fffff097          	auipc	ra,0xfffff
    80001f24:	de4080e7          	jalr	-540(ra) # 80000d04 <release>
  acquire(&np->lock);
    80001f28:	8552                	mv	a0,s4
    80001f2a:	fffff097          	auipc	ra,0xfffff
    80001f2e:	d26080e7          	jalr	-730(ra) # 80000c50 <acquire>
  np->state = RUNNABLE;
    80001f32:	478d                	li	a5,3
    80001f34:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001f38:	8552                	mv	a0,s4
    80001f3a:	fffff097          	auipc	ra,0xfffff
    80001f3e:	dca080e7          	jalr	-566(ra) # 80000d04 <release>
  return pid;
    80001f42:	74a2                	ld	s1,40(sp)
    80001f44:	69e2                	ld	s3,24(sp)
    80001f46:	6a42                	ld	s4,16(sp)
}
    80001f48:	854a                	mv	a0,s2
    80001f4a:	70e2                	ld	ra,56(sp)
    80001f4c:	7442                	ld	s0,48(sp)
    80001f4e:	7902                	ld	s2,32(sp)
    80001f50:	6aa2                	ld	s5,8(sp)
    80001f52:	6121                	addi	sp,sp,64
    80001f54:	8082                	ret
    return -1;
    80001f56:	597d                	li	s2,-1
    80001f58:	bfc5                	j	80001f48 <fork+0x130>

0000000080001f5a <scheduler>:
{
    80001f5a:	715d                	addi	sp,sp,-80
    80001f5c:	e486                	sd	ra,72(sp)
    80001f5e:	e0a2                	sd	s0,64(sp)
    80001f60:	fc26                	sd	s1,56(sp)
    80001f62:	f84a                	sd	s2,48(sp)
    80001f64:	f44e                	sd	s3,40(sp)
    80001f66:	f052                	sd	s4,32(sp)
    80001f68:	ec56                	sd	s5,24(sp)
    80001f6a:	e85a                	sd	s6,16(sp)
    80001f6c:	e45e                	sd	s7,8(sp)
    80001f6e:	e062                	sd	s8,0(sp)
    80001f70:	0880                	addi	s0,sp,80
    80001f72:	8792                	mv	a5,tp
  int id = r_tp();
    80001f74:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001f76:	00779b13          	slli	s6,a5,0x7
    80001f7a:	00011717          	auipc	a4,0x11
    80001f7e:	55670713          	addi	a4,a4,1366 # 800134d0 <pid_lock>
    80001f82:	975a                	add	a4,a4,s6
    80001f84:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001f88:	00011717          	auipc	a4,0x11
    80001f8c:	58070713          	addi	a4,a4,1408 # 80013508 <cpus+0x8>
    80001f90:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001f92:	4c11                	li	s8,4
        c->proc = p;
    80001f94:	079e                	slli	a5,a5,0x7
    80001f96:	00011a17          	auipc	s4,0x11
    80001f9a:	53aa0a13          	addi	s4,s4,1338 # 800134d0 <pid_lock>
    80001f9e:	9a3e                	add	s4,s4,a5
        found = 1;
    80001fa0:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001fa2:	00017997          	auipc	s3,0x17
    80001fa6:	35e98993          	addi	s3,s3,862 # 80019300 <tickslock>
    80001faa:	a899                	j	80002000 <scheduler+0xa6>
      release(&p->lock);
    80001fac:	8526                	mv	a0,s1
    80001fae:	fffff097          	auipc	ra,0xfffff
    80001fb2:	d56080e7          	jalr	-682(ra) # 80000d04 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001fb6:	16848493          	addi	s1,s1,360
    80001fba:	03348963          	beq	s1,s3,80001fec <scheduler+0x92>
      acquire(&p->lock);
    80001fbe:	8526                	mv	a0,s1
    80001fc0:	fffff097          	auipc	ra,0xfffff
    80001fc4:	c90080e7          	jalr	-880(ra) # 80000c50 <acquire>
      if(p->state == RUNNABLE) {
    80001fc8:	4c9c                	lw	a5,24(s1)
    80001fca:	ff2791e3          	bne	a5,s2,80001fac <scheduler+0x52>
        p->state = RUNNING;
    80001fce:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001fd2:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001fd6:	06048593          	addi	a1,s1,96
    80001fda:	855a                	mv	a0,s6
    80001fdc:	00000097          	auipc	ra,0x0
    80001fe0:	6b4080e7          	jalr	1716(ra) # 80002690 <swtch>
        c->proc = 0;
    80001fe4:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001fe8:	8ade                	mv	s5,s7
    80001fea:	b7c9                	j	80001fac <scheduler+0x52>
    if (found == 0){
    80001fec:	000a9a63          	bnez	s5,80002000 <scheduler+0xa6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ff0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ff4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ff8:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001ffc:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002000:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002004:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002008:	10079073          	csrw	sstatus,a5
    int found = 0;
    8000200c:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    8000200e:	00012497          	auipc	s1,0x12
    80002012:	8f248493          	addi	s1,s1,-1806 # 80013900 <proc>
      if(p->state == RUNNABLE) {
    80002016:	490d                	li	s2,3
    80002018:	b75d                	j	80001fbe <scheduler+0x64>

000000008000201a <sched>:
{
    8000201a:	7179                	addi	sp,sp,-48
    8000201c:	f406                	sd	ra,40(sp)
    8000201e:	f022                	sd	s0,32(sp)
    80002020:	ec26                	sd	s1,24(sp)
    80002022:	e84a                	sd	s2,16(sp)
    80002024:	e44e                	sd	s3,8(sp)
    80002026:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002028:	00000097          	auipc	ra,0x0
    8000202c:	a3a080e7          	jalr	-1478(ra) # 80001a62 <myproc>
    80002030:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002032:	fffff097          	auipc	ra,0xfffff
    80002036:	ba4080e7          	jalr	-1116(ra) # 80000bd6 <holding>
    8000203a:	c93d                	beqz	a0,800020b0 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000203c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000203e:	2781                	sext.w	a5,a5
    80002040:	079e                	slli	a5,a5,0x7
    80002042:	00011717          	auipc	a4,0x11
    80002046:	48e70713          	addi	a4,a4,1166 # 800134d0 <pid_lock>
    8000204a:	97ba                	add	a5,a5,a4
    8000204c:	0a87a703          	lw	a4,168(a5)
    80002050:	4785                	li	a5,1
    80002052:	06f71763          	bne	a4,a5,800020c0 <sched+0xa6>
  if(p->state == RUNNING)
    80002056:	4c98                	lw	a4,24(s1)
    80002058:	4791                	li	a5,4
    8000205a:	06f70b63          	beq	a4,a5,800020d0 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000205e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002062:	8b89                	andi	a5,a5,2
  if(intr_get())
    80002064:	efb5                	bnez	a5,800020e0 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002066:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002068:	00011917          	auipc	s2,0x11
    8000206c:	46890913          	addi	s2,s2,1128 # 800134d0 <pid_lock>
    80002070:	2781                	sext.w	a5,a5
    80002072:	079e                	slli	a5,a5,0x7
    80002074:	97ca                	add	a5,a5,s2
    80002076:	0ac7a983          	lw	s3,172(a5)
    8000207a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000207c:	2781                	sext.w	a5,a5
    8000207e:	079e                	slli	a5,a5,0x7
    80002080:	00011597          	auipc	a1,0x11
    80002084:	48858593          	addi	a1,a1,1160 # 80013508 <cpus+0x8>
    80002088:	95be                	add	a1,a1,a5
    8000208a:	06048513          	addi	a0,s1,96
    8000208e:	00000097          	auipc	ra,0x0
    80002092:	602080e7          	jalr	1538(ra) # 80002690 <swtch>
    80002096:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002098:	2781                	sext.w	a5,a5
    8000209a:	079e                	slli	a5,a5,0x7
    8000209c:	993e                	add	s2,s2,a5
    8000209e:	0b392623          	sw	s3,172(s2)
}
    800020a2:	70a2                	ld	ra,40(sp)
    800020a4:	7402                	ld	s0,32(sp)
    800020a6:	64e2                	ld	s1,24(sp)
    800020a8:	6942                	ld	s2,16(sp)
    800020aa:	69a2                	ld	s3,8(sp)
    800020ac:	6145                	addi	sp,sp,48
    800020ae:	8082                	ret
    panic("sched p->lock");
    800020b0:	00006517          	auipc	a0,0x6
    800020b4:	15850513          	addi	a0,a0,344 # 80008208 <etext+0x208>
    800020b8:	ffffe097          	auipc	ra,0xffffe
    800020bc:	4a8080e7          	jalr	1192(ra) # 80000560 <panic>
    panic("sched locks");
    800020c0:	00006517          	auipc	a0,0x6
    800020c4:	15850513          	addi	a0,a0,344 # 80008218 <etext+0x218>
    800020c8:	ffffe097          	auipc	ra,0xffffe
    800020cc:	498080e7          	jalr	1176(ra) # 80000560 <panic>
    panic("sched running");
    800020d0:	00006517          	auipc	a0,0x6
    800020d4:	15850513          	addi	a0,a0,344 # 80008228 <etext+0x228>
    800020d8:	ffffe097          	auipc	ra,0xffffe
    800020dc:	488080e7          	jalr	1160(ra) # 80000560 <panic>
    panic("sched interruptible");
    800020e0:	00006517          	auipc	a0,0x6
    800020e4:	15850513          	addi	a0,a0,344 # 80008238 <etext+0x238>
    800020e8:	ffffe097          	auipc	ra,0xffffe
    800020ec:	478080e7          	jalr	1144(ra) # 80000560 <panic>

00000000800020f0 <yield>:
{
    800020f0:	1101                	addi	sp,sp,-32
    800020f2:	ec06                	sd	ra,24(sp)
    800020f4:	e822                	sd	s0,16(sp)
    800020f6:	e426                	sd	s1,8(sp)
    800020f8:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800020fa:	00000097          	auipc	ra,0x0
    800020fe:	968080e7          	jalr	-1688(ra) # 80001a62 <myproc>
    80002102:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002104:	fffff097          	auipc	ra,0xfffff
    80002108:	b4c080e7          	jalr	-1204(ra) # 80000c50 <acquire>
  p->state = RUNNABLE;
    8000210c:	478d                	li	a5,3
    8000210e:	cc9c                	sw	a5,24(s1)
  sched();
    80002110:	00000097          	auipc	ra,0x0
    80002114:	f0a080e7          	jalr	-246(ra) # 8000201a <sched>
  release(&p->lock);
    80002118:	8526                	mv	a0,s1
    8000211a:	fffff097          	auipc	ra,0xfffff
    8000211e:	bea080e7          	jalr	-1046(ra) # 80000d04 <release>
}
    80002122:	60e2                	ld	ra,24(sp)
    80002124:	6442                	ld	s0,16(sp)
    80002126:	64a2                	ld	s1,8(sp)
    80002128:	6105                	addi	sp,sp,32
    8000212a:	8082                	ret

000000008000212c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000212c:	7179                	addi	sp,sp,-48
    8000212e:	f406                	sd	ra,40(sp)
    80002130:	f022                	sd	s0,32(sp)
    80002132:	ec26                	sd	s1,24(sp)
    80002134:	e84a                	sd	s2,16(sp)
    80002136:	e44e                	sd	s3,8(sp)
    80002138:	1800                	addi	s0,sp,48
    8000213a:	89aa                	mv	s3,a0
    8000213c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000213e:	00000097          	auipc	ra,0x0
    80002142:	924080e7          	jalr	-1756(ra) # 80001a62 <myproc>
    80002146:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80002148:	fffff097          	auipc	ra,0xfffff
    8000214c:	b08080e7          	jalr	-1272(ra) # 80000c50 <acquire>
  release(lk);
    80002150:	854a                	mv	a0,s2
    80002152:	fffff097          	auipc	ra,0xfffff
    80002156:	bb2080e7          	jalr	-1102(ra) # 80000d04 <release>

  // Go to sleep.
  p->chan = chan;
    8000215a:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000215e:	4789                	li	a5,2
    80002160:	cc9c                	sw	a5,24(s1)

  sched();
    80002162:	00000097          	auipc	ra,0x0
    80002166:	eb8080e7          	jalr	-328(ra) # 8000201a <sched>

  // Tidy up.
  p->chan = 0;
    8000216a:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000216e:	8526                	mv	a0,s1
    80002170:	fffff097          	auipc	ra,0xfffff
    80002174:	b94080e7          	jalr	-1132(ra) # 80000d04 <release>
  acquire(lk);
    80002178:	854a                	mv	a0,s2
    8000217a:	fffff097          	auipc	ra,0xfffff
    8000217e:	ad6080e7          	jalr	-1322(ra) # 80000c50 <acquire>
}
    80002182:	70a2                	ld	ra,40(sp)
    80002184:	7402                	ld	s0,32(sp)
    80002186:	64e2                	ld	s1,24(sp)
    80002188:	6942                	ld	s2,16(sp)
    8000218a:	69a2                	ld	s3,8(sp)
    8000218c:	6145                	addi	sp,sp,48
    8000218e:	8082                	ret

0000000080002190 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80002190:	7139                	addi	sp,sp,-64
    80002192:	fc06                	sd	ra,56(sp)
    80002194:	f822                	sd	s0,48(sp)
    80002196:	f426                	sd	s1,40(sp)
    80002198:	f04a                	sd	s2,32(sp)
    8000219a:	ec4e                	sd	s3,24(sp)
    8000219c:	e852                	sd	s4,16(sp)
    8000219e:	e456                	sd	s5,8(sp)
    800021a0:	0080                	addi	s0,sp,64
    800021a2:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800021a4:	00011497          	auipc	s1,0x11
    800021a8:	75c48493          	addi	s1,s1,1884 # 80013900 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800021ac:	4989                	li	s3,2
        p->state = RUNNABLE;
    800021ae:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800021b0:	00017917          	auipc	s2,0x17
    800021b4:	15090913          	addi	s2,s2,336 # 80019300 <tickslock>
    800021b8:	a811                	j	800021cc <wakeup+0x3c>
      }
      release(&p->lock);
    800021ba:	8526                	mv	a0,s1
    800021bc:	fffff097          	auipc	ra,0xfffff
    800021c0:	b48080e7          	jalr	-1208(ra) # 80000d04 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800021c4:	16848493          	addi	s1,s1,360
    800021c8:	03248663          	beq	s1,s2,800021f4 <wakeup+0x64>
    if(p != myproc()){
    800021cc:	00000097          	auipc	ra,0x0
    800021d0:	896080e7          	jalr	-1898(ra) # 80001a62 <myproc>
    800021d4:	fea488e3          	beq	s1,a0,800021c4 <wakeup+0x34>
      acquire(&p->lock);
    800021d8:	8526                	mv	a0,s1
    800021da:	fffff097          	auipc	ra,0xfffff
    800021de:	a76080e7          	jalr	-1418(ra) # 80000c50 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800021e2:	4c9c                	lw	a5,24(s1)
    800021e4:	fd379be3          	bne	a5,s3,800021ba <wakeup+0x2a>
    800021e8:	709c                	ld	a5,32(s1)
    800021ea:	fd4798e3          	bne	a5,s4,800021ba <wakeup+0x2a>
        p->state = RUNNABLE;
    800021ee:	0154ac23          	sw	s5,24(s1)
    800021f2:	b7e1                	j	800021ba <wakeup+0x2a>
    }
  }
}
    800021f4:	70e2                	ld	ra,56(sp)
    800021f6:	7442                	ld	s0,48(sp)
    800021f8:	74a2                	ld	s1,40(sp)
    800021fa:	7902                	ld	s2,32(sp)
    800021fc:	69e2                	ld	s3,24(sp)
    800021fe:	6a42                	ld	s4,16(sp)
    80002200:	6aa2                	ld	s5,8(sp)
    80002202:	6121                	addi	sp,sp,64
    80002204:	8082                	ret

0000000080002206 <reparent>:
{
    80002206:	7179                	addi	sp,sp,-48
    80002208:	f406                	sd	ra,40(sp)
    8000220a:	f022                	sd	s0,32(sp)
    8000220c:	ec26                	sd	s1,24(sp)
    8000220e:	e84a                	sd	s2,16(sp)
    80002210:	e44e                	sd	s3,8(sp)
    80002212:	e052                	sd	s4,0(sp)
    80002214:	1800                	addi	s0,sp,48
    80002216:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002218:	00011497          	auipc	s1,0x11
    8000221c:	6e848493          	addi	s1,s1,1768 # 80013900 <proc>
      pp->parent = initproc;
    80002220:	00009a17          	auipc	s4,0x9
    80002224:	008a0a13          	addi	s4,s4,8 # 8000b228 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002228:	00017997          	auipc	s3,0x17
    8000222c:	0d898993          	addi	s3,s3,216 # 80019300 <tickslock>
    80002230:	a029                	j	8000223a <reparent+0x34>
    80002232:	16848493          	addi	s1,s1,360
    80002236:	01348d63          	beq	s1,s3,80002250 <reparent+0x4a>
    if(pp->parent == p){
    8000223a:	7c9c                	ld	a5,56(s1)
    8000223c:	ff279be3          	bne	a5,s2,80002232 <reparent+0x2c>
      pp->parent = initproc;
    80002240:	000a3503          	ld	a0,0(s4)
    80002244:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80002246:	00000097          	auipc	ra,0x0
    8000224a:	f4a080e7          	jalr	-182(ra) # 80002190 <wakeup>
    8000224e:	b7d5                	j	80002232 <reparent+0x2c>
}
    80002250:	70a2                	ld	ra,40(sp)
    80002252:	7402                	ld	s0,32(sp)
    80002254:	64e2                	ld	s1,24(sp)
    80002256:	6942                	ld	s2,16(sp)
    80002258:	69a2                	ld	s3,8(sp)
    8000225a:	6a02                	ld	s4,0(sp)
    8000225c:	6145                	addi	sp,sp,48
    8000225e:	8082                	ret

0000000080002260 <exit>:
{
    80002260:	7179                	addi	sp,sp,-48
    80002262:	f406                	sd	ra,40(sp)
    80002264:	f022                	sd	s0,32(sp)
    80002266:	ec26                	sd	s1,24(sp)
    80002268:	e84a                	sd	s2,16(sp)
    8000226a:	e44e                	sd	s3,8(sp)
    8000226c:	e052                	sd	s4,0(sp)
    8000226e:	1800                	addi	s0,sp,48
    80002270:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002272:	fffff097          	auipc	ra,0xfffff
    80002276:	7f0080e7          	jalr	2032(ra) # 80001a62 <myproc>
    8000227a:	89aa                	mv	s3,a0
  if(p == initproc)
    8000227c:	00009797          	auipc	a5,0x9
    80002280:	fac7b783          	ld	a5,-84(a5) # 8000b228 <initproc>
    80002284:	0d050493          	addi	s1,a0,208
    80002288:	15050913          	addi	s2,a0,336
    8000228c:	02a79363          	bne	a5,a0,800022b2 <exit+0x52>
    panic("init exiting");
    80002290:	00006517          	auipc	a0,0x6
    80002294:	fc050513          	addi	a0,a0,-64 # 80008250 <etext+0x250>
    80002298:	ffffe097          	auipc	ra,0xffffe
    8000229c:	2c8080e7          	jalr	712(ra) # 80000560 <panic>
      fileclose(f);
    800022a0:	00002097          	auipc	ra,0x2
    800022a4:	382080e7          	jalr	898(ra) # 80004622 <fileclose>
      p->ofile[fd] = 0;
    800022a8:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800022ac:	04a1                	addi	s1,s1,8
    800022ae:	01248563          	beq	s1,s2,800022b8 <exit+0x58>
    if(p->ofile[fd]){
    800022b2:	6088                	ld	a0,0(s1)
    800022b4:	f575                	bnez	a0,800022a0 <exit+0x40>
    800022b6:	bfdd                	j	800022ac <exit+0x4c>
  begin_op();
    800022b8:	00002097          	auipc	ra,0x2
    800022bc:	ea0080e7          	jalr	-352(ra) # 80004158 <begin_op>
  iput(p->cwd);
    800022c0:	1509b503          	ld	a0,336(s3)
    800022c4:	00001097          	auipc	ra,0x1
    800022c8:	684080e7          	jalr	1668(ra) # 80003948 <iput>
  end_op();
    800022cc:	00002097          	auipc	ra,0x2
    800022d0:	f06080e7          	jalr	-250(ra) # 800041d2 <end_op>
  p->cwd = 0;
    800022d4:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800022d8:	00011497          	auipc	s1,0x11
    800022dc:	21048493          	addi	s1,s1,528 # 800134e8 <wait_lock>
    800022e0:	8526                	mv	a0,s1
    800022e2:	fffff097          	auipc	ra,0xfffff
    800022e6:	96e080e7          	jalr	-1682(ra) # 80000c50 <acquire>
  reparent(p);
    800022ea:	854e                	mv	a0,s3
    800022ec:	00000097          	auipc	ra,0x0
    800022f0:	f1a080e7          	jalr	-230(ra) # 80002206 <reparent>
  wakeup(p->parent);
    800022f4:	0389b503          	ld	a0,56(s3)
    800022f8:	00000097          	auipc	ra,0x0
    800022fc:	e98080e7          	jalr	-360(ra) # 80002190 <wakeup>
  acquire(&p->lock);
    80002300:	854e                	mv	a0,s3
    80002302:	fffff097          	auipc	ra,0xfffff
    80002306:	94e080e7          	jalr	-1714(ra) # 80000c50 <acquire>
  p->xstate = status;
    8000230a:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000230e:	4795                	li	a5,5
    80002310:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80002314:	8526                	mv	a0,s1
    80002316:	fffff097          	auipc	ra,0xfffff
    8000231a:	9ee080e7          	jalr	-1554(ra) # 80000d04 <release>
  sched();
    8000231e:	00000097          	auipc	ra,0x0
    80002322:	cfc080e7          	jalr	-772(ra) # 8000201a <sched>
  panic("zombie exit");
    80002326:	00006517          	auipc	a0,0x6
    8000232a:	f3a50513          	addi	a0,a0,-198 # 80008260 <etext+0x260>
    8000232e:	ffffe097          	auipc	ra,0xffffe
    80002332:	232080e7          	jalr	562(ra) # 80000560 <panic>

0000000080002336 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002336:	7179                	addi	sp,sp,-48
    80002338:	f406                	sd	ra,40(sp)
    8000233a:	f022                	sd	s0,32(sp)
    8000233c:	ec26                	sd	s1,24(sp)
    8000233e:	e84a                	sd	s2,16(sp)
    80002340:	e44e                	sd	s3,8(sp)
    80002342:	1800                	addi	s0,sp,48
    80002344:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002346:	00011497          	auipc	s1,0x11
    8000234a:	5ba48493          	addi	s1,s1,1466 # 80013900 <proc>
    8000234e:	00017997          	auipc	s3,0x17
    80002352:	fb298993          	addi	s3,s3,-78 # 80019300 <tickslock>
    acquire(&p->lock);
    80002356:	8526                	mv	a0,s1
    80002358:	fffff097          	auipc	ra,0xfffff
    8000235c:	8f8080e7          	jalr	-1800(ra) # 80000c50 <acquire>
    if(p->pid == pid){
    80002360:	589c                	lw	a5,48(s1)
    80002362:	01278d63          	beq	a5,s2,8000237c <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002366:	8526                	mv	a0,s1
    80002368:	fffff097          	auipc	ra,0xfffff
    8000236c:	99c080e7          	jalr	-1636(ra) # 80000d04 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002370:	16848493          	addi	s1,s1,360
    80002374:	ff3491e3          	bne	s1,s3,80002356 <kill+0x20>
  }
  return -1;
    80002378:	557d                	li	a0,-1
    8000237a:	a829                	j	80002394 <kill+0x5e>
      p->killed = 1;
    8000237c:	4785                	li	a5,1
    8000237e:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002380:	4c98                	lw	a4,24(s1)
    80002382:	4789                	li	a5,2
    80002384:	00f70f63          	beq	a4,a5,800023a2 <kill+0x6c>
      release(&p->lock);
    80002388:	8526                	mv	a0,s1
    8000238a:	fffff097          	auipc	ra,0xfffff
    8000238e:	97a080e7          	jalr	-1670(ra) # 80000d04 <release>
      return 0;
    80002392:	4501                	li	a0,0
}
    80002394:	70a2                	ld	ra,40(sp)
    80002396:	7402                	ld	s0,32(sp)
    80002398:	64e2                	ld	s1,24(sp)
    8000239a:	6942                	ld	s2,16(sp)
    8000239c:	69a2                	ld	s3,8(sp)
    8000239e:	6145                	addi	sp,sp,48
    800023a0:	8082                	ret
        p->state = RUNNABLE;
    800023a2:	478d                	li	a5,3
    800023a4:	cc9c                	sw	a5,24(s1)
    800023a6:	b7cd                	j	80002388 <kill+0x52>

00000000800023a8 <setkilled>:

void
setkilled(struct proc *p)
{
    800023a8:	1101                	addi	sp,sp,-32
    800023aa:	ec06                	sd	ra,24(sp)
    800023ac:	e822                	sd	s0,16(sp)
    800023ae:	e426                	sd	s1,8(sp)
    800023b0:	1000                	addi	s0,sp,32
    800023b2:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800023b4:	fffff097          	auipc	ra,0xfffff
    800023b8:	89c080e7          	jalr	-1892(ra) # 80000c50 <acquire>
  p->killed = 1;
    800023bc:	4785                	li	a5,1
    800023be:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800023c0:	8526                	mv	a0,s1
    800023c2:	fffff097          	auipc	ra,0xfffff
    800023c6:	942080e7          	jalr	-1726(ra) # 80000d04 <release>
}
    800023ca:	60e2                	ld	ra,24(sp)
    800023cc:	6442                	ld	s0,16(sp)
    800023ce:	64a2                	ld	s1,8(sp)
    800023d0:	6105                	addi	sp,sp,32
    800023d2:	8082                	ret

00000000800023d4 <killed>:

int
killed(struct proc *p)
{
    800023d4:	1101                	addi	sp,sp,-32
    800023d6:	ec06                	sd	ra,24(sp)
    800023d8:	e822                	sd	s0,16(sp)
    800023da:	e426                	sd	s1,8(sp)
    800023dc:	e04a                	sd	s2,0(sp)
    800023de:	1000                	addi	s0,sp,32
    800023e0:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800023e2:	fffff097          	auipc	ra,0xfffff
    800023e6:	86e080e7          	jalr	-1938(ra) # 80000c50 <acquire>
  k = p->killed;
    800023ea:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800023ee:	8526                	mv	a0,s1
    800023f0:	fffff097          	auipc	ra,0xfffff
    800023f4:	914080e7          	jalr	-1772(ra) # 80000d04 <release>
  return k;
}
    800023f8:	854a                	mv	a0,s2
    800023fa:	60e2                	ld	ra,24(sp)
    800023fc:	6442                	ld	s0,16(sp)
    800023fe:	64a2                	ld	s1,8(sp)
    80002400:	6902                	ld	s2,0(sp)
    80002402:	6105                	addi	sp,sp,32
    80002404:	8082                	ret

0000000080002406 <wait>:
{
    80002406:	715d                	addi	sp,sp,-80
    80002408:	e486                	sd	ra,72(sp)
    8000240a:	e0a2                	sd	s0,64(sp)
    8000240c:	fc26                	sd	s1,56(sp)
    8000240e:	f84a                	sd	s2,48(sp)
    80002410:	f44e                	sd	s3,40(sp)
    80002412:	f052                	sd	s4,32(sp)
    80002414:	ec56                	sd	s5,24(sp)
    80002416:	e85a                	sd	s6,16(sp)
    80002418:	e45e                	sd	s7,8(sp)
    8000241a:	e062                	sd	s8,0(sp)
    8000241c:	0880                	addi	s0,sp,80
    8000241e:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002420:	fffff097          	auipc	ra,0xfffff
    80002424:	642080e7          	jalr	1602(ra) # 80001a62 <myproc>
    80002428:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000242a:	00011517          	auipc	a0,0x11
    8000242e:	0be50513          	addi	a0,a0,190 # 800134e8 <wait_lock>
    80002432:	fffff097          	auipc	ra,0xfffff
    80002436:	81e080e7          	jalr	-2018(ra) # 80000c50 <acquire>
    havekids = 0;
    8000243a:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    8000243c:	4a15                	li	s4,5
        havekids = 1;
    8000243e:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002440:	00017997          	auipc	s3,0x17
    80002444:	ec098993          	addi	s3,s3,-320 # 80019300 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002448:	00011c17          	auipc	s8,0x11
    8000244c:	0a0c0c13          	addi	s8,s8,160 # 800134e8 <wait_lock>
    80002450:	a0d1                	j	80002514 <wait+0x10e>
          pid = pp->pid;
    80002452:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002456:	000b0e63          	beqz	s6,80002472 <wait+0x6c>
    8000245a:	4691                	li	a3,4
    8000245c:	02c48613          	addi	a2,s1,44
    80002460:	85da                	mv	a1,s6
    80002462:	05093503          	ld	a0,80(s2)
    80002466:	fffff097          	auipc	ra,0xfffff
    8000246a:	294080e7          	jalr	660(ra) # 800016fa <copyout>
    8000246e:	04054163          	bltz	a0,800024b0 <wait+0xaa>
          freeproc(pp);
    80002472:	8526                	mv	a0,s1
    80002474:	fffff097          	auipc	ra,0xfffff
    80002478:	7a0080e7          	jalr	1952(ra) # 80001c14 <freeproc>
          release(&pp->lock);
    8000247c:	8526                	mv	a0,s1
    8000247e:	fffff097          	auipc	ra,0xfffff
    80002482:	886080e7          	jalr	-1914(ra) # 80000d04 <release>
          release(&wait_lock);
    80002486:	00011517          	auipc	a0,0x11
    8000248a:	06250513          	addi	a0,a0,98 # 800134e8 <wait_lock>
    8000248e:	fffff097          	auipc	ra,0xfffff
    80002492:	876080e7          	jalr	-1930(ra) # 80000d04 <release>
}
    80002496:	854e                	mv	a0,s3
    80002498:	60a6                	ld	ra,72(sp)
    8000249a:	6406                	ld	s0,64(sp)
    8000249c:	74e2                	ld	s1,56(sp)
    8000249e:	7942                	ld	s2,48(sp)
    800024a0:	79a2                	ld	s3,40(sp)
    800024a2:	7a02                	ld	s4,32(sp)
    800024a4:	6ae2                	ld	s5,24(sp)
    800024a6:	6b42                	ld	s6,16(sp)
    800024a8:	6ba2                	ld	s7,8(sp)
    800024aa:	6c02                	ld	s8,0(sp)
    800024ac:	6161                	addi	sp,sp,80
    800024ae:	8082                	ret
            release(&pp->lock);
    800024b0:	8526                	mv	a0,s1
    800024b2:	fffff097          	auipc	ra,0xfffff
    800024b6:	852080e7          	jalr	-1966(ra) # 80000d04 <release>
            release(&wait_lock);
    800024ba:	00011517          	auipc	a0,0x11
    800024be:	02e50513          	addi	a0,a0,46 # 800134e8 <wait_lock>
    800024c2:	fffff097          	auipc	ra,0xfffff
    800024c6:	842080e7          	jalr	-1982(ra) # 80000d04 <release>
            return -1;
    800024ca:	59fd                	li	s3,-1
    800024cc:	b7e9                	j	80002496 <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800024ce:	16848493          	addi	s1,s1,360
    800024d2:	03348463          	beq	s1,s3,800024fa <wait+0xf4>
      if(pp->parent == p){
    800024d6:	7c9c                	ld	a5,56(s1)
    800024d8:	ff279be3          	bne	a5,s2,800024ce <wait+0xc8>
        acquire(&pp->lock);
    800024dc:	8526                	mv	a0,s1
    800024de:	ffffe097          	auipc	ra,0xffffe
    800024e2:	772080e7          	jalr	1906(ra) # 80000c50 <acquire>
        if(pp->state == ZOMBIE){
    800024e6:	4c9c                	lw	a5,24(s1)
    800024e8:	f74785e3          	beq	a5,s4,80002452 <wait+0x4c>
        release(&pp->lock);
    800024ec:	8526                	mv	a0,s1
    800024ee:	fffff097          	auipc	ra,0xfffff
    800024f2:	816080e7          	jalr	-2026(ra) # 80000d04 <release>
        havekids = 1;
    800024f6:	8756                	mv	a4,s5
    800024f8:	bfd9                	j	800024ce <wait+0xc8>
    if(!havekids || killed(p)){
    800024fa:	c31d                	beqz	a4,80002520 <wait+0x11a>
    800024fc:	854a                	mv	a0,s2
    800024fe:	00000097          	auipc	ra,0x0
    80002502:	ed6080e7          	jalr	-298(ra) # 800023d4 <killed>
    80002506:	ed09                	bnez	a0,80002520 <wait+0x11a>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002508:	85e2                	mv	a1,s8
    8000250a:	854a                	mv	a0,s2
    8000250c:	00000097          	auipc	ra,0x0
    80002510:	c20080e7          	jalr	-992(ra) # 8000212c <sleep>
    havekids = 0;
    80002514:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002516:	00011497          	auipc	s1,0x11
    8000251a:	3ea48493          	addi	s1,s1,1002 # 80013900 <proc>
    8000251e:	bf65                	j	800024d6 <wait+0xd0>
      release(&wait_lock);
    80002520:	00011517          	auipc	a0,0x11
    80002524:	fc850513          	addi	a0,a0,-56 # 800134e8 <wait_lock>
    80002528:	ffffe097          	auipc	ra,0xffffe
    8000252c:	7dc080e7          	jalr	2012(ra) # 80000d04 <release>
      return -1;
    80002530:	59fd                	li	s3,-1
    80002532:	b795                	j	80002496 <wait+0x90>

0000000080002534 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002534:	7179                	addi	sp,sp,-48
    80002536:	f406                	sd	ra,40(sp)
    80002538:	f022                	sd	s0,32(sp)
    8000253a:	ec26                	sd	s1,24(sp)
    8000253c:	e84a                	sd	s2,16(sp)
    8000253e:	e44e                	sd	s3,8(sp)
    80002540:	e052                	sd	s4,0(sp)
    80002542:	1800                	addi	s0,sp,48
    80002544:	84aa                	mv	s1,a0
    80002546:	892e                	mv	s2,a1
    80002548:	89b2                	mv	s3,a2
    8000254a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000254c:	fffff097          	auipc	ra,0xfffff
    80002550:	516080e7          	jalr	1302(ra) # 80001a62 <myproc>
  if(user_dst){
    80002554:	c08d                	beqz	s1,80002576 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002556:	86d2                	mv	a3,s4
    80002558:	864e                	mv	a2,s3
    8000255a:	85ca                	mv	a1,s2
    8000255c:	6928                	ld	a0,80(a0)
    8000255e:	fffff097          	auipc	ra,0xfffff
    80002562:	19c080e7          	jalr	412(ra) # 800016fa <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002566:	70a2                	ld	ra,40(sp)
    80002568:	7402                	ld	s0,32(sp)
    8000256a:	64e2                	ld	s1,24(sp)
    8000256c:	6942                	ld	s2,16(sp)
    8000256e:	69a2                	ld	s3,8(sp)
    80002570:	6a02                	ld	s4,0(sp)
    80002572:	6145                	addi	sp,sp,48
    80002574:	8082                	ret
    memmove((char *)dst, src, len);
    80002576:	000a061b          	sext.w	a2,s4
    8000257a:	85ce                	mv	a1,s3
    8000257c:	854a                	mv	a0,s2
    8000257e:	fffff097          	auipc	ra,0xfffff
    80002582:	82a080e7          	jalr	-2006(ra) # 80000da8 <memmove>
    return 0;
    80002586:	8526                	mv	a0,s1
    80002588:	bff9                	j	80002566 <either_copyout+0x32>

000000008000258a <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000258a:	7179                	addi	sp,sp,-48
    8000258c:	f406                	sd	ra,40(sp)
    8000258e:	f022                	sd	s0,32(sp)
    80002590:	ec26                	sd	s1,24(sp)
    80002592:	e84a                	sd	s2,16(sp)
    80002594:	e44e                	sd	s3,8(sp)
    80002596:	e052                	sd	s4,0(sp)
    80002598:	1800                	addi	s0,sp,48
    8000259a:	892a                	mv	s2,a0
    8000259c:	84ae                	mv	s1,a1
    8000259e:	89b2                	mv	s3,a2
    800025a0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800025a2:	fffff097          	auipc	ra,0xfffff
    800025a6:	4c0080e7          	jalr	1216(ra) # 80001a62 <myproc>
  if(user_src){
    800025aa:	c08d                	beqz	s1,800025cc <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800025ac:	86d2                	mv	a3,s4
    800025ae:	864e                	mv	a2,s3
    800025b0:	85ca                	mv	a1,s2
    800025b2:	6928                	ld	a0,80(a0)
    800025b4:	fffff097          	auipc	ra,0xfffff
    800025b8:	1d2080e7          	jalr	466(ra) # 80001786 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800025bc:	70a2                	ld	ra,40(sp)
    800025be:	7402                	ld	s0,32(sp)
    800025c0:	64e2                	ld	s1,24(sp)
    800025c2:	6942                	ld	s2,16(sp)
    800025c4:	69a2                	ld	s3,8(sp)
    800025c6:	6a02                	ld	s4,0(sp)
    800025c8:	6145                	addi	sp,sp,48
    800025ca:	8082                	ret
    memmove(dst, (char*)src, len);
    800025cc:	000a061b          	sext.w	a2,s4
    800025d0:	85ce                	mv	a1,s3
    800025d2:	854a                	mv	a0,s2
    800025d4:	ffffe097          	auipc	ra,0xffffe
    800025d8:	7d4080e7          	jalr	2004(ra) # 80000da8 <memmove>
    return 0;
    800025dc:	8526                	mv	a0,s1
    800025de:	bff9                	j	800025bc <either_copyin+0x32>

00000000800025e0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800025e0:	715d                	addi	sp,sp,-80
    800025e2:	e486                	sd	ra,72(sp)
    800025e4:	e0a2                	sd	s0,64(sp)
    800025e6:	fc26                	sd	s1,56(sp)
    800025e8:	f84a                	sd	s2,48(sp)
    800025ea:	f44e                	sd	s3,40(sp)
    800025ec:	f052                	sd	s4,32(sp)
    800025ee:	ec56                	sd	s5,24(sp)
    800025f0:	e85a                	sd	s6,16(sp)
    800025f2:	e45e                	sd	s7,8(sp)
    800025f4:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800025f6:	00006517          	auipc	a0,0x6
    800025fa:	a1a50513          	addi	a0,a0,-1510 # 80008010 <etext+0x10>
    800025fe:	ffffe097          	auipc	ra,0xffffe
    80002602:	fac080e7          	jalr	-84(ra) # 800005aa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002606:	00011497          	auipc	s1,0x11
    8000260a:	45248493          	addi	s1,s1,1106 # 80013a58 <proc+0x158>
    8000260e:	00017917          	auipc	s2,0x17
    80002612:	e4a90913          	addi	s2,s2,-438 # 80019458 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002616:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002618:	00006997          	auipc	s3,0x6
    8000261c:	c5898993          	addi	s3,s3,-936 # 80008270 <etext+0x270>
    printf("%d %s %s", p->pid, state, p->name);
    80002620:	00006a97          	auipc	s5,0x6
    80002624:	c58a8a93          	addi	s5,s5,-936 # 80008278 <etext+0x278>
    printf("\n");
    80002628:	00006a17          	auipc	s4,0x6
    8000262c:	9e8a0a13          	addi	s4,s4,-1560 # 80008010 <etext+0x10>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002630:	00006b97          	auipc	s7,0x6
    80002634:	120b8b93          	addi	s7,s7,288 # 80008750 <states.0>
    80002638:	a00d                	j	8000265a <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    8000263a:	ed86a583          	lw	a1,-296(a3)
    8000263e:	8556                	mv	a0,s5
    80002640:	ffffe097          	auipc	ra,0xffffe
    80002644:	f6a080e7          	jalr	-150(ra) # 800005aa <printf>
    printf("\n");
    80002648:	8552                	mv	a0,s4
    8000264a:	ffffe097          	auipc	ra,0xffffe
    8000264e:	f60080e7          	jalr	-160(ra) # 800005aa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002652:	16848493          	addi	s1,s1,360
    80002656:	03248263          	beq	s1,s2,8000267a <procdump+0x9a>
    if(p->state == UNUSED)
    8000265a:	86a6                	mv	a3,s1
    8000265c:	ec04a783          	lw	a5,-320(s1)
    80002660:	dbed                	beqz	a5,80002652 <procdump+0x72>
      state = "???";
    80002662:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002664:	fcfb6be3          	bltu	s6,a5,8000263a <procdump+0x5a>
    80002668:	02079713          	slli	a4,a5,0x20
    8000266c:	01d75793          	srli	a5,a4,0x1d
    80002670:	97de                	add	a5,a5,s7
    80002672:	6390                	ld	a2,0(a5)
    80002674:	f279                	bnez	a2,8000263a <procdump+0x5a>
      state = "???";
    80002676:	864e                	mv	a2,s3
    80002678:	b7c9                	j	8000263a <procdump+0x5a>
  }
}
    8000267a:	60a6                	ld	ra,72(sp)
    8000267c:	6406                	ld	s0,64(sp)
    8000267e:	74e2                	ld	s1,56(sp)
    80002680:	7942                	ld	s2,48(sp)
    80002682:	79a2                	ld	s3,40(sp)
    80002684:	7a02                	ld	s4,32(sp)
    80002686:	6ae2                	ld	s5,24(sp)
    80002688:	6b42                	ld	s6,16(sp)
    8000268a:	6ba2                	ld	s7,8(sp)
    8000268c:	6161                	addi	sp,sp,80
    8000268e:	8082                	ret

0000000080002690 <swtch>:
    80002690:	00153023          	sd	ra,0(a0)
    80002694:	00253423          	sd	sp,8(a0)
    80002698:	e900                	sd	s0,16(a0)
    8000269a:	ed04                	sd	s1,24(a0)
    8000269c:	03253023          	sd	s2,32(a0)
    800026a0:	03353423          	sd	s3,40(a0)
    800026a4:	03453823          	sd	s4,48(a0)
    800026a8:	03553c23          	sd	s5,56(a0)
    800026ac:	05653023          	sd	s6,64(a0)
    800026b0:	05753423          	sd	s7,72(a0)
    800026b4:	05853823          	sd	s8,80(a0)
    800026b8:	05953c23          	sd	s9,88(a0)
    800026bc:	07a53023          	sd	s10,96(a0)
    800026c0:	07b53423          	sd	s11,104(a0)
    800026c4:	0005b083          	ld	ra,0(a1)
    800026c8:	0085b103          	ld	sp,8(a1)
    800026cc:	6980                	ld	s0,16(a1)
    800026ce:	6d84                	ld	s1,24(a1)
    800026d0:	0205b903          	ld	s2,32(a1)
    800026d4:	0285b983          	ld	s3,40(a1)
    800026d8:	0305ba03          	ld	s4,48(a1)
    800026dc:	0385ba83          	ld	s5,56(a1)
    800026e0:	0405bb03          	ld	s6,64(a1)
    800026e4:	0485bb83          	ld	s7,72(a1)
    800026e8:	0505bc03          	ld	s8,80(a1)
    800026ec:	0585bc83          	ld	s9,88(a1)
    800026f0:	0605bd03          	ld	s10,96(a1)
    800026f4:	0685bd83          	ld	s11,104(a1)
    800026f8:	8082                	ret

00000000800026fa <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800026fa:	1141                	addi	sp,sp,-16
    800026fc:	e406                	sd	ra,8(sp)
    800026fe:	e022                	sd	s0,0(sp)
    80002700:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002702:	00006597          	auipc	a1,0x6
    80002706:	bb658593          	addi	a1,a1,-1098 # 800082b8 <etext+0x2b8>
    8000270a:	00017517          	auipc	a0,0x17
    8000270e:	bf650513          	addi	a0,a0,-1034 # 80019300 <tickslock>
    80002712:	ffffe097          	auipc	ra,0xffffe
    80002716:	4ae080e7          	jalr	1198(ra) # 80000bc0 <initlock>
}
    8000271a:	60a2                	ld	ra,8(sp)
    8000271c:	6402                	ld	s0,0(sp)
    8000271e:	0141                	addi	sp,sp,16
    80002720:	8082                	ret

0000000080002722 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002722:	1141                	addi	sp,sp,-16
    80002724:	e422                	sd	s0,8(sp)
    80002726:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002728:	00003797          	auipc	a5,0x3
    8000272c:	5f878793          	addi	a5,a5,1528 # 80005d20 <kernelvec>
    80002730:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002734:	6422                	ld	s0,8(sp)
    80002736:	0141                	addi	sp,sp,16
    80002738:	8082                	ret

000000008000273a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000273a:	1141                	addi	sp,sp,-16
    8000273c:	e406                	sd	ra,8(sp)
    8000273e:	e022                	sd	s0,0(sp)
    80002740:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002742:	fffff097          	auipc	ra,0xfffff
    80002746:	320080e7          	jalr	800(ra) # 80001a62 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000274a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000274e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002750:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002754:	00005697          	auipc	a3,0x5
    80002758:	8ac68693          	addi	a3,a3,-1876 # 80007000 <_trampoline>
    8000275c:	00005717          	auipc	a4,0x5
    80002760:	8a470713          	addi	a4,a4,-1884 # 80007000 <_trampoline>
    80002764:	8f15                	sub	a4,a4,a3
    80002766:	040007b7          	lui	a5,0x4000
    8000276a:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    8000276c:	07b2                	slli	a5,a5,0xc
    8000276e:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002770:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002774:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002776:	18002673          	csrr	a2,satp
    8000277a:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000277c:	6d30                	ld	a2,88(a0)
    8000277e:	6138                	ld	a4,64(a0)
    80002780:	6585                	lui	a1,0x1
    80002782:	972e                	add	a4,a4,a1
    80002784:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002786:	6d38                	ld	a4,88(a0)
    80002788:	00000617          	auipc	a2,0x0
    8000278c:	13860613          	addi	a2,a2,312 # 800028c0 <usertrap>
    80002790:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002792:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002794:	8612                	mv	a2,tp
    80002796:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002798:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000279c:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800027a0:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800027a4:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800027a8:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800027aa:	6f18                	ld	a4,24(a4)
    800027ac:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800027b0:	6928                	ld	a0,80(a0)
    800027b2:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800027b4:	00005717          	auipc	a4,0x5
    800027b8:	8e870713          	addi	a4,a4,-1816 # 8000709c <userret>
    800027bc:	8f15                	sub	a4,a4,a3
    800027be:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800027c0:	577d                	li	a4,-1
    800027c2:	177e                	slli	a4,a4,0x3f
    800027c4:	8d59                	or	a0,a0,a4
    800027c6:	9782                	jalr	a5
}
    800027c8:	60a2                	ld	ra,8(sp)
    800027ca:	6402                	ld	s0,0(sp)
    800027cc:	0141                	addi	sp,sp,16
    800027ce:	8082                	ret

00000000800027d0 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800027d0:	1101                	addi	sp,sp,-32
    800027d2:	ec06                	sd	ra,24(sp)
    800027d4:	e822                	sd	s0,16(sp)
    800027d6:	e426                	sd	s1,8(sp)
    800027d8:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    800027da:	00017497          	auipc	s1,0x17
    800027de:	b2648493          	addi	s1,s1,-1242 # 80019300 <tickslock>
    800027e2:	8526                	mv	a0,s1
    800027e4:	ffffe097          	auipc	ra,0xffffe
    800027e8:	46c080e7          	jalr	1132(ra) # 80000c50 <acquire>
  ticks++;
    800027ec:	00009517          	auipc	a0,0x9
    800027f0:	a4450513          	addi	a0,a0,-1468 # 8000b230 <ticks>
    800027f4:	411c                	lw	a5,0(a0)
    800027f6:	2785                	addiw	a5,a5,1
    800027f8:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    800027fa:	00000097          	auipc	ra,0x0
    800027fe:	996080e7          	jalr	-1642(ra) # 80002190 <wakeup>
  release(&tickslock);
    80002802:	8526                	mv	a0,s1
    80002804:	ffffe097          	auipc	ra,0xffffe
    80002808:	500080e7          	jalr	1280(ra) # 80000d04 <release>
}
    8000280c:	60e2                	ld	ra,24(sp)
    8000280e:	6442                	ld	s0,16(sp)
    80002810:	64a2                	ld	s1,8(sp)
    80002812:	6105                	addi	sp,sp,32
    80002814:	8082                	ret

0000000080002816 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002816:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    8000281a:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    8000281c:	0a07d163          	bgez	a5,800028be <devintr+0xa8>
{
    80002820:	1101                	addi	sp,sp,-32
    80002822:	ec06                	sd	ra,24(sp)
    80002824:	e822                	sd	s0,16(sp)
    80002826:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80002828:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    8000282c:	46a5                	li	a3,9
    8000282e:	00d70c63          	beq	a4,a3,80002846 <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80002832:	577d                	li	a4,-1
    80002834:	177e                	slli	a4,a4,0x3f
    80002836:	0705                	addi	a4,a4,1
    return 0;
    80002838:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    8000283a:	06e78163          	beq	a5,a4,8000289c <devintr+0x86>
  }
}
    8000283e:	60e2                	ld	ra,24(sp)
    80002840:	6442                	ld	s0,16(sp)
    80002842:	6105                	addi	sp,sp,32
    80002844:	8082                	ret
    80002846:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002848:	00003097          	auipc	ra,0x3
    8000284c:	5e4080e7          	jalr	1508(ra) # 80005e2c <plic_claim>
    80002850:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002852:	47a9                	li	a5,10
    80002854:	00f50963          	beq	a0,a5,80002866 <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80002858:	4785                	li	a5,1
    8000285a:	00f50b63          	beq	a0,a5,80002870 <devintr+0x5a>
    return 1;
    8000285e:	4505                	li	a0,1
    } else if(irq){
    80002860:	ec89                	bnez	s1,8000287a <devintr+0x64>
    80002862:	64a2                	ld	s1,8(sp)
    80002864:	bfe9                	j	8000283e <devintr+0x28>
      uartintr();
    80002866:	ffffe097          	auipc	ra,0xffffe
    8000286a:	1ac080e7          	jalr	428(ra) # 80000a12 <uartintr>
    if(irq)
    8000286e:	a839                	j	8000288c <devintr+0x76>
      virtio_disk_intr();
    80002870:	00004097          	auipc	ra,0x4
    80002874:	ae6080e7          	jalr	-1306(ra) # 80006356 <virtio_disk_intr>
    if(irq)
    80002878:	a811                	j	8000288c <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    8000287a:	85a6                	mv	a1,s1
    8000287c:	00006517          	auipc	a0,0x6
    80002880:	a4450513          	addi	a0,a0,-1468 # 800082c0 <etext+0x2c0>
    80002884:	ffffe097          	auipc	ra,0xffffe
    80002888:	d26080e7          	jalr	-730(ra) # 800005aa <printf>
      plic_complete(irq);
    8000288c:	8526                	mv	a0,s1
    8000288e:	00003097          	auipc	ra,0x3
    80002892:	5c2080e7          	jalr	1474(ra) # 80005e50 <plic_complete>
    return 1;
    80002896:	4505                	li	a0,1
    80002898:	64a2                	ld	s1,8(sp)
    8000289a:	b755                	j	8000283e <devintr+0x28>
    if(cpuid() == 0){
    8000289c:	fffff097          	auipc	ra,0xfffff
    800028a0:	19a080e7          	jalr	410(ra) # 80001a36 <cpuid>
    800028a4:	c901                	beqz	a0,800028b4 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    800028a6:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    800028aa:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    800028ac:	14479073          	csrw	sip,a5
    return 2;
    800028b0:	4509                	li	a0,2
    800028b2:	b771                	j	8000283e <devintr+0x28>
      clockintr();
    800028b4:	00000097          	auipc	ra,0x0
    800028b8:	f1c080e7          	jalr	-228(ra) # 800027d0 <clockintr>
    800028bc:	b7ed                	j	800028a6 <devintr+0x90>
}
    800028be:	8082                	ret

00000000800028c0 <usertrap>:
{
    800028c0:	1101                	addi	sp,sp,-32
    800028c2:	ec06                	sd	ra,24(sp)
    800028c4:	e822                	sd	s0,16(sp)
    800028c6:	e426                	sd	s1,8(sp)
    800028c8:	e04a                	sd	s2,0(sp)
    800028ca:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028cc:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800028d0:	1007f793          	andi	a5,a5,256
    800028d4:	e3b1                	bnez	a5,80002918 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800028d6:	00003797          	auipc	a5,0x3
    800028da:	44a78793          	addi	a5,a5,1098 # 80005d20 <kernelvec>
    800028de:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800028e2:	fffff097          	auipc	ra,0xfffff
    800028e6:	180080e7          	jalr	384(ra) # 80001a62 <myproc>
    800028ea:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800028ec:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800028ee:	14102773          	csrr	a4,sepc
    800028f2:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028f4:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800028f8:	47a1                	li	a5,8
    800028fa:	02f70763          	beq	a4,a5,80002928 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    800028fe:	00000097          	auipc	ra,0x0
    80002902:	f18080e7          	jalr	-232(ra) # 80002816 <devintr>
    80002906:	892a                	mv	s2,a0
    80002908:	c151                	beqz	a0,8000298c <usertrap+0xcc>
  if(killed(p))
    8000290a:	8526                	mv	a0,s1
    8000290c:	00000097          	auipc	ra,0x0
    80002910:	ac8080e7          	jalr	-1336(ra) # 800023d4 <killed>
    80002914:	c929                	beqz	a0,80002966 <usertrap+0xa6>
    80002916:	a099                	j	8000295c <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80002918:	00006517          	auipc	a0,0x6
    8000291c:	9c850513          	addi	a0,a0,-1592 # 800082e0 <etext+0x2e0>
    80002920:	ffffe097          	auipc	ra,0xffffe
    80002924:	c40080e7          	jalr	-960(ra) # 80000560 <panic>
    if(killed(p))
    80002928:	00000097          	auipc	ra,0x0
    8000292c:	aac080e7          	jalr	-1364(ra) # 800023d4 <killed>
    80002930:	e921                	bnez	a0,80002980 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80002932:	6cb8                	ld	a4,88(s1)
    80002934:	6f1c                	ld	a5,24(a4)
    80002936:	0791                	addi	a5,a5,4
    80002938:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000293a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000293e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002942:	10079073          	csrw	sstatus,a5
    syscall();
    80002946:	00000097          	auipc	ra,0x0
    8000294a:	2d4080e7          	jalr	724(ra) # 80002c1a <syscall>
  if(killed(p))
    8000294e:	8526                	mv	a0,s1
    80002950:	00000097          	auipc	ra,0x0
    80002954:	a84080e7          	jalr	-1404(ra) # 800023d4 <killed>
    80002958:	c911                	beqz	a0,8000296c <usertrap+0xac>
    8000295a:	4901                	li	s2,0
    exit(-1);
    8000295c:	557d                	li	a0,-1
    8000295e:	00000097          	auipc	ra,0x0
    80002962:	902080e7          	jalr	-1790(ra) # 80002260 <exit>
  if(which_dev == 2)
    80002966:	4789                	li	a5,2
    80002968:	04f90f63          	beq	s2,a5,800029c6 <usertrap+0x106>
  usertrapret();
    8000296c:	00000097          	auipc	ra,0x0
    80002970:	dce080e7          	jalr	-562(ra) # 8000273a <usertrapret>
}
    80002974:	60e2                	ld	ra,24(sp)
    80002976:	6442                	ld	s0,16(sp)
    80002978:	64a2                	ld	s1,8(sp)
    8000297a:	6902                	ld	s2,0(sp)
    8000297c:	6105                	addi	sp,sp,32
    8000297e:	8082                	ret
      exit(-1);
    80002980:	557d                	li	a0,-1
    80002982:	00000097          	auipc	ra,0x0
    80002986:	8de080e7          	jalr	-1826(ra) # 80002260 <exit>
    8000298a:	b765                	j	80002932 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000298c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002990:	5890                	lw	a2,48(s1)
    80002992:	00006517          	auipc	a0,0x6
    80002996:	96e50513          	addi	a0,a0,-1682 # 80008300 <etext+0x300>
    8000299a:	ffffe097          	auipc	ra,0xffffe
    8000299e:	c10080e7          	jalr	-1008(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800029a2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800029a6:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    800029aa:	00006517          	auipc	a0,0x6
    800029ae:	98650513          	addi	a0,a0,-1658 # 80008330 <etext+0x330>
    800029b2:	ffffe097          	auipc	ra,0xffffe
    800029b6:	bf8080e7          	jalr	-1032(ra) # 800005aa <printf>
    setkilled(p);
    800029ba:	8526                	mv	a0,s1
    800029bc:	00000097          	auipc	ra,0x0
    800029c0:	9ec080e7          	jalr	-1556(ra) # 800023a8 <setkilled>
    800029c4:	b769                	j	8000294e <usertrap+0x8e>
    yield();
    800029c6:	fffff097          	auipc	ra,0xfffff
    800029ca:	72a080e7          	jalr	1834(ra) # 800020f0 <yield>
    800029ce:	bf79                	j	8000296c <usertrap+0xac>

00000000800029d0 <kerneltrap>:
{
    800029d0:	7179                	addi	sp,sp,-48
    800029d2:	f406                	sd	ra,40(sp)
    800029d4:	f022                	sd	s0,32(sp)
    800029d6:	ec26                	sd	s1,24(sp)
    800029d8:	e84a                	sd	s2,16(sp)
    800029da:	e44e                	sd	s3,8(sp)
    800029dc:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800029de:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800029e2:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800029e6:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800029ea:	1004f793          	andi	a5,s1,256
    800029ee:	cb85                	beqz	a5,80002a1e <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800029f0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800029f4:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800029f6:	ef85                	bnez	a5,80002a2e <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    800029f8:	00000097          	auipc	ra,0x0
    800029fc:	e1e080e7          	jalr	-482(ra) # 80002816 <devintr>
    80002a00:	cd1d                	beqz	a0,80002a3e <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002a02:	4789                	li	a5,2
    80002a04:	06f50a63          	beq	a0,a5,80002a78 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002a08:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a0c:	10049073          	csrw	sstatus,s1
}
    80002a10:	70a2                	ld	ra,40(sp)
    80002a12:	7402                	ld	s0,32(sp)
    80002a14:	64e2                	ld	s1,24(sp)
    80002a16:	6942                	ld	s2,16(sp)
    80002a18:	69a2                	ld	s3,8(sp)
    80002a1a:	6145                	addi	sp,sp,48
    80002a1c:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002a1e:	00006517          	auipc	a0,0x6
    80002a22:	93250513          	addi	a0,a0,-1742 # 80008350 <etext+0x350>
    80002a26:	ffffe097          	auipc	ra,0xffffe
    80002a2a:	b3a080e7          	jalr	-1222(ra) # 80000560 <panic>
    panic("kerneltrap: interrupts enabled");
    80002a2e:	00006517          	auipc	a0,0x6
    80002a32:	94a50513          	addi	a0,a0,-1718 # 80008378 <etext+0x378>
    80002a36:	ffffe097          	auipc	ra,0xffffe
    80002a3a:	b2a080e7          	jalr	-1238(ra) # 80000560 <panic>
    printf("scause %p\n", scause);
    80002a3e:	85ce                	mv	a1,s3
    80002a40:	00006517          	auipc	a0,0x6
    80002a44:	95850513          	addi	a0,a0,-1704 # 80008398 <etext+0x398>
    80002a48:	ffffe097          	auipc	ra,0xffffe
    80002a4c:	b62080e7          	jalr	-1182(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a50:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002a54:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002a58:	00006517          	auipc	a0,0x6
    80002a5c:	95050513          	addi	a0,a0,-1712 # 800083a8 <etext+0x3a8>
    80002a60:	ffffe097          	auipc	ra,0xffffe
    80002a64:	b4a080e7          	jalr	-1206(ra) # 800005aa <printf>
    panic("kerneltrap");
    80002a68:	00006517          	auipc	a0,0x6
    80002a6c:	95850513          	addi	a0,a0,-1704 # 800083c0 <etext+0x3c0>
    80002a70:	ffffe097          	auipc	ra,0xffffe
    80002a74:	af0080e7          	jalr	-1296(ra) # 80000560 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002a78:	fffff097          	auipc	ra,0xfffff
    80002a7c:	fea080e7          	jalr	-22(ra) # 80001a62 <myproc>
    80002a80:	d541                	beqz	a0,80002a08 <kerneltrap+0x38>
    80002a82:	fffff097          	auipc	ra,0xfffff
    80002a86:	fe0080e7          	jalr	-32(ra) # 80001a62 <myproc>
    80002a8a:	4d18                	lw	a4,24(a0)
    80002a8c:	4791                	li	a5,4
    80002a8e:	f6f71de3          	bne	a4,a5,80002a08 <kerneltrap+0x38>
    yield();
    80002a92:	fffff097          	auipc	ra,0xfffff
    80002a96:	65e080e7          	jalr	1630(ra) # 800020f0 <yield>
    80002a9a:	b7bd                	j	80002a08 <kerneltrap+0x38>

0000000080002a9c <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002a9c:	1101                	addi	sp,sp,-32
    80002a9e:	ec06                	sd	ra,24(sp)
    80002aa0:	e822                	sd	s0,16(sp)
    80002aa2:	e426                	sd	s1,8(sp)
    80002aa4:	1000                	addi	s0,sp,32
    80002aa6:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002aa8:	fffff097          	auipc	ra,0xfffff
    80002aac:	fba080e7          	jalr	-70(ra) # 80001a62 <myproc>
  switch (n) {
    80002ab0:	4795                	li	a5,5
    80002ab2:	0497e163          	bltu	a5,s1,80002af4 <argraw+0x58>
    80002ab6:	048a                	slli	s1,s1,0x2
    80002ab8:	00006717          	auipc	a4,0x6
    80002abc:	cc870713          	addi	a4,a4,-824 # 80008780 <states.0+0x30>
    80002ac0:	94ba                	add	s1,s1,a4
    80002ac2:	409c                	lw	a5,0(s1)
    80002ac4:	97ba                	add	a5,a5,a4
    80002ac6:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002ac8:	6d3c                	ld	a5,88(a0)
    80002aca:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002acc:	60e2                	ld	ra,24(sp)
    80002ace:	6442                	ld	s0,16(sp)
    80002ad0:	64a2                	ld	s1,8(sp)
    80002ad2:	6105                	addi	sp,sp,32
    80002ad4:	8082                	ret
    return p->trapframe->a1;
    80002ad6:	6d3c                	ld	a5,88(a0)
    80002ad8:	7fa8                	ld	a0,120(a5)
    80002ada:	bfcd                	j	80002acc <argraw+0x30>
    return p->trapframe->a2;
    80002adc:	6d3c                	ld	a5,88(a0)
    80002ade:	63c8                	ld	a0,128(a5)
    80002ae0:	b7f5                	j	80002acc <argraw+0x30>
    return p->trapframe->a3;
    80002ae2:	6d3c                	ld	a5,88(a0)
    80002ae4:	67c8                	ld	a0,136(a5)
    80002ae6:	b7dd                	j	80002acc <argraw+0x30>
    return p->trapframe->a4;
    80002ae8:	6d3c                	ld	a5,88(a0)
    80002aea:	6bc8                	ld	a0,144(a5)
    80002aec:	b7c5                	j	80002acc <argraw+0x30>
    return p->trapframe->a5;
    80002aee:	6d3c                	ld	a5,88(a0)
    80002af0:	6fc8                	ld	a0,152(a5)
    80002af2:	bfe9                	j	80002acc <argraw+0x30>
  panic("argraw");
    80002af4:	00006517          	auipc	a0,0x6
    80002af8:	8dc50513          	addi	a0,a0,-1828 # 800083d0 <etext+0x3d0>
    80002afc:	ffffe097          	auipc	ra,0xffffe
    80002b00:	a64080e7          	jalr	-1436(ra) # 80000560 <panic>

0000000080002b04 <fetchaddr>:
{
    80002b04:	1101                	addi	sp,sp,-32
    80002b06:	ec06                	sd	ra,24(sp)
    80002b08:	e822                	sd	s0,16(sp)
    80002b0a:	e426                	sd	s1,8(sp)
    80002b0c:	e04a                	sd	s2,0(sp)
    80002b0e:	1000                	addi	s0,sp,32
    80002b10:	84aa                	mv	s1,a0
    80002b12:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002b14:	fffff097          	auipc	ra,0xfffff
    80002b18:	f4e080e7          	jalr	-178(ra) # 80001a62 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002b1c:	653c                	ld	a5,72(a0)
    80002b1e:	02f4f863          	bgeu	s1,a5,80002b4e <fetchaddr+0x4a>
    80002b22:	00848713          	addi	a4,s1,8
    80002b26:	02e7e663          	bltu	a5,a4,80002b52 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002b2a:	46a1                	li	a3,8
    80002b2c:	8626                	mv	a2,s1
    80002b2e:	85ca                	mv	a1,s2
    80002b30:	6928                	ld	a0,80(a0)
    80002b32:	fffff097          	auipc	ra,0xfffff
    80002b36:	c54080e7          	jalr	-940(ra) # 80001786 <copyin>
    80002b3a:	00a03533          	snez	a0,a0
    80002b3e:	40a00533          	neg	a0,a0
}
    80002b42:	60e2                	ld	ra,24(sp)
    80002b44:	6442                	ld	s0,16(sp)
    80002b46:	64a2                	ld	s1,8(sp)
    80002b48:	6902                	ld	s2,0(sp)
    80002b4a:	6105                	addi	sp,sp,32
    80002b4c:	8082                	ret
    return -1;
    80002b4e:	557d                	li	a0,-1
    80002b50:	bfcd                	j	80002b42 <fetchaddr+0x3e>
    80002b52:	557d                	li	a0,-1
    80002b54:	b7fd                	j	80002b42 <fetchaddr+0x3e>

0000000080002b56 <fetchstr>:
{
    80002b56:	7179                	addi	sp,sp,-48
    80002b58:	f406                	sd	ra,40(sp)
    80002b5a:	f022                	sd	s0,32(sp)
    80002b5c:	ec26                	sd	s1,24(sp)
    80002b5e:	e84a                	sd	s2,16(sp)
    80002b60:	e44e                	sd	s3,8(sp)
    80002b62:	1800                	addi	s0,sp,48
    80002b64:	892a                	mv	s2,a0
    80002b66:	84ae                	mv	s1,a1
    80002b68:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002b6a:	fffff097          	auipc	ra,0xfffff
    80002b6e:	ef8080e7          	jalr	-264(ra) # 80001a62 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002b72:	86ce                	mv	a3,s3
    80002b74:	864a                	mv	a2,s2
    80002b76:	85a6                	mv	a1,s1
    80002b78:	6928                	ld	a0,80(a0)
    80002b7a:	fffff097          	auipc	ra,0xfffff
    80002b7e:	c9a080e7          	jalr	-870(ra) # 80001814 <copyinstr>
    80002b82:	00054e63          	bltz	a0,80002b9e <fetchstr+0x48>
  return strlen(buf);
    80002b86:	8526                	mv	a0,s1
    80002b88:	ffffe097          	auipc	ra,0xffffe
    80002b8c:	338080e7          	jalr	824(ra) # 80000ec0 <strlen>
}
    80002b90:	70a2                	ld	ra,40(sp)
    80002b92:	7402                	ld	s0,32(sp)
    80002b94:	64e2                	ld	s1,24(sp)
    80002b96:	6942                	ld	s2,16(sp)
    80002b98:	69a2                	ld	s3,8(sp)
    80002b9a:	6145                	addi	sp,sp,48
    80002b9c:	8082                	ret
    return -1;
    80002b9e:	557d                	li	a0,-1
    80002ba0:	bfc5                	j	80002b90 <fetchstr+0x3a>

0000000080002ba2 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002ba2:	1101                	addi	sp,sp,-32
    80002ba4:	ec06                	sd	ra,24(sp)
    80002ba6:	e822                	sd	s0,16(sp)
    80002ba8:	e426                	sd	s1,8(sp)
    80002baa:	1000                	addi	s0,sp,32
    80002bac:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002bae:	00000097          	auipc	ra,0x0
    80002bb2:	eee080e7          	jalr	-274(ra) # 80002a9c <argraw>
    80002bb6:	c088                	sw	a0,0(s1)
}
    80002bb8:	60e2                	ld	ra,24(sp)
    80002bba:	6442                	ld	s0,16(sp)
    80002bbc:	64a2                	ld	s1,8(sp)
    80002bbe:	6105                	addi	sp,sp,32
    80002bc0:	8082                	ret

0000000080002bc2 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002bc2:	1101                	addi	sp,sp,-32
    80002bc4:	ec06                	sd	ra,24(sp)
    80002bc6:	e822                	sd	s0,16(sp)
    80002bc8:	e426                	sd	s1,8(sp)
    80002bca:	1000                	addi	s0,sp,32
    80002bcc:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002bce:	00000097          	auipc	ra,0x0
    80002bd2:	ece080e7          	jalr	-306(ra) # 80002a9c <argraw>
    80002bd6:	e088                	sd	a0,0(s1)
}
    80002bd8:	60e2                	ld	ra,24(sp)
    80002bda:	6442                	ld	s0,16(sp)
    80002bdc:	64a2                	ld	s1,8(sp)
    80002bde:	6105                	addi	sp,sp,32
    80002be0:	8082                	ret

0000000080002be2 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002be2:	7179                	addi	sp,sp,-48
    80002be4:	f406                	sd	ra,40(sp)
    80002be6:	f022                	sd	s0,32(sp)
    80002be8:	ec26                	sd	s1,24(sp)
    80002bea:	e84a                	sd	s2,16(sp)
    80002bec:	1800                	addi	s0,sp,48
    80002bee:	84ae                	mv	s1,a1
    80002bf0:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002bf2:	fd840593          	addi	a1,s0,-40
    80002bf6:	00000097          	auipc	ra,0x0
    80002bfa:	fcc080e7          	jalr	-52(ra) # 80002bc2 <argaddr>
  return fetchstr(addr, buf, max);
    80002bfe:	864a                	mv	a2,s2
    80002c00:	85a6                	mv	a1,s1
    80002c02:	fd843503          	ld	a0,-40(s0)
    80002c06:	00000097          	auipc	ra,0x0
    80002c0a:	f50080e7          	jalr	-176(ra) # 80002b56 <fetchstr>
}
    80002c0e:	70a2                	ld	ra,40(sp)
    80002c10:	7402                	ld	s0,32(sp)
    80002c12:	64e2                	ld	s1,24(sp)
    80002c14:	6942                	ld	s2,16(sp)
    80002c16:	6145                	addi	sp,sp,48
    80002c18:	8082                	ret

0000000080002c1a <syscall>:
[SYS_unlock]  sys_unlock,
};

void
syscall(void)
{
    80002c1a:	1101                	addi	sp,sp,-32
    80002c1c:	ec06                	sd	ra,24(sp)
    80002c1e:	e822                	sd	s0,16(sp)
    80002c20:	e426                	sd	s1,8(sp)
    80002c22:	e04a                	sd	s2,0(sp)
    80002c24:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002c26:	fffff097          	auipc	ra,0xfffff
    80002c2a:	e3c080e7          	jalr	-452(ra) # 80001a62 <myproc>
    80002c2e:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002c30:	05853903          	ld	s2,88(a0)
    80002c34:	0a893783          	ld	a5,168(s2)
    80002c38:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002c3c:	37fd                	addiw	a5,a5,-1
    80002c3e:	475d                	li	a4,23
    80002c40:	00f76f63          	bltu	a4,a5,80002c5e <syscall+0x44>
    80002c44:	00369713          	slli	a4,a3,0x3
    80002c48:	00006797          	auipc	a5,0x6
    80002c4c:	b5078793          	addi	a5,a5,-1200 # 80008798 <syscalls>
    80002c50:	97ba                	add	a5,a5,a4
    80002c52:	639c                	ld	a5,0(a5)
    80002c54:	c789                	beqz	a5,80002c5e <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002c56:	9782                	jalr	a5
    80002c58:	06a93823          	sd	a0,112(s2)
    80002c5c:	a839                	j	80002c7a <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002c5e:	15848613          	addi	a2,s1,344
    80002c62:	588c                	lw	a1,48(s1)
    80002c64:	00005517          	auipc	a0,0x5
    80002c68:	77450513          	addi	a0,a0,1908 # 800083d8 <etext+0x3d8>
    80002c6c:	ffffe097          	auipc	ra,0xffffe
    80002c70:	93e080e7          	jalr	-1730(ra) # 800005aa <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002c74:	6cbc                	ld	a5,88(s1)
    80002c76:	577d                	li	a4,-1
    80002c78:	fbb8                	sd	a4,112(a5)
  }
}
    80002c7a:	60e2                	ld	ra,24(sp)
    80002c7c:	6442                	ld	s0,16(sp)
    80002c7e:	64a2                	ld	s1,8(sp)
    80002c80:	6902                	ld	s2,0(sp)
    80002c82:	6105                	addi	sp,sp,32
    80002c84:	8082                	ret

0000000080002c86 <sys_exit>:

extern struct sleeplock print_lock;

uint64
sys_exit(void)
{
    80002c86:	1101                	addi	sp,sp,-32
    80002c88:	ec06                	sd	ra,24(sp)
    80002c8a:	e822                	sd	s0,16(sp)
    80002c8c:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002c8e:	fec40593          	addi	a1,s0,-20
    80002c92:	4501                	li	a0,0
    80002c94:	00000097          	auipc	ra,0x0
    80002c98:	f0e080e7          	jalr	-242(ra) # 80002ba2 <argint>
  exit(n);
    80002c9c:	fec42503          	lw	a0,-20(s0)
    80002ca0:	fffff097          	auipc	ra,0xfffff
    80002ca4:	5c0080e7          	jalr	1472(ra) # 80002260 <exit>
  return 0;  // not reached
}
    80002ca8:	4501                	li	a0,0
    80002caa:	60e2                	ld	ra,24(sp)
    80002cac:	6442                	ld	s0,16(sp)
    80002cae:	6105                	addi	sp,sp,32
    80002cb0:	8082                	ret

0000000080002cb2 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002cb2:	1141                	addi	sp,sp,-16
    80002cb4:	e406                	sd	ra,8(sp)
    80002cb6:	e022                	sd	s0,0(sp)
    80002cb8:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002cba:	fffff097          	auipc	ra,0xfffff
    80002cbe:	da8080e7          	jalr	-600(ra) # 80001a62 <myproc>
}
    80002cc2:	5908                	lw	a0,48(a0)
    80002cc4:	60a2                	ld	ra,8(sp)
    80002cc6:	6402                	ld	s0,0(sp)
    80002cc8:	0141                	addi	sp,sp,16
    80002cca:	8082                	ret

0000000080002ccc <sys_fork>:

uint64
sys_fork(void)
{
    80002ccc:	1141                	addi	sp,sp,-16
    80002cce:	e406                	sd	ra,8(sp)
    80002cd0:	e022                	sd	s0,0(sp)
    80002cd2:	0800                	addi	s0,sp,16
  return fork();
    80002cd4:	fffff097          	auipc	ra,0xfffff
    80002cd8:	144080e7          	jalr	324(ra) # 80001e18 <fork>
}
    80002cdc:	60a2                	ld	ra,8(sp)
    80002cde:	6402                	ld	s0,0(sp)
    80002ce0:	0141                	addi	sp,sp,16
    80002ce2:	8082                	ret

0000000080002ce4 <sys_wait>:

uint64
sys_wait(void)
{
    80002ce4:	1101                	addi	sp,sp,-32
    80002ce6:	ec06                	sd	ra,24(sp)
    80002ce8:	e822                	sd	s0,16(sp)
    80002cea:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002cec:	fe840593          	addi	a1,s0,-24
    80002cf0:	4501                	li	a0,0
    80002cf2:	00000097          	auipc	ra,0x0
    80002cf6:	ed0080e7          	jalr	-304(ra) # 80002bc2 <argaddr>
  return wait(p);
    80002cfa:	fe843503          	ld	a0,-24(s0)
    80002cfe:	fffff097          	auipc	ra,0xfffff
    80002d02:	708080e7          	jalr	1800(ra) # 80002406 <wait>
}
    80002d06:	60e2                	ld	ra,24(sp)
    80002d08:	6442                	ld	s0,16(sp)
    80002d0a:	6105                	addi	sp,sp,32
    80002d0c:	8082                	ret

0000000080002d0e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002d0e:	7179                	addi	sp,sp,-48
    80002d10:	f406                	sd	ra,40(sp)
    80002d12:	f022                	sd	s0,32(sp)
    80002d14:	ec26                	sd	s1,24(sp)
    80002d16:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002d18:	fdc40593          	addi	a1,s0,-36
    80002d1c:	4501                	li	a0,0
    80002d1e:	00000097          	auipc	ra,0x0
    80002d22:	e84080e7          	jalr	-380(ra) # 80002ba2 <argint>
  addr = myproc()->sz;
    80002d26:	fffff097          	auipc	ra,0xfffff
    80002d2a:	d3c080e7          	jalr	-708(ra) # 80001a62 <myproc>
    80002d2e:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002d30:	fdc42503          	lw	a0,-36(s0)
    80002d34:	fffff097          	auipc	ra,0xfffff
    80002d38:	088080e7          	jalr	136(ra) # 80001dbc <growproc>
    80002d3c:	00054863          	bltz	a0,80002d4c <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002d40:	8526                	mv	a0,s1
    80002d42:	70a2                	ld	ra,40(sp)
    80002d44:	7402                	ld	s0,32(sp)
    80002d46:	64e2                	ld	s1,24(sp)
    80002d48:	6145                	addi	sp,sp,48
    80002d4a:	8082                	ret
    return -1;
    80002d4c:	54fd                	li	s1,-1
    80002d4e:	bfcd                	j	80002d40 <sys_sbrk+0x32>

0000000080002d50 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002d50:	7139                	addi	sp,sp,-64
    80002d52:	fc06                	sd	ra,56(sp)
    80002d54:	f822                	sd	s0,48(sp)
    80002d56:	f04a                	sd	s2,32(sp)
    80002d58:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002d5a:	fcc40593          	addi	a1,s0,-52
    80002d5e:	4501                	li	a0,0
    80002d60:	00000097          	auipc	ra,0x0
    80002d64:	e42080e7          	jalr	-446(ra) # 80002ba2 <argint>
  acquire(&tickslock);
    80002d68:	00016517          	auipc	a0,0x16
    80002d6c:	59850513          	addi	a0,a0,1432 # 80019300 <tickslock>
    80002d70:	ffffe097          	auipc	ra,0xffffe
    80002d74:	ee0080e7          	jalr	-288(ra) # 80000c50 <acquire>
  ticks0 = ticks;
    80002d78:	00008917          	auipc	s2,0x8
    80002d7c:	4b892903          	lw	s2,1208(s2) # 8000b230 <ticks>
  while(ticks - ticks0 < n){
    80002d80:	fcc42783          	lw	a5,-52(s0)
    80002d84:	c3b9                	beqz	a5,80002dca <sys_sleep+0x7a>
    80002d86:	f426                	sd	s1,40(sp)
    80002d88:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002d8a:	00016997          	auipc	s3,0x16
    80002d8e:	57698993          	addi	s3,s3,1398 # 80019300 <tickslock>
    80002d92:	00008497          	auipc	s1,0x8
    80002d96:	49e48493          	addi	s1,s1,1182 # 8000b230 <ticks>
    if(killed(myproc())){
    80002d9a:	fffff097          	auipc	ra,0xfffff
    80002d9e:	cc8080e7          	jalr	-824(ra) # 80001a62 <myproc>
    80002da2:	fffff097          	auipc	ra,0xfffff
    80002da6:	632080e7          	jalr	1586(ra) # 800023d4 <killed>
    80002daa:	ed15                	bnez	a0,80002de6 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80002dac:	85ce                	mv	a1,s3
    80002dae:	8526                	mv	a0,s1
    80002db0:	fffff097          	auipc	ra,0xfffff
    80002db4:	37c080e7          	jalr	892(ra) # 8000212c <sleep>
  while(ticks - ticks0 < n){
    80002db8:	409c                	lw	a5,0(s1)
    80002dba:	412787bb          	subw	a5,a5,s2
    80002dbe:	fcc42703          	lw	a4,-52(s0)
    80002dc2:	fce7ece3          	bltu	a5,a4,80002d9a <sys_sleep+0x4a>
    80002dc6:	74a2                	ld	s1,40(sp)
    80002dc8:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002dca:	00016517          	auipc	a0,0x16
    80002dce:	53650513          	addi	a0,a0,1334 # 80019300 <tickslock>
    80002dd2:	ffffe097          	auipc	ra,0xffffe
    80002dd6:	f32080e7          	jalr	-206(ra) # 80000d04 <release>
  return 0;
    80002dda:	4501                	li	a0,0
}
    80002ddc:	70e2                	ld	ra,56(sp)
    80002dde:	7442                	ld	s0,48(sp)
    80002de0:	7902                	ld	s2,32(sp)
    80002de2:	6121                	addi	sp,sp,64
    80002de4:	8082                	ret
      release(&tickslock);
    80002de6:	00016517          	auipc	a0,0x16
    80002dea:	51a50513          	addi	a0,a0,1306 # 80019300 <tickslock>
    80002dee:	ffffe097          	auipc	ra,0xffffe
    80002df2:	f16080e7          	jalr	-234(ra) # 80000d04 <release>
      return -1;
    80002df6:	557d                	li	a0,-1
    80002df8:	74a2                	ld	s1,40(sp)
    80002dfa:	69e2                	ld	s3,24(sp)
    80002dfc:	b7c5                	j	80002ddc <sys_sleep+0x8c>

0000000080002dfe <sys_kill>:

uint64
sys_kill(void)
{
    80002dfe:	1101                	addi	sp,sp,-32
    80002e00:	ec06                	sd	ra,24(sp)
    80002e02:	e822                	sd	s0,16(sp)
    80002e04:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002e06:	fec40593          	addi	a1,s0,-20
    80002e0a:	4501                	li	a0,0
    80002e0c:	00000097          	auipc	ra,0x0
    80002e10:	d96080e7          	jalr	-618(ra) # 80002ba2 <argint>
  return kill(pid);
    80002e14:	fec42503          	lw	a0,-20(s0)
    80002e18:	fffff097          	auipc	ra,0xfffff
    80002e1c:	51e080e7          	jalr	1310(ra) # 80002336 <kill>
}
    80002e20:	60e2                	ld	ra,24(sp)
    80002e22:	6442                	ld	s0,16(sp)
    80002e24:	6105                	addi	sp,sp,32
    80002e26:	8082                	ret

0000000080002e28 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002e28:	1101                	addi	sp,sp,-32
    80002e2a:	ec06                	sd	ra,24(sp)
    80002e2c:	e822                	sd	s0,16(sp)
    80002e2e:	e426                	sd	s1,8(sp)
    80002e30:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002e32:	00016517          	auipc	a0,0x16
    80002e36:	4ce50513          	addi	a0,a0,1230 # 80019300 <tickslock>
    80002e3a:	ffffe097          	auipc	ra,0xffffe
    80002e3e:	e16080e7          	jalr	-490(ra) # 80000c50 <acquire>
  xticks = ticks;
    80002e42:	00008497          	auipc	s1,0x8
    80002e46:	3ee4a483          	lw	s1,1006(s1) # 8000b230 <ticks>
  release(&tickslock);
    80002e4a:	00016517          	auipc	a0,0x16
    80002e4e:	4b650513          	addi	a0,a0,1206 # 80019300 <tickslock>
    80002e52:	ffffe097          	auipc	ra,0xffffe
    80002e56:	eb2080e7          	jalr	-334(ra) # 80000d04 <release>
  return xticks;
}
    80002e5a:	02049513          	slli	a0,s1,0x20
    80002e5e:	9101                	srli	a0,a0,0x20
    80002e60:	60e2                	ld	ra,24(sp)
    80002e62:	6442                	ld	s0,16(sp)
    80002e64:	64a2                	ld	s1,8(sp)
    80002e66:	6105                	addi	sp,sp,32
    80002e68:	8082                	ret

0000000080002e6a <sys_yield>:

uint64
sys_yield(void)
{
    80002e6a:	1141                	addi	sp,sp,-16
    80002e6c:	e406                	sd	ra,8(sp)
    80002e6e:	e022                	sd	s0,0(sp)
    80002e70:	0800                	addi	s0,sp,16
  yield();
    80002e72:	fffff097          	auipc	ra,0xfffff
    80002e76:	27e080e7          	jalr	638(ra) # 800020f0 <yield>
  return 0;
}
    80002e7a:	4501                	li	a0,0
    80002e7c:	60a2                	ld	ra,8(sp)
    80002e7e:	6402                	ld	s0,0(sp)
    80002e80:	0141                	addi	sp,sp,16
    80002e82:	8082                	ret

0000000080002e84 <sys_lock>:

uint64
sys_lock(void)
{
    80002e84:	1141                	addi	sp,sp,-16
    80002e86:	e406                	sd	ra,8(sp)
    80002e88:	e022                	sd	s0,0(sp)
    80002e8a:	0800                	addi	s0,sp,16
  acquiresleep(&print_lock);
    80002e8c:	00010517          	auipc	a0,0x10
    80002e90:	5bc50513          	addi	a0,a0,1468 # 80013448 <print_lock>
    80002e94:	00001097          	auipc	ra,0x1
    80002e98:	5ba080e7          	jalr	1466(ra) # 8000444e <acquiresleep>
  return 0;
}
    80002e9c:	4501                	li	a0,0
    80002e9e:	60a2                	ld	ra,8(sp)
    80002ea0:	6402                	ld	s0,0(sp)
    80002ea2:	0141                	addi	sp,sp,16
    80002ea4:	8082                	ret

0000000080002ea6 <sys_unlock>:

uint64
sys_unlock(void)
{
    80002ea6:	1141                	addi	sp,sp,-16
    80002ea8:	e406                	sd	ra,8(sp)
    80002eaa:	e022                	sd	s0,0(sp)
    80002eac:	0800                	addi	s0,sp,16
  releasesleep(&print_lock);
    80002eae:	00010517          	auipc	a0,0x10
    80002eb2:	59a50513          	addi	a0,a0,1434 # 80013448 <print_lock>
    80002eb6:	00001097          	auipc	ra,0x1
    80002eba:	5ee080e7          	jalr	1518(ra) # 800044a4 <releasesleep>
  return 0;
}
    80002ebe:	4501                	li	a0,0
    80002ec0:	60a2                	ld	ra,8(sp)
    80002ec2:	6402                	ld	s0,0(sp)
    80002ec4:	0141                	addi	sp,sp,16
    80002ec6:	8082                	ret

0000000080002ec8 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002ec8:	7179                	addi	sp,sp,-48
    80002eca:	f406                	sd	ra,40(sp)
    80002ecc:	f022                	sd	s0,32(sp)
    80002ece:	ec26                	sd	s1,24(sp)
    80002ed0:	e84a                	sd	s2,16(sp)
    80002ed2:	e44e                	sd	s3,8(sp)
    80002ed4:	e052                	sd	s4,0(sp)
    80002ed6:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002ed8:	00005597          	auipc	a1,0x5
    80002edc:	52058593          	addi	a1,a1,1312 # 800083f8 <etext+0x3f8>
    80002ee0:	00016517          	auipc	a0,0x16
    80002ee4:	43850513          	addi	a0,a0,1080 # 80019318 <bcache>
    80002ee8:	ffffe097          	auipc	ra,0xffffe
    80002eec:	cd8080e7          	jalr	-808(ra) # 80000bc0 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002ef0:	0001e797          	auipc	a5,0x1e
    80002ef4:	42878793          	addi	a5,a5,1064 # 80021318 <bcache+0x8000>
    80002ef8:	0001e717          	auipc	a4,0x1e
    80002efc:	68870713          	addi	a4,a4,1672 # 80021580 <bcache+0x8268>
    80002f00:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002f04:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002f08:	00016497          	auipc	s1,0x16
    80002f0c:	42848493          	addi	s1,s1,1064 # 80019330 <bcache+0x18>
    b->next = bcache.head.next;
    80002f10:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002f12:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002f14:	00005a17          	auipc	s4,0x5
    80002f18:	4eca0a13          	addi	s4,s4,1260 # 80008400 <etext+0x400>
    b->next = bcache.head.next;
    80002f1c:	2b893783          	ld	a5,696(s2)
    80002f20:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002f22:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002f26:	85d2                	mv	a1,s4
    80002f28:	01048513          	addi	a0,s1,16
    80002f2c:	00001097          	auipc	ra,0x1
    80002f30:	4e8080e7          	jalr	1256(ra) # 80004414 <initsleeplock>
    bcache.head.next->prev = b;
    80002f34:	2b893783          	ld	a5,696(s2)
    80002f38:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002f3a:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002f3e:	45848493          	addi	s1,s1,1112
    80002f42:	fd349de3          	bne	s1,s3,80002f1c <binit+0x54>
  }
}
    80002f46:	70a2                	ld	ra,40(sp)
    80002f48:	7402                	ld	s0,32(sp)
    80002f4a:	64e2                	ld	s1,24(sp)
    80002f4c:	6942                	ld	s2,16(sp)
    80002f4e:	69a2                	ld	s3,8(sp)
    80002f50:	6a02                	ld	s4,0(sp)
    80002f52:	6145                	addi	sp,sp,48
    80002f54:	8082                	ret

0000000080002f56 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002f56:	7179                	addi	sp,sp,-48
    80002f58:	f406                	sd	ra,40(sp)
    80002f5a:	f022                	sd	s0,32(sp)
    80002f5c:	ec26                	sd	s1,24(sp)
    80002f5e:	e84a                	sd	s2,16(sp)
    80002f60:	e44e                	sd	s3,8(sp)
    80002f62:	1800                	addi	s0,sp,48
    80002f64:	892a                	mv	s2,a0
    80002f66:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002f68:	00016517          	auipc	a0,0x16
    80002f6c:	3b050513          	addi	a0,a0,944 # 80019318 <bcache>
    80002f70:	ffffe097          	auipc	ra,0xffffe
    80002f74:	ce0080e7          	jalr	-800(ra) # 80000c50 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002f78:	0001e497          	auipc	s1,0x1e
    80002f7c:	6584b483          	ld	s1,1624(s1) # 800215d0 <bcache+0x82b8>
    80002f80:	0001e797          	auipc	a5,0x1e
    80002f84:	60078793          	addi	a5,a5,1536 # 80021580 <bcache+0x8268>
    80002f88:	02f48f63          	beq	s1,a5,80002fc6 <bread+0x70>
    80002f8c:	873e                	mv	a4,a5
    80002f8e:	a021                	j	80002f96 <bread+0x40>
    80002f90:	68a4                	ld	s1,80(s1)
    80002f92:	02e48a63          	beq	s1,a4,80002fc6 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002f96:	449c                	lw	a5,8(s1)
    80002f98:	ff279ce3          	bne	a5,s2,80002f90 <bread+0x3a>
    80002f9c:	44dc                	lw	a5,12(s1)
    80002f9e:	ff3799e3          	bne	a5,s3,80002f90 <bread+0x3a>
      b->refcnt++;
    80002fa2:	40bc                	lw	a5,64(s1)
    80002fa4:	2785                	addiw	a5,a5,1
    80002fa6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002fa8:	00016517          	auipc	a0,0x16
    80002fac:	37050513          	addi	a0,a0,880 # 80019318 <bcache>
    80002fb0:	ffffe097          	auipc	ra,0xffffe
    80002fb4:	d54080e7          	jalr	-684(ra) # 80000d04 <release>
      acquiresleep(&b->lock);
    80002fb8:	01048513          	addi	a0,s1,16
    80002fbc:	00001097          	auipc	ra,0x1
    80002fc0:	492080e7          	jalr	1170(ra) # 8000444e <acquiresleep>
      return b;
    80002fc4:	a8b9                	j	80003022 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002fc6:	0001e497          	auipc	s1,0x1e
    80002fca:	6024b483          	ld	s1,1538(s1) # 800215c8 <bcache+0x82b0>
    80002fce:	0001e797          	auipc	a5,0x1e
    80002fd2:	5b278793          	addi	a5,a5,1458 # 80021580 <bcache+0x8268>
    80002fd6:	00f48863          	beq	s1,a5,80002fe6 <bread+0x90>
    80002fda:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002fdc:	40bc                	lw	a5,64(s1)
    80002fde:	cf81                	beqz	a5,80002ff6 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002fe0:	64a4                	ld	s1,72(s1)
    80002fe2:	fee49de3          	bne	s1,a4,80002fdc <bread+0x86>
  panic("bget: no buffers");
    80002fe6:	00005517          	auipc	a0,0x5
    80002fea:	42250513          	addi	a0,a0,1058 # 80008408 <etext+0x408>
    80002fee:	ffffd097          	auipc	ra,0xffffd
    80002ff2:	572080e7          	jalr	1394(ra) # 80000560 <panic>
      b->dev = dev;
    80002ff6:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002ffa:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002ffe:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003002:	4785                	li	a5,1
    80003004:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003006:	00016517          	auipc	a0,0x16
    8000300a:	31250513          	addi	a0,a0,786 # 80019318 <bcache>
    8000300e:	ffffe097          	auipc	ra,0xffffe
    80003012:	cf6080e7          	jalr	-778(ra) # 80000d04 <release>
      acquiresleep(&b->lock);
    80003016:	01048513          	addi	a0,s1,16
    8000301a:	00001097          	auipc	ra,0x1
    8000301e:	434080e7          	jalr	1076(ra) # 8000444e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003022:	409c                	lw	a5,0(s1)
    80003024:	cb89                	beqz	a5,80003036 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003026:	8526                	mv	a0,s1
    80003028:	70a2                	ld	ra,40(sp)
    8000302a:	7402                	ld	s0,32(sp)
    8000302c:	64e2                	ld	s1,24(sp)
    8000302e:	6942                	ld	s2,16(sp)
    80003030:	69a2                	ld	s3,8(sp)
    80003032:	6145                	addi	sp,sp,48
    80003034:	8082                	ret
    virtio_disk_rw(b, 0);
    80003036:	4581                	li	a1,0
    80003038:	8526                	mv	a0,s1
    8000303a:	00003097          	auipc	ra,0x3
    8000303e:	0ee080e7          	jalr	238(ra) # 80006128 <virtio_disk_rw>
    b->valid = 1;
    80003042:	4785                	li	a5,1
    80003044:	c09c                	sw	a5,0(s1)
  return b;
    80003046:	b7c5                	j	80003026 <bread+0xd0>

0000000080003048 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003048:	1101                	addi	sp,sp,-32
    8000304a:	ec06                	sd	ra,24(sp)
    8000304c:	e822                	sd	s0,16(sp)
    8000304e:	e426                	sd	s1,8(sp)
    80003050:	1000                	addi	s0,sp,32
    80003052:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003054:	0541                	addi	a0,a0,16
    80003056:	00001097          	auipc	ra,0x1
    8000305a:	492080e7          	jalr	1170(ra) # 800044e8 <holdingsleep>
    8000305e:	cd01                	beqz	a0,80003076 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003060:	4585                	li	a1,1
    80003062:	8526                	mv	a0,s1
    80003064:	00003097          	auipc	ra,0x3
    80003068:	0c4080e7          	jalr	196(ra) # 80006128 <virtio_disk_rw>
}
    8000306c:	60e2                	ld	ra,24(sp)
    8000306e:	6442                	ld	s0,16(sp)
    80003070:	64a2                	ld	s1,8(sp)
    80003072:	6105                	addi	sp,sp,32
    80003074:	8082                	ret
    panic("bwrite");
    80003076:	00005517          	auipc	a0,0x5
    8000307a:	3aa50513          	addi	a0,a0,938 # 80008420 <etext+0x420>
    8000307e:	ffffd097          	auipc	ra,0xffffd
    80003082:	4e2080e7          	jalr	1250(ra) # 80000560 <panic>

0000000080003086 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003086:	1101                	addi	sp,sp,-32
    80003088:	ec06                	sd	ra,24(sp)
    8000308a:	e822                	sd	s0,16(sp)
    8000308c:	e426                	sd	s1,8(sp)
    8000308e:	e04a                	sd	s2,0(sp)
    80003090:	1000                	addi	s0,sp,32
    80003092:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003094:	01050913          	addi	s2,a0,16
    80003098:	854a                	mv	a0,s2
    8000309a:	00001097          	auipc	ra,0x1
    8000309e:	44e080e7          	jalr	1102(ra) # 800044e8 <holdingsleep>
    800030a2:	c925                	beqz	a0,80003112 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    800030a4:	854a                	mv	a0,s2
    800030a6:	00001097          	auipc	ra,0x1
    800030aa:	3fe080e7          	jalr	1022(ra) # 800044a4 <releasesleep>

  acquire(&bcache.lock);
    800030ae:	00016517          	auipc	a0,0x16
    800030b2:	26a50513          	addi	a0,a0,618 # 80019318 <bcache>
    800030b6:	ffffe097          	auipc	ra,0xffffe
    800030ba:	b9a080e7          	jalr	-1126(ra) # 80000c50 <acquire>
  b->refcnt--;
    800030be:	40bc                	lw	a5,64(s1)
    800030c0:	37fd                	addiw	a5,a5,-1
    800030c2:	0007871b          	sext.w	a4,a5
    800030c6:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800030c8:	e71d                	bnez	a4,800030f6 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800030ca:	68b8                	ld	a4,80(s1)
    800030cc:	64bc                	ld	a5,72(s1)
    800030ce:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800030d0:	68b8                	ld	a4,80(s1)
    800030d2:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800030d4:	0001e797          	auipc	a5,0x1e
    800030d8:	24478793          	addi	a5,a5,580 # 80021318 <bcache+0x8000>
    800030dc:	2b87b703          	ld	a4,696(a5)
    800030e0:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800030e2:	0001e717          	auipc	a4,0x1e
    800030e6:	49e70713          	addi	a4,a4,1182 # 80021580 <bcache+0x8268>
    800030ea:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800030ec:	2b87b703          	ld	a4,696(a5)
    800030f0:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800030f2:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800030f6:	00016517          	auipc	a0,0x16
    800030fa:	22250513          	addi	a0,a0,546 # 80019318 <bcache>
    800030fe:	ffffe097          	auipc	ra,0xffffe
    80003102:	c06080e7          	jalr	-1018(ra) # 80000d04 <release>
}
    80003106:	60e2                	ld	ra,24(sp)
    80003108:	6442                	ld	s0,16(sp)
    8000310a:	64a2                	ld	s1,8(sp)
    8000310c:	6902                	ld	s2,0(sp)
    8000310e:	6105                	addi	sp,sp,32
    80003110:	8082                	ret
    panic("brelse");
    80003112:	00005517          	auipc	a0,0x5
    80003116:	31650513          	addi	a0,a0,790 # 80008428 <etext+0x428>
    8000311a:	ffffd097          	auipc	ra,0xffffd
    8000311e:	446080e7          	jalr	1094(ra) # 80000560 <panic>

0000000080003122 <bpin>:

void
bpin(struct buf *b) {
    80003122:	1101                	addi	sp,sp,-32
    80003124:	ec06                	sd	ra,24(sp)
    80003126:	e822                	sd	s0,16(sp)
    80003128:	e426                	sd	s1,8(sp)
    8000312a:	1000                	addi	s0,sp,32
    8000312c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000312e:	00016517          	auipc	a0,0x16
    80003132:	1ea50513          	addi	a0,a0,490 # 80019318 <bcache>
    80003136:	ffffe097          	auipc	ra,0xffffe
    8000313a:	b1a080e7          	jalr	-1254(ra) # 80000c50 <acquire>
  b->refcnt++;
    8000313e:	40bc                	lw	a5,64(s1)
    80003140:	2785                	addiw	a5,a5,1
    80003142:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003144:	00016517          	auipc	a0,0x16
    80003148:	1d450513          	addi	a0,a0,468 # 80019318 <bcache>
    8000314c:	ffffe097          	auipc	ra,0xffffe
    80003150:	bb8080e7          	jalr	-1096(ra) # 80000d04 <release>
}
    80003154:	60e2                	ld	ra,24(sp)
    80003156:	6442                	ld	s0,16(sp)
    80003158:	64a2                	ld	s1,8(sp)
    8000315a:	6105                	addi	sp,sp,32
    8000315c:	8082                	ret

000000008000315e <bunpin>:

void
bunpin(struct buf *b) {
    8000315e:	1101                	addi	sp,sp,-32
    80003160:	ec06                	sd	ra,24(sp)
    80003162:	e822                	sd	s0,16(sp)
    80003164:	e426                	sd	s1,8(sp)
    80003166:	1000                	addi	s0,sp,32
    80003168:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000316a:	00016517          	auipc	a0,0x16
    8000316e:	1ae50513          	addi	a0,a0,430 # 80019318 <bcache>
    80003172:	ffffe097          	auipc	ra,0xffffe
    80003176:	ade080e7          	jalr	-1314(ra) # 80000c50 <acquire>
  b->refcnt--;
    8000317a:	40bc                	lw	a5,64(s1)
    8000317c:	37fd                	addiw	a5,a5,-1
    8000317e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003180:	00016517          	auipc	a0,0x16
    80003184:	19850513          	addi	a0,a0,408 # 80019318 <bcache>
    80003188:	ffffe097          	auipc	ra,0xffffe
    8000318c:	b7c080e7          	jalr	-1156(ra) # 80000d04 <release>
}
    80003190:	60e2                	ld	ra,24(sp)
    80003192:	6442                	ld	s0,16(sp)
    80003194:	64a2                	ld	s1,8(sp)
    80003196:	6105                	addi	sp,sp,32
    80003198:	8082                	ret

000000008000319a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000319a:	1101                	addi	sp,sp,-32
    8000319c:	ec06                	sd	ra,24(sp)
    8000319e:	e822                	sd	s0,16(sp)
    800031a0:	e426                	sd	s1,8(sp)
    800031a2:	e04a                	sd	s2,0(sp)
    800031a4:	1000                	addi	s0,sp,32
    800031a6:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800031a8:	00d5d59b          	srliw	a1,a1,0xd
    800031ac:	0001f797          	auipc	a5,0x1f
    800031b0:	8487a783          	lw	a5,-1976(a5) # 800219f4 <sb+0x1c>
    800031b4:	9dbd                	addw	a1,a1,a5
    800031b6:	00000097          	auipc	ra,0x0
    800031ba:	da0080e7          	jalr	-608(ra) # 80002f56 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800031be:	0074f713          	andi	a4,s1,7
    800031c2:	4785                	li	a5,1
    800031c4:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800031c8:	14ce                	slli	s1,s1,0x33
    800031ca:	90d9                	srli	s1,s1,0x36
    800031cc:	00950733          	add	a4,a0,s1
    800031d0:	05874703          	lbu	a4,88(a4)
    800031d4:	00e7f6b3          	and	a3,a5,a4
    800031d8:	c69d                	beqz	a3,80003206 <bfree+0x6c>
    800031da:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800031dc:	94aa                	add	s1,s1,a0
    800031de:	fff7c793          	not	a5,a5
    800031e2:	8f7d                	and	a4,a4,a5
    800031e4:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800031e8:	00001097          	auipc	ra,0x1
    800031ec:	148080e7          	jalr	328(ra) # 80004330 <log_write>
  brelse(bp);
    800031f0:	854a                	mv	a0,s2
    800031f2:	00000097          	auipc	ra,0x0
    800031f6:	e94080e7          	jalr	-364(ra) # 80003086 <brelse>
}
    800031fa:	60e2                	ld	ra,24(sp)
    800031fc:	6442                	ld	s0,16(sp)
    800031fe:	64a2                	ld	s1,8(sp)
    80003200:	6902                	ld	s2,0(sp)
    80003202:	6105                	addi	sp,sp,32
    80003204:	8082                	ret
    panic("freeing free block");
    80003206:	00005517          	auipc	a0,0x5
    8000320a:	22a50513          	addi	a0,a0,554 # 80008430 <etext+0x430>
    8000320e:	ffffd097          	auipc	ra,0xffffd
    80003212:	352080e7          	jalr	850(ra) # 80000560 <panic>

0000000080003216 <balloc>:
{
    80003216:	711d                	addi	sp,sp,-96
    80003218:	ec86                	sd	ra,88(sp)
    8000321a:	e8a2                	sd	s0,80(sp)
    8000321c:	e4a6                	sd	s1,72(sp)
    8000321e:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003220:	0001e797          	auipc	a5,0x1e
    80003224:	7bc7a783          	lw	a5,1980(a5) # 800219dc <sb+0x4>
    80003228:	10078f63          	beqz	a5,80003346 <balloc+0x130>
    8000322c:	e0ca                	sd	s2,64(sp)
    8000322e:	fc4e                	sd	s3,56(sp)
    80003230:	f852                	sd	s4,48(sp)
    80003232:	f456                	sd	s5,40(sp)
    80003234:	f05a                	sd	s6,32(sp)
    80003236:	ec5e                	sd	s7,24(sp)
    80003238:	e862                	sd	s8,16(sp)
    8000323a:	e466                	sd	s9,8(sp)
    8000323c:	8baa                	mv	s7,a0
    8000323e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003240:	0001eb17          	auipc	s6,0x1e
    80003244:	798b0b13          	addi	s6,s6,1944 # 800219d8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003248:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000324a:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000324c:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000324e:	6c89                	lui	s9,0x2
    80003250:	a061                	j	800032d8 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003252:	97ca                	add	a5,a5,s2
    80003254:	8e55                	or	a2,a2,a3
    80003256:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000325a:	854a                	mv	a0,s2
    8000325c:	00001097          	auipc	ra,0x1
    80003260:	0d4080e7          	jalr	212(ra) # 80004330 <log_write>
        brelse(bp);
    80003264:	854a                	mv	a0,s2
    80003266:	00000097          	auipc	ra,0x0
    8000326a:	e20080e7          	jalr	-480(ra) # 80003086 <brelse>
  bp = bread(dev, bno);
    8000326e:	85a6                	mv	a1,s1
    80003270:	855e                	mv	a0,s7
    80003272:	00000097          	auipc	ra,0x0
    80003276:	ce4080e7          	jalr	-796(ra) # 80002f56 <bread>
    8000327a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000327c:	40000613          	li	a2,1024
    80003280:	4581                	li	a1,0
    80003282:	05850513          	addi	a0,a0,88
    80003286:	ffffe097          	auipc	ra,0xffffe
    8000328a:	ac6080e7          	jalr	-1338(ra) # 80000d4c <memset>
  log_write(bp);
    8000328e:	854a                	mv	a0,s2
    80003290:	00001097          	auipc	ra,0x1
    80003294:	0a0080e7          	jalr	160(ra) # 80004330 <log_write>
  brelse(bp);
    80003298:	854a                	mv	a0,s2
    8000329a:	00000097          	auipc	ra,0x0
    8000329e:	dec080e7          	jalr	-532(ra) # 80003086 <brelse>
}
    800032a2:	6906                	ld	s2,64(sp)
    800032a4:	79e2                	ld	s3,56(sp)
    800032a6:	7a42                	ld	s4,48(sp)
    800032a8:	7aa2                	ld	s5,40(sp)
    800032aa:	7b02                	ld	s6,32(sp)
    800032ac:	6be2                	ld	s7,24(sp)
    800032ae:	6c42                	ld	s8,16(sp)
    800032b0:	6ca2                	ld	s9,8(sp)
}
    800032b2:	8526                	mv	a0,s1
    800032b4:	60e6                	ld	ra,88(sp)
    800032b6:	6446                	ld	s0,80(sp)
    800032b8:	64a6                	ld	s1,72(sp)
    800032ba:	6125                	addi	sp,sp,96
    800032bc:	8082                	ret
    brelse(bp);
    800032be:	854a                	mv	a0,s2
    800032c0:	00000097          	auipc	ra,0x0
    800032c4:	dc6080e7          	jalr	-570(ra) # 80003086 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800032c8:	015c87bb          	addw	a5,s9,s5
    800032cc:	00078a9b          	sext.w	s5,a5
    800032d0:	004b2703          	lw	a4,4(s6)
    800032d4:	06eaf163          	bgeu	s5,a4,80003336 <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
    800032d8:	41fad79b          	sraiw	a5,s5,0x1f
    800032dc:	0137d79b          	srliw	a5,a5,0x13
    800032e0:	015787bb          	addw	a5,a5,s5
    800032e4:	40d7d79b          	sraiw	a5,a5,0xd
    800032e8:	01cb2583          	lw	a1,28(s6)
    800032ec:	9dbd                	addw	a1,a1,a5
    800032ee:	855e                	mv	a0,s7
    800032f0:	00000097          	auipc	ra,0x0
    800032f4:	c66080e7          	jalr	-922(ra) # 80002f56 <bread>
    800032f8:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800032fa:	004b2503          	lw	a0,4(s6)
    800032fe:	000a849b          	sext.w	s1,s5
    80003302:	8762                	mv	a4,s8
    80003304:	faa4fde3          	bgeu	s1,a0,800032be <balloc+0xa8>
      m = 1 << (bi % 8);
    80003308:	00777693          	andi	a3,a4,7
    8000330c:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003310:	41f7579b          	sraiw	a5,a4,0x1f
    80003314:	01d7d79b          	srliw	a5,a5,0x1d
    80003318:	9fb9                	addw	a5,a5,a4
    8000331a:	4037d79b          	sraiw	a5,a5,0x3
    8000331e:	00f90633          	add	a2,s2,a5
    80003322:	05864603          	lbu	a2,88(a2)
    80003326:	00c6f5b3          	and	a1,a3,a2
    8000332a:	d585                	beqz	a1,80003252 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000332c:	2705                	addiw	a4,a4,1
    8000332e:	2485                	addiw	s1,s1,1
    80003330:	fd471ae3          	bne	a4,s4,80003304 <balloc+0xee>
    80003334:	b769                	j	800032be <balloc+0xa8>
    80003336:	6906                	ld	s2,64(sp)
    80003338:	79e2                	ld	s3,56(sp)
    8000333a:	7a42                	ld	s4,48(sp)
    8000333c:	7aa2                	ld	s5,40(sp)
    8000333e:	7b02                	ld	s6,32(sp)
    80003340:	6be2                	ld	s7,24(sp)
    80003342:	6c42                	ld	s8,16(sp)
    80003344:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80003346:	00005517          	auipc	a0,0x5
    8000334a:	10250513          	addi	a0,a0,258 # 80008448 <etext+0x448>
    8000334e:	ffffd097          	auipc	ra,0xffffd
    80003352:	25c080e7          	jalr	604(ra) # 800005aa <printf>
  return 0;
    80003356:	4481                	li	s1,0
    80003358:	bfa9                	j	800032b2 <balloc+0x9c>

000000008000335a <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000335a:	7179                	addi	sp,sp,-48
    8000335c:	f406                	sd	ra,40(sp)
    8000335e:	f022                	sd	s0,32(sp)
    80003360:	ec26                	sd	s1,24(sp)
    80003362:	e84a                	sd	s2,16(sp)
    80003364:	e44e                	sd	s3,8(sp)
    80003366:	1800                	addi	s0,sp,48
    80003368:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000336a:	47ad                	li	a5,11
    8000336c:	02b7e863          	bltu	a5,a1,8000339c <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80003370:	02059793          	slli	a5,a1,0x20
    80003374:	01e7d593          	srli	a1,a5,0x1e
    80003378:	00b504b3          	add	s1,a0,a1
    8000337c:	0504a903          	lw	s2,80(s1)
    80003380:	08091263          	bnez	s2,80003404 <bmap+0xaa>
      addr = balloc(ip->dev);
    80003384:	4108                	lw	a0,0(a0)
    80003386:	00000097          	auipc	ra,0x0
    8000338a:	e90080e7          	jalr	-368(ra) # 80003216 <balloc>
    8000338e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003392:	06090963          	beqz	s2,80003404 <bmap+0xaa>
        return 0;
      ip->addrs[bn] = addr;
    80003396:	0524a823          	sw	s2,80(s1)
    8000339a:	a0ad                	j	80003404 <bmap+0xaa>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000339c:	ff45849b          	addiw	s1,a1,-12
    800033a0:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800033a4:	0ff00793          	li	a5,255
    800033a8:	08e7e863          	bltu	a5,a4,80003438 <bmap+0xde>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800033ac:	08052903          	lw	s2,128(a0)
    800033b0:	00091f63          	bnez	s2,800033ce <bmap+0x74>
      addr = balloc(ip->dev);
    800033b4:	4108                	lw	a0,0(a0)
    800033b6:	00000097          	auipc	ra,0x0
    800033ba:	e60080e7          	jalr	-416(ra) # 80003216 <balloc>
    800033be:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800033c2:	04090163          	beqz	s2,80003404 <bmap+0xaa>
    800033c6:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800033c8:	0929a023          	sw	s2,128(s3)
    800033cc:	a011                	j	800033d0 <bmap+0x76>
    800033ce:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800033d0:	85ca                	mv	a1,s2
    800033d2:	0009a503          	lw	a0,0(s3)
    800033d6:	00000097          	auipc	ra,0x0
    800033da:	b80080e7          	jalr	-1152(ra) # 80002f56 <bread>
    800033de:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800033e0:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800033e4:	02049713          	slli	a4,s1,0x20
    800033e8:	01e75593          	srli	a1,a4,0x1e
    800033ec:	00b784b3          	add	s1,a5,a1
    800033f0:	0004a903          	lw	s2,0(s1)
    800033f4:	02090063          	beqz	s2,80003414 <bmap+0xba>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800033f8:	8552                	mv	a0,s4
    800033fa:	00000097          	auipc	ra,0x0
    800033fe:	c8c080e7          	jalr	-884(ra) # 80003086 <brelse>
    return addr;
    80003402:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003404:	854a                	mv	a0,s2
    80003406:	70a2                	ld	ra,40(sp)
    80003408:	7402                	ld	s0,32(sp)
    8000340a:	64e2                	ld	s1,24(sp)
    8000340c:	6942                	ld	s2,16(sp)
    8000340e:	69a2                	ld	s3,8(sp)
    80003410:	6145                	addi	sp,sp,48
    80003412:	8082                	ret
      addr = balloc(ip->dev);
    80003414:	0009a503          	lw	a0,0(s3)
    80003418:	00000097          	auipc	ra,0x0
    8000341c:	dfe080e7          	jalr	-514(ra) # 80003216 <balloc>
    80003420:	0005091b          	sext.w	s2,a0
      if(addr){
    80003424:	fc090ae3          	beqz	s2,800033f8 <bmap+0x9e>
        a[bn] = addr;
    80003428:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000342c:	8552                	mv	a0,s4
    8000342e:	00001097          	auipc	ra,0x1
    80003432:	f02080e7          	jalr	-254(ra) # 80004330 <log_write>
    80003436:	b7c9                	j	800033f8 <bmap+0x9e>
    80003438:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    8000343a:	00005517          	auipc	a0,0x5
    8000343e:	02650513          	addi	a0,a0,38 # 80008460 <etext+0x460>
    80003442:	ffffd097          	auipc	ra,0xffffd
    80003446:	11e080e7          	jalr	286(ra) # 80000560 <panic>

000000008000344a <iget>:
{
    8000344a:	7179                	addi	sp,sp,-48
    8000344c:	f406                	sd	ra,40(sp)
    8000344e:	f022                	sd	s0,32(sp)
    80003450:	ec26                	sd	s1,24(sp)
    80003452:	e84a                	sd	s2,16(sp)
    80003454:	e44e                	sd	s3,8(sp)
    80003456:	e052                	sd	s4,0(sp)
    80003458:	1800                	addi	s0,sp,48
    8000345a:	89aa                	mv	s3,a0
    8000345c:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000345e:	0001e517          	auipc	a0,0x1e
    80003462:	59a50513          	addi	a0,a0,1434 # 800219f8 <itable>
    80003466:	ffffd097          	auipc	ra,0xffffd
    8000346a:	7ea080e7          	jalr	2026(ra) # 80000c50 <acquire>
  empty = 0;
    8000346e:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003470:	0001e497          	auipc	s1,0x1e
    80003474:	5a048493          	addi	s1,s1,1440 # 80021a10 <itable+0x18>
    80003478:	00020697          	auipc	a3,0x20
    8000347c:	02868693          	addi	a3,a3,40 # 800234a0 <log>
    80003480:	a039                	j	8000348e <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003482:	02090b63          	beqz	s2,800034b8 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003486:	08848493          	addi	s1,s1,136
    8000348a:	02d48a63          	beq	s1,a3,800034be <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000348e:	449c                	lw	a5,8(s1)
    80003490:	fef059e3          	blez	a5,80003482 <iget+0x38>
    80003494:	4098                	lw	a4,0(s1)
    80003496:	ff3716e3          	bne	a4,s3,80003482 <iget+0x38>
    8000349a:	40d8                	lw	a4,4(s1)
    8000349c:	ff4713e3          	bne	a4,s4,80003482 <iget+0x38>
      ip->ref++;
    800034a0:	2785                	addiw	a5,a5,1
    800034a2:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800034a4:	0001e517          	auipc	a0,0x1e
    800034a8:	55450513          	addi	a0,a0,1364 # 800219f8 <itable>
    800034ac:	ffffe097          	auipc	ra,0xffffe
    800034b0:	858080e7          	jalr	-1960(ra) # 80000d04 <release>
      return ip;
    800034b4:	8926                	mv	s2,s1
    800034b6:	a03d                	j	800034e4 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800034b8:	f7f9                	bnez	a5,80003486 <iget+0x3c>
      empty = ip;
    800034ba:	8926                	mv	s2,s1
    800034bc:	b7e9                	j	80003486 <iget+0x3c>
  if(empty == 0)
    800034be:	02090c63          	beqz	s2,800034f6 <iget+0xac>
  ip->dev = dev;
    800034c2:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800034c6:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800034ca:	4785                	li	a5,1
    800034cc:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800034d0:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800034d4:	0001e517          	auipc	a0,0x1e
    800034d8:	52450513          	addi	a0,a0,1316 # 800219f8 <itable>
    800034dc:	ffffe097          	auipc	ra,0xffffe
    800034e0:	828080e7          	jalr	-2008(ra) # 80000d04 <release>
}
    800034e4:	854a                	mv	a0,s2
    800034e6:	70a2                	ld	ra,40(sp)
    800034e8:	7402                	ld	s0,32(sp)
    800034ea:	64e2                	ld	s1,24(sp)
    800034ec:	6942                	ld	s2,16(sp)
    800034ee:	69a2                	ld	s3,8(sp)
    800034f0:	6a02                	ld	s4,0(sp)
    800034f2:	6145                	addi	sp,sp,48
    800034f4:	8082                	ret
    panic("iget: no inodes");
    800034f6:	00005517          	auipc	a0,0x5
    800034fa:	f8250513          	addi	a0,a0,-126 # 80008478 <etext+0x478>
    800034fe:	ffffd097          	auipc	ra,0xffffd
    80003502:	062080e7          	jalr	98(ra) # 80000560 <panic>

0000000080003506 <fsinit>:
fsinit(int dev) {
    80003506:	7179                	addi	sp,sp,-48
    80003508:	f406                	sd	ra,40(sp)
    8000350a:	f022                	sd	s0,32(sp)
    8000350c:	ec26                	sd	s1,24(sp)
    8000350e:	e84a                	sd	s2,16(sp)
    80003510:	e44e                	sd	s3,8(sp)
    80003512:	1800                	addi	s0,sp,48
    80003514:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003516:	4585                	li	a1,1
    80003518:	00000097          	auipc	ra,0x0
    8000351c:	a3e080e7          	jalr	-1474(ra) # 80002f56 <bread>
    80003520:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003522:	0001e997          	auipc	s3,0x1e
    80003526:	4b698993          	addi	s3,s3,1206 # 800219d8 <sb>
    8000352a:	02000613          	li	a2,32
    8000352e:	05850593          	addi	a1,a0,88
    80003532:	854e                	mv	a0,s3
    80003534:	ffffe097          	auipc	ra,0xffffe
    80003538:	874080e7          	jalr	-1932(ra) # 80000da8 <memmove>
  brelse(bp);
    8000353c:	8526                	mv	a0,s1
    8000353e:	00000097          	auipc	ra,0x0
    80003542:	b48080e7          	jalr	-1208(ra) # 80003086 <brelse>
  if(sb.magic != FSMAGIC)
    80003546:	0009a703          	lw	a4,0(s3)
    8000354a:	102037b7          	lui	a5,0x10203
    8000354e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003552:	02f71263          	bne	a4,a5,80003576 <fsinit+0x70>
  initlog(dev, &sb);
    80003556:	0001e597          	auipc	a1,0x1e
    8000355a:	48258593          	addi	a1,a1,1154 # 800219d8 <sb>
    8000355e:	854a                	mv	a0,s2
    80003560:	00001097          	auipc	ra,0x1
    80003564:	b60080e7          	jalr	-1184(ra) # 800040c0 <initlog>
}
    80003568:	70a2                	ld	ra,40(sp)
    8000356a:	7402                	ld	s0,32(sp)
    8000356c:	64e2                	ld	s1,24(sp)
    8000356e:	6942                	ld	s2,16(sp)
    80003570:	69a2                	ld	s3,8(sp)
    80003572:	6145                	addi	sp,sp,48
    80003574:	8082                	ret
    panic("invalid file system");
    80003576:	00005517          	auipc	a0,0x5
    8000357a:	f1250513          	addi	a0,a0,-238 # 80008488 <etext+0x488>
    8000357e:	ffffd097          	auipc	ra,0xffffd
    80003582:	fe2080e7          	jalr	-30(ra) # 80000560 <panic>

0000000080003586 <iinit>:
{
    80003586:	7179                	addi	sp,sp,-48
    80003588:	f406                	sd	ra,40(sp)
    8000358a:	f022                	sd	s0,32(sp)
    8000358c:	ec26                	sd	s1,24(sp)
    8000358e:	e84a                	sd	s2,16(sp)
    80003590:	e44e                	sd	s3,8(sp)
    80003592:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003594:	00005597          	auipc	a1,0x5
    80003598:	f0c58593          	addi	a1,a1,-244 # 800084a0 <etext+0x4a0>
    8000359c:	0001e517          	auipc	a0,0x1e
    800035a0:	45c50513          	addi	a0,a0,1116 # 800219f8 <itable>
    800035a4:	ffffd097          	auipc	ra,0xffffd
    800035a8:	61c080e7          	jalr	1564(ra) # 80000bc0 <initlock>
  for(i = 0; i < NINODE; i++) {
    800035ac:	0001e497          	auipc	s1,0x1e
    800035b0:	47448493          	addi	s1,s1,1140 # 80021a20 <itable+0x28>
    800035b4:	00020997          	auipc	s3,0x20
    800035b8:	efc98993          	addi	s3,s3,-260 # 800234b0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800035bc:	00005917          	auipc	s2,0x5
    800035c0:	eec90913          	addi	s2,s2,-276 # 800084a8 <etext+0x4a8>
    800035c4:	85ca                	mv	a1,s2
    800035c6:	8526                	mv	a0,s1
    800035c8:	00001097          	auipc	ra,0x1
    800035cc:	e4c080e7          	jalr	-436(ra) # 80004414 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800035d0:	08848493          	addi	s1,s1,136
    800035d4:	ff3498e3          	bne	s1,s3,800035c4 <iinit+0x3e>
}
    800035d8:	70a2                	ld	ra,40(sp)
    800035da:	7402                	ld	s0,32(sp)
    800035dc:	64e2                	ld	s1,24(sp)
    800035de:	6942                	ld	s2,16(sp)
    800035e0:	69a2                	ld	s3,8(sp)
    800035e2:	6145                	addi	sp,sp,48
    800035e4:	8082                	ret

00000000800035e6 <ialloc>:
{
    800035e6:	7139                	addi	sp,sp,-64
    800035e8:	fc06                	sd	ra,56(sp)
    800035ea:	f822                	sd	s0,48(sp)
    800035ec:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800035ee:	0001e717          	auipc	a4,0x1e
    800035f2:	3f672703          	lw	a4,1014(a4) # 800219e4 <sb+0xc>
    800035f6:	4785                	li	a5,1
    800035f8:	06e7f463          	bgeu	a5,a4,80003660 <ialloc+0x7a>
    800035fc:	f426                	sd	s1,40(sp)
    800035fe:	f04a                	sd	s2,32(sp)
    80003600:	ec4e                	sd	s3,24(sp)
    80003602:	e852                	sd	s4,16(sp)
    80003604:	e456                	sd	s5,8(sp)
    80003606:	e05a                	sd	s6,0(sp)
    80003608:	8aaa                	mv	s5,a0
    8000360a:	8b2e                	mv	s6,a1
    8000360c:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000360e:	0001ea17          	auipc	s4,0x1e
    80003612:	3caa0a13          	addi	s4,s4,970 # 800219d8 <sb>
    80003616:	00495593          	srli	a1,s2,0x4
    8000361a:	018a2783          	lw	a5,24(s4)
    8000361e:	9dbd                	addw	a1,a1,a5
    80003620:	8556                	mv	a0,s5
    80003622:	00000097          	auipc	ra,0x0
    80003626:	934080e7          	jalr	-1740(ra) # 80002f56 <bread>
    8000362a:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000362c:	05850993          	addi	s3,a0,88
    80003630:	00f97793          	andi	a5,s2,15
    80003634:	079a                	slli	a5,a5,0x6
    80003636:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003638:	00099783          	lh	a5,0(s3)
    8000363c:	cf9d                	beqz	a5,8000367a <ialloc+0x94>
    brelse(bp);
    8000363e:	00000097          	auipc	ra,0x0
    80003642:	a48080e7          	jalr	-1464(ra) # 80003086 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003646:	0905                	addi	s2,s2,1
    80003648:	00ca2703          	lw	a4,12(s4)
    8000364c:	0009079b          	sext.w	a5,s2
    80003650:	fce7e3e3          	bltu	a5,a4,80003616 <ialloc+0x30>
    80003654:	74a2                	ld	s1,40(sp)
    80003656:	7902                	ld	s2,32(sp)
    80003658:	69e2                	ld	s3,24(sp)
    8000365a:	6a42                	ld	s4,16(sp)
    8000365c:	6aa2                	ld	s5,8(sp)
    8000365e:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003660:	00005517          	auipc	a0,0x5
    80003664:	e5050513          	addi	a0,a0,-432 # 800084b0 <etext+0x4b0>
    80003668:	ffffd097          	auipc	ra,0xffffd
    8000366c:	f42080e7          	jalr	-190(ra) # 800005aa <printf>
  return 0;
    80003670:	4501                	li	a0,0
}
    80003672:	70e2                	ld	ra,56(sp)
    80003674:	7442                	ld	s0,48(sp)
    80003676:	6121                	addi	sp,sp,64
    80003678:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000367a:	04000613          	li	a2,64
    8000367e:	4581                	li	a1,0
    80003680:	854e                	mv	a0,s3
    80003682:	ffffd097          	auipc	ra,0xffffd
    80003686:	6ca080e7          	jalr	1738(ra) # 80000d4c <memset>
      dip->type = type;
    8000368a:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000368e:	8526                	mv	a0,s1
    80003690:	00001097          	auipc	ra,0x1
    80003694:	ca0080e7          	jalr	-864(ra) # 80004330 <log_write>
      brelse(bp);
    80003698:	8526                	mv	a0,s1
    8000369a:	00000097          	auipc	ra,0x0
    8000369e:	9ec080e7          	jalr	-1556(ra) # 80003086 <brelse>
      return iget(dev, inum);
    800036a2:	0009059b          	sext.w	a1,s2
    800036a6:	8556                	mv	a0,s5
    800036a8:	00000097          	auipc	ra,0x0
    800036ac:	da2080e7          	jalr	-606(ra) # 8000344a <iget>
    800036b0:	74a2                	ld	s1,40(sp)
    800036b2:	7902                	ld	s2,32(sp)
    800036b4:	69e2                	ld	s3,24(sp)
    800036b6:	6a42                	ld	s4,16(sp)
    800036b8:	6aa2                	ld	s5,8(sp)
    800036ba:	6b02                	ld	s6,0(sp)
    800036bc:	bf5d                	j	80003672 <ialloc+0x8c>

00000000800036be <iupdate>:
{
    800036be:	1101                	addi	sp,sp,-32
    800036c0:	ec06                	sd	ra,24(sp)
    800036c2:	e822                	sd	s0,16(sp)
    800036c4:	e426                	sd	s1,8(sp)
    800036c6:	e04a                	sd	s2,0(sp)
    800036c8:	1000                	addi	s0,sp,32
    800036ca:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800036cc:	415c                	lw	a5,4(a0)
    800036ce:	0047d79b          	srliw	a5,a5,0x4
    800036d2:	0001e597          	auipc	a1,0x1e
    800036d6:	31e5a583          	lw	a1,798(a1) # 800219f0 <sb+0x18>
    800036da:	9dbd                	addw	a1,a1,a5
    800036dc:	4108                	lw	a0,0(a0)
    800036de:	00000097          	auipc	ra,0x0
    800036e2:	878080e7          	jalr	-1928(ra) # 80002f56 <bread>
    800036e6:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800036e8:	05850793          	addi	a5,a0,88
    800036ec:	40d8                	lw	a4,4(s1)
    800036ee:	8b3d                	andi	a4,a4,15
    800036f0:	071a                	slli	a4,a4,0x6
    800036f2:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800036f4:	04449703          	lh	a4,68(s1)
    800036f8:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800036fc:	04649703          	lh	a4,70(s1)
    80003700:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003704:	04849703          	lh	a4,72(s1)
    80003708:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    8000370c:	04a49703          	lh	a4,74(s1)
    80003710:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003714:	44f8                	lw	a4,76(s1)
    80003716:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003718:	03400613          	li	a2,52
    8000371c:	05048593          	addi	a1,s1,80
    80003720:	00c78513          	addi	a0,a5,12
    80003724:	ffffd097          	auipc	ra,0xffffd
    80003728:	684080e7          	jalr	1668(ra) # 80000da8 <memmove>
  log_write(bp);
    8000372c:	854a                	mv	a0,s2
    8000372e:	00001097          	auipc	ra,0x1
    80003732:	c02080e7          	jalr	-1022(ra) # 80004330 <log_write>
  brelse(bp);
    80003736:	854a                	mv	a0,s2
    80003738:	00000097          	auipc	ra,0x0
    8000373c:	94e080e7          	jalr	-1714(ra) # 80003086 <brelse>
}
    80003740:	60e2                	ld	ra,24(sp)
    80003742:	6442                	ld	s0,16(sp)
    80003744:	64a2                	ld	s1,8(sp)
    80003746:	6902                	ld	s2,0(sp)
    80003748:	6105                	addi	sp,sp,32
    8000374a:	8082                	ret

000000008000374c <idup>:
{
    8000374c:	1101                	addi	sp,sp,-32
    8000374e:	ec06                	sd	ra,24(sp)
    80003750:	e822                	sd	s0,16(sp)
    80003752:	e426                	sd	s1,8(sp)
    80003754:	1000                	addi	s0,sp,32
    80003756:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003758:	0001e517          	auipc	a0,0x1e
    8000375c:	2a050513          	addi	a0,a0,672 # 800219f8 <itable>
    80003760:	ffffd097          	auipc	ra,0xffffd
    80003764:	4f0080e7          	jalr	1264(ra) # 80000c50 <acquire>
  ip->ref++;
    80003768:	449c                	lw	a5,8(s1)
    8000376a:	2785                	addiw	a5,a5,1
    8000376c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000376e:	0001e517          	auipc	a0,0x1e
    80003772:	28a50513          	addi	a0,a0,650 # 800219f8 <itable>
    80003776:	ffffd097          	auipc	ra,0xffffd
    8000377a:	58e080e7          	jalr	1422(ra) # 80000d04 <release>
}
    8000377e:	8526                	mv	a0,s1
    80003780:	60e2                	ld	ra,24(sp)
    80003782:	6442                	ld	s0,16(sp)
    80003784:	64a2                	ld	s1,8(sp)
    80003786:	6105                	addi	sp,sp,32
    80003788:	8082                	ret

000000008000378a <ilock>:
{
    8000378a:	1101                	addi	sp,sp,-32
    8000378c:	ec06                	sd	ra,24(sp)
    8000378e:	e822                	sd	s0,16(sp)
    80003790:	e426                	sd	s1,8(sp)
    80003792:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003794:	c10d                	beqz	a0,800037b6 <ilock+0x2c>
    80003796:	84aa                	mv	s1,a0
    80003798:	451c                	lw	a5,8(a0)
    8000379a:	00f05e63          	blez	a5,800037b6 <ilock+0x2c>
  acquiresleep(&ip->lock);
    8000379e:	0541                	addi	a0,a0,16
    800037a0:	00001097          	auipc	ra,0x1
    800037a4:	cae080e7          	jalr	-850(ra) # 8000444e <acquiresleep>
  if(ip->valid == 0){
    800037a8:	40bc                	lw	a5,64(s1)
    800037aa:	cf99                	beqz	a5,800037c8 <ilock+0x3e>
}
    800037ac:	60e2                	ld	ra,24(sp)
    800037ae:	6442                	ld	s0,16(sp)
    800037b0:	64a2                	ld	s1,8(sp)
    800037b2:	6105                	addi	sp,sp,32
    800037b4:	8082                	ret
    800037b6:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800037b8:	00005517          	auipc	a0,0x5
    800037bc:	d1050513          	addi	a0,a0,-752 # 800084c8 <etext+0x4c8>
    800037c0:	ffffd097          	auipc	ra,0xffffd
    800037c4:	da0080e7          	jalr	-608(ra) # 80000560 <panic>
    800037c8:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800037ca:	40dc                	lw	a5,4(s1)
    800037cc:	0047d79b          	srliw	a5,a5,0x4
    800037d0:	0001e597          	auipc	a1,0x1e
    800037d4:	2205a583          	lw	a1,544(a1) # 800219f0 <sb+0x18>
    800037d8:	9dbd                	addw	a1,a1,a5
    800037da:	4088                	lw	a0,0(s1)
    800037dc:	fffff097          	auipc	ra,0xfffff
    800037e0:	77a080e7          	jalr	1914(ra) # 80002f56 <bread>
    800037e4:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800037e6:	05850593          	addi	a1,a0,88
    800037ea:	40dc                	lw	a5,4(s1)
    800037ec:	8bbd                	andi	a5,a5,15
    800037ee:	079a                	slli	a5,a5,0x6
    800037f0:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800037f2:	00059783          	lh	a5,0(a1)
    800037f6:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800037fa:	00259783          	lh	a5,2(a1)
    800037fe:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003802:	00459783          	lh	a5,4(a1)
    80003806:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000380a:	00659783          	lh	a5,6(a1)
    8000380e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003812:	459c                	lw	a5,8(a1)
    80003814:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003816:	03400613          	li	a2,52
    8000381a:	05b1                	addi	a1,a1,12
    8000381c:	05048513          	addi	a0,s1,80
    80003820:	ffffd097          	auipc	ra,0xffffd
    80003824:	588080e7          	jalr	1416(ra) # 80000da8 <memmove>
    brelse(bp);
    80003828:	854a                	mv	a0,s2
    8000382a:	00000097          	auipc	ra,0x0
    8000382e:	85c080e7          	jalr	-1956(ra) # 80003086 <brelse>
    ip->valid = 1;
    80003832:	4785                	li	a5,1
    80003834:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003836:	04449783          	lh	a5,68(s1)
    8000383a:	c399                	beqz	a5,80003840 <ilock+0xb6>
    8000383c:	6902                	ld	s2,0(sp)
    8000383e:	b7bd                	j	800037ac <ilock+0x22>
      panic("ilock: no type");
    80003840:	00005517          	auipc	a0,0x5
    80003844:	c9050513          	addi	a0,a0,-880 # 800084d0 <etext+0x4d0>
    80003848:	ffffd097          	auipc	ra,0xffffd
    8000384c:	d18080e7          	jalr	-744(ra) # 80000560 <panic>

0000000080003850 <iunlock>:
{
    80003850:	1101                	addi	sp,sp,-32
    80003852:	ec06                	sd	ra,24(sp)
    80003854:	e822                	sd	s0,16(sp)
    80003856:	e426                	sd	s1,8(sp)
    80003858:	e04a                	sd	s2,0(sp)
    8000385a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000385c:	c905                	beqz	a0,8000388c <iunlock+0x3c>
    8000385e:	84aa                	mv	s1,a0
    80003860:	01050913          	addi	s2,a0,16
    80003864:	854a                	mv	a0,s2
    80003866:	00001097          	auipc	ra,0x1
    8000386a:	c82080e7          	jalr	-894(ra) # 800044e8 <holdingsleep>
    8000386e:	cd19                	beqz	a0,8000388c <iunlock+0x3c>
    80003870:	449c                	lw	a5,8(s1)
    80003872:	00f05d63          	blez	a5,8000388c <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003876:	854a                	mv	a0,s2
    80003878:	00001097          	auipc	ra,0x1
    8000387c:	c2c080e7          	jalr	-980(ra) # 800044a4 <releasesleep>
}
    80003880:	60e2                	ld	ra,24(sp)
    80003882:	6442                	ld	s0,16(sp)
    80003884:	64a2                	ld	s1,8(sp)
    80003886:	6902                	ld	s2,0(sp)
    80003888:	6105                	addi	sp,sp,32
    8000388a:	8082                	ret
    panic("iunlock");
    8000388c:	00005517          	auipc	a0,0x5
    80003890:	c5450513          	addi	a0,a0,-940 # 800084e0 <etext+0x4e0>
    80003894:	ffffd097          	auipc	ra,0xffffd
    80003898:	ccc080e7          	jalr	-820(ra) # 80000560 <panic>

000000008000389c <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000389c:	7179                	addi	sp,sp,-48
    8000389e:	f406                	sd	ra,40(sp)
    800038a0:	f022                	sd	s0,32(sp)
    800038a2:	ec26                	sd	s1,24(sp)
    800038a4:	e84a                	sd	s2,16(sp)
    800038a6:	e44e                	sd	s3,8(sp)
    800038a8:	1800                	addi	s0,sp,48
    800038aa:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800038ac:	05050493          	addi	s1,a0,80
    800038b0:	08050913          	addi	s2,a0,128
    800038b4:	a021                	j	800038bc <itrunc+0x20>
    800038b6:	0491                	addi	s1,s1,4
    800038b8:	01248d63          	beq	s1,s2,800038d2 <itrunc+0x36>
    if(ip->addrs[i]){
    800038bc:	408c                	lw	a1,0(s1)
    800038be:	dde5                	beqz	a1,800038b6 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800038c0:	0009a503          	lw	a0,0(s3)
    800038c4:	00000097          	auipc	ra,0x0
    800038c8:	8d6080e7          	jalr	-1834(ra) # 8000319a <bfree>
      ip->addrs[i] = 0;
    800038cc:	0004a023          	sw	zero,0(s1)
    800038d0:	b7dd                	j	800038b6 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    800038d2:	0809a583          	lw	a1,128(s3)
    800038d6:	ed99                	bnez	a1,800038f4 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800038d8:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800038dc:	854e                	mv	a0,s3
    800038de:	00000097          	auipc	ra,0x0
    800038e2:	de0080e7          	jalr	-544(ra) # 800036be <iupdate>
}
    800038e6:	70a2                	ld	ra,40(sp)
    800038e8:	7402                	ld	s0,32(sp)
    800038ea:	64e2                	ld	s1,24(sp)
    800038ec:	6942                	ld	s2,16(sp)
    800038ee:	69a2                	ld	s3,8(sp)
    800038f0:	6145                	addi	sp,sp,48
    800038f2:	8082                	ret
    800038f4:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800038f6:	0009a503          	lw	a0,0(s3)
    800038fa:	fffff097          	auipc	ra,0xfffff
    800038fe:	65c080e7          	jalr	1628(ra) # 80002f56 <bread>
    80003902:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003904:	05850493          	addi	s1,a0,88
    80003908:	45850913          	addi	s2,a0,1112
    8000390c:	a021                	j	80003914 <itrunc+0x78>
    8000390e:	0491                	addi	s1,s1,4
    80003910:	01248b63          	beq	s1,s2,80003926 <itrunc+0x8a>
      if(a[j])
    80003914:	408c                	lw	a1,0(s1)
    80003916:	dde5                	beqz	a1,8000390e <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80003918:	0009a503          	lw	a0,0(s3)
    8000391c:	00000097          	auipc	ra,0x0
    80003920:	87e080e7          	jalr	-1922(ra) # 8000319a <bfree>
    80003924:	b7ed                	j	8000390e <itrunc+0x72>
    brelse(bp);
    80003926:	8552                	mv	a0,s4
    80003928:	fffff097          	auipc	ra,0xfffff
    8000392c:	75e080e7          	jalr	1886(ra) # 80003086 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003930:	0809a583          	lw	a1,128(s3)
    80003934:	0009a503          	lw	a0,0(s3)
    80003938:	00000097          	auipc	ra,0x0
    8000393c:	862080e7          	jalr	-1950(ra) # 8000319a <bfree>
    ip->addrs[NDIRECT] = 0;
    80003940:	0809a023          	sw	zero,128(s3)
    80003944:	6a02                	ld	s4,0(sp)
    80003946:	bf49                	j	800038d8 <itrunc+0x3c>

0000000080003948 <iput>:
{
    80003948:	1101                	addi	sp,sp,-32
    8000394a:	ec06                	sd	ra,24(sp)
    8000394c:	e822                	sd	s0,16(sp)
    8000394e:	e426                	sd	s1,8(sp)
    80003950:	1000                	addi	s0,sp,32
    80003952:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003954:	0001e517          	auipc	a0,0x1e
    80003958:	0a450513          	addi	a0,a0,164 # 800219f8 <itable>
    8000395c:	ffffd097          	auipc	ra,0xffffd
    80003960:	2f4080e7          	jalr	756(ra) # 80000c50 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003964:	4498                	lw	a4,8(s1)
    80003966:	4785                	li	a5,1
    80003968:	02f70263          	beq	a4,a5,8000398c <iput+0x44>
  ip->ref--;
    8000396c:	449c                	lw	a5,8(s1)
    8000396e:	37fd                	addiw	a5,a5,-1
    80003970:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003972:	0001e517          	auipc	a0,0x1e
    80003976:	08650513          	addi	a0,a0,134 # 800219f8 <itable>
    8000397a:	ffffd097          	auipc	ra,0xffffd
    8000397e:	38a080e7          	jalr	906(ra) # 80000d04 <release>
}
    80003982:	60e2                	ld	ra,24(sp)
    80003984:	6442                	ld	s0,16(sp)
    80003986:	64a2                	ld	s1,8(sp)
    80003988:	6105                	addi	sp,sp,32
    8000398a:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000398c:	40bc                	lw	a5,64(s1)
    8000398e:	dff9                	beqz	a5,8000396c <iput+0x24>
    80003990:	04a49783          	lh	a5,74(s1)
    80003994:	ffe1                	bnez	a5,8000396c <iput+0x24>
    80003996:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003998:	01048913          	addi	s2,s1,16
    8000399c:	854a                	mv	a0,s2
    8000399e:	00001097          	auipc	ra,0x1
    800039a2:	ab0080e7          	jalr	-1360(ra) # 8000444e <acquiresleep>
    release(&itable.lock);
    800039a6:	0001e517          	auipc	a0,0x1e
    800039aa:	05250513          	addi	a0,a0,82 # 800219f8 <itable>
    800039ae:	ffffd097          	auipc	ra,0xffffd
    800039b2:	356080e7          	jalr	854(ra) # 80000d04 <release>
    itrunc(ip);
    800039b6:	8526                	mv	a0,s1
    800039b8:	00000097          	auipc	ra,0x0
    800039bc:	ee4080e7          	jalr	-284(ra) # 8000389c <itrunc>
    ip->type = 0;
    800039c0:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800039c4:	8526                	mv	a0,s1
    800039c6:	00000097          	auipc	ra,0x0
    800039ca:	cf8080e7          	jalr	-776(ra) # 800036be <iupdate>
    ip->valid = 0;
    800039ce:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800039d2:	854a                	mv	a0,s2
    800039d4:	00001097          	auipc	ra,0x1
    800039d8:	ad0080e7          	jalr	-1328(ra) # 800044a4 <releasesleep>
    acquire(&itable.lock);
    800039dc:	0001e517          	auipc	a0,0x1e
    800039e0:	01c50513          	addi	a0,a0,28 # 800219f8 <itable>
    800039e4:	ffffd097          	auipc	ra,0xffffd
    800039e8:	26c080e7          	jalr	620(ra) # 80000c50 <acquire>
    800039ec:	6902                	ld	s2,0(sp)
    800039ee:	bfbd                	j	8000396c <iput+0x24>

00000000800039f0 <iunlockput>:
{
    800039f0:	1101                	addi	sp,sp,-32
    800039f2:	ec06                	sd	ra,24(sp)
    800039f4:	e822                	sd	s0,16(sp)
    800039f6:	e426                	sd	s1,8(sp)
    800039f8:	1000                	addi	s0,sp,32
    800039fa:	84aa                	mv	s1,a0
  iunlock(ip);
    800039fc:	00000097          	auipc	ra,0x0
    80003a00:	e54080e7          	jalr	-428(ra) # 80003850 <iunlock>
  iput(ip);
    80003a04:	8526                	mv	a0,s1
    80003a06:	00000097          	auipc	ra,0x0
    80003a0a:	f42080e7          	jalr	-190(ra) # 80003948 <iput>
}
    80003a0e:	60e2                	ld	ra,24(sp)
    80003a10:	6442                	ld	s0,16(sp)
    80003a12:	64a2                	ld	s1,8(sp)
    80003a14:	6105                	addi	sp,sp,32
    80003a16:	8082                	ret

0000000080003a18 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003a18:	1141                	addi	sp,sp,-16
    80003a1a:	e422                	sd	s0,8(sp)
    80003a1c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003a1e:	411c                	lw	a5,0(a0)
    80003a20:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003a22:	415c                	lw	a5,4(a0)
    80003a24:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003a26:	04451783          	lh	a5,68(a0)
    80003a2a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003a2e:	04a51783          	lh	a5,74(a0)
    80003a32:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003a36:	04c56783          	lwu	a5,76(a0)
    80003a3a:	e99c                	sd	a5,16(a1)
}
    80003a3c:	6422                	ld	s0,8(sp)
    80003a3e:	0141                	addi	sp,sp,16
    80003a40:	8082                	ret

0000000080003a42 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003a42:	457c                	lw	a5,76(a0)
    80003a44:	10d7e563          	bltu	a5,a3,80003b4e <readi+0x10c>
{
    80003a48:	7159                	addi	sp,sp,-112
    80003a4a:	f486                	sd	ra,104(sp)
    80003a4c:	f0a2                	sd	s0,96(sp)
    80003a4e:	eca6                	sd	s1,88(sp)
    80003a50:	e0d2                	sd	s4,64(sp)
    80003a52:	fc56                	sd	s5,56(sp)
    80003a54:	f85a                	sd	s6,48(sp)
    80003a56:	f45e                	sd	s7,40(sp)
    80003a58:	1880                	addi	s0,sp,112
    80003a5a:	8b2a                	mv	s6,a0
    80003a5c:	8bae                	mv	s7,a1
    80003a5e:	8a32                	mv	s4,a2
    80003a60:	84b6                	mv	s1,a3
    80003a62:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003a64:	9f35                	addw	a4,a4,a3
    return 0;
    80003a66:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003a68:	0cd76a63          	bltu	a4,a3,80003b3c <readi+0xfa>
    80003a6c:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003a6e:	00e7f463          	bgeu	a5,a4,80003a76 <readi+0x34>
    n = ip->size - off;
    80003a72:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003a76:	0a0a8963          	beqz	s5,80003b28 <readi+0xe6>
    80003a7a:	e8ca                	sd	s2,80(sp)
    80003a7c:	f062                	sd	s8,32(sp)
    80003a7e:	ec66                	sd	s9,24(sp)
    80003a80:	e86a                	sd	s10,16(sp)
    80003a82:	e46e                	sd	s11,8(sp)
    80003a84:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a86:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003a8a:	5c7d                	li	s8,-1
    80003a8c:	a82d                	j	80003ac6 <readi+0x84>
    80003a8e:	020d1d93          	slli	s11,s10,0x20
    80003a92:	020ddd93          	srli	s11,s11,0x20
    80003a96:	05890613          	addi	a2,s2,88
    80003a9a:	86ee                	mv	a3,s11
    80003a9c:	963a                	add	a2,a2,a4
    80003a9e:	85d2                	mv	a1,s4
    80003aa0:	855e                	mv	a0,s7
    80003aa2:	fffff097          	auipc	ra,0xfffff
    80003aa6:	a92080e7          	jalr	-1390(ra) # 80002534 <either_copyout>
    80003aaa:	05850d63          	beq	a0,s8,80003b04 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003aae:	854a                	mv	a0,s2
    80003ab0:	fffff097          	auipc	ra,0xfffff
    80003ab4:	5d6080e7          	jalr	1494(ra) # 80003086 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003ab8:	013d09bb          	addw	s3,s10,s3
    80003abc:	009d04bb          	addw	s1,s10,s1
    80003ac0:	9a6e                	add	s4,s4,s11
    80003ac2:	0559fd63          	bgeu	s3,s5,80003b1c <readi+0xda>
    uint addr = bmap(ip, off/BSIZE);
    80003ac6:	00a4d59b          	srliw	a1,s1,0xa
    80003aca:	855a                	mv	a0,s6
    80003acc:	00000097          	auipc	ra,0x0
    80003ad0:	88e080e7          	jalr	-1906(ra) # 8000335a <bmap>
    80003ad4:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003ad8:	c9b1                	beqz	a1,80003b2c <readi+0xea>
    bp = bread(ip->dev, addr);
    80003ada:	000b2503          	lw	a0,0(s6)
    80003ade:	fffff097          	auipc	ra,0xfffff
    80003ae2:	478080e7          	jalr	1144(ra) # 80002f56 <bread>
    80003ae6:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003ae8:	3ff4f713          	andi	a4,s1,1023
    80003aec:	40ec87bb          	subw	a5,s9,a4
    80003af0:	413a86bb          	subw	a3,s5,s3
    80003af4:	8d3e                	mv	s10,a5
    80003af6:	2781                	sext.w	a5,a5
    80003af8:	0006861b          	sext.w	a2,a3
    80003afc:	f8f679e3          	bgeu	a2,a5,80003a8e <readi+0x4c>
    80003b00:	8d36                	mv	s10,a3
    80003b02:	b771                	j	80003a8e <readi+0x4c>
      brelse(bp);
    80003b04:	854a                	mv	a0,s2
    80003b06:	fffff097          	auipc	ra,0xfffff
    80003b0a:	580080e7          	jalr	1408(ra) # 80003086 <brelse>
      tot = -1;
    80003b0e:	59fd                	li	s3,-1
      break;
    80003b10:	6946                	ld	s2,80(sp)
    80003b12:	7c02                	ld	s8,32(sp)
    80003b14:	6ce2                	ld	s9,24(sp)
    80003b16:	6d42                	ld	s10,16(sp)
    80003b18:	6da2                	ld	s11,8(sp)
    80003b1a:	a831                	j	80003b36 <readi+0xf4>
    80003b1c:	6946                	ld	s2,80(sp)
    80003b1e:	7c02                	ld	s8,32(sp)
    80003b20:	6ce2                	ld	s9,24(sp)
    80003b22:	6d42                	ld	s10,16(sp)
    80003b24:	6da2                	ld	s11,8(sp)
    80003b26:	a801                	j	80003b36 <readi+0xf4>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003b28:	89d6                	mv	s3,s5
    80003b2a:	a031                	j	80003b36 <readi+0xf4>
    80003b2c:	6946                	ld	s2,80(sp)
    80003b2e:	7c02                	ld	s8,32(sp)
    80003b30:	6ce2                	ld	s9,24(sp)
    80003b32:	6d42                	ld	s10,16(sp)
    80003b34:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003b36:	0009851b          	sext.w	a0,s3
    80003b3a:	69a6                	ld	s3,72(sp)
}
    80003b3c:	70a6                	ld	ra,104(sp)
    80003b3e:	7406                	ld	s0,96(sp)
    80003b40:	64e6                	ld	s1,88(sp)
    80003b42:	6a06                	ld	s4,64(sp)
    80003b44:	7ae2                	ld	s5,56(sp)
    80003b46:	7b42                	ld	s6,48(sp)
    80003b48:	7ba2                	ld	s7,40(sp)
    80003b4a:	6165                	addi	sp,sp,112
    80003b4c:	8082                	ret
    return 0;
    80003b4e:	4501                	li	a0,0
}
    80003b50:	8082                	ret

0000000080003b52 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003b52:	457c                	lw	a5,76(a0)
    80003b54:	10d7ee63          	bltu	a5,a3,80003c70 <writei+0x11e>
{
    80003b58:	7159                	addi	sp,sp,-112
    80003b5a:	f486                	sd	ra,104(sp)
    80003b5c:	f0a2                	sd	s0,96(sp)
    80003b5e:	e8ca                	sd	s2,80(sp)
    80003b60:	e0d2                	sd	s4,64(sp)
    80003b62:	fc56                	sd	s5,56(sp)
    80003b64:	f85a                	sd	s6,48(sp)
    80003b66:	f45e                	sd	s7,40(sp)
    80003b68:	1880                	addi	s0,sp,112
    80003b6a:	8aaa                	mv	s5,a0
    80003b6c:	8bae                	mv	s7,a1
    80003b6e:	8a32                	mv	s4,a2
    80003b70:	8936                	mv	s2,a3
    80003b72:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003b74:	00e687bb          	addw	a5,a3,a4
    80003b78:	0ed7ee63          	bltu	a5,a3,80003c74 <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003b7c:	00043737          	lui	a4,0x43
    80003b80:	0ef76c63          	bltu	a4,a5,80003c78 <writei+0x126>
    80003b84:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003b86:	0c0b0d63          	beqz	s6,80003c60 <writei+0x10e>
    80003b8a:	eca6                	sd	s1,88(sp)
    80003b8c:	f062                	sd	s8,32(sp)
    80003b8e:	ec66                	sd	s9,24(sp)
    80003b90:	e86a                	sd	s10,16(sp)
    80003b92:	e46e                	sd	s11,8(sp)
    80003b94:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b96:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003b9a:	5c7d                	li	s8,-1
    80003b9c:	a091                	j	80003be0 <writei+0x8e>
    80003b9e:	020d1d93          	slli	s11,s10,0x20
    80003ba2:	020ddd93          	srli	s11,s11,0x20
    80003ba6:	05848513          	addi	a0,s1,88
    80003baa:	86ee                	mv	a3,s11
    80003bac:	8652                	mv	a2,s4
    80003bae:	85de                	mv	a1,s7
    80003bb0:	953a                	add	a0,a0,a4
    80003bb2:	fffff097          	auipc	ra,0xfffff
    80003bb6:	9d8080e7          	jalr	-1576(ra) # 8000258a <either_copyin>
    80003bba:	07850263          	beq	a0,s8,80003c1e <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003bbe:	8526                	mv	a0,s1
    80003bc0:	00000097          	auipc	ra,0x0
    80003bc4:	770080e7          	jalr	1904(ra) # 80004330 <log_write>
    brelse(bp);
    80003bc8:	8526                	mv	a0,s1
    80003bca:	fffff097          	auipc	ra,0xfffff
    80003bce:	4bc080e7          	jalr	1212(ra) # 80003086 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003bd2:	013d09bb          	addw	s3,s10,s3
    80003bd6:	012d093b          	addw	s2,s10,s2
    80003bda:	9a6e                	add	s4,s4,s11
    80003bdc:	0569f663          	bgeu	s3,s6,80003c28 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003be0:	00a9559b          	srliw	a1,s2,0xa
    80003be4:	8556                	mv	a0,s5
    80003be6:	fffff097          	auipc	ra,0xfffff
    80003bea:	774080e7          	jalr	1908(ra) # 8000335a <bmap>
    80003bee:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003bf2:	c99d                	beqz	a1,80003c28 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003bf4:	000aa503          	lw	a0,0(s5)
    80003bf8:	fffff097          	auipc	ra,0xfffff
    80003bfc:	35e080e7          	jalr	862(ra) # 80002f56 <bread>
    80003c00:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003c02:	3ff97713          	andi	a4,s2,1023
    80003c06:	40ec87bb          	subw	a5,s9,a4
    80003c0a:	413b06bb          	subw	a3,s6,s3
    80003c0e:	8d3e                	mv	s10,a5
    80003c10:	2781                	sext.w	a5,a5
    80003c12:	0006861b          	sext.w	a2,a3
    80003c16:	f8f674e3          	bgeu	a2,a5,80003b9e <writei+0x4c>
    80003c1a:	8d36                	mv	s10,a3
    80003c1c:	b749                	j	80003b9e <writei+0x4c>
      brelse(bp);
    80003c1e:	8526                	mv	a0,s1
    80003c20:	fffff097          	auipc	ra,0xfffff
    80003c24:	466080e7          	jalr	1126(ra) # 80003086 <brelse>
  }

  if(off > ip->size)
    80003c28:	04caa783          	lw	a5,76(s5)
    80003c2c:	0327fc63          	bgeu	a5,s2,80003c64 <writei+0x112>
    ip->size = off;
    80003c30:	052aa623          	sw	s2,76(s5)
    80003c34:	64e6                	ld	s1,88(sp)
    80003c36:	7c02                	ld	s8,32(sp)
    80003c38:	6ce2                	ld	s9,24(sp)
    80003c3a:	6d42                	ld	s10,16(sp)
    80003c3c:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003c3e:	8556                	mv	a0,s5
    80003c40:	00000097          	auipc	ra,0x0
    80003c44:	a7e080e7          	jalr	-1410(ra) # 800036be <iupdate>

  return tot;
    80003c48:	0009851b          	sext.w	a0,s3
    80003c4c:	69a6                	ld	s3,72(sp)
}
    80003c4e:	70a6                	ld	ra,104(sp)
    80003c50:	7406                	ld	s0,96(sp)
    80003c52:	6946                	ld	s2,80(sp)
    80003c54:	6a06                	ld	s4,64(sp)
    80003c56:	7ae2                	ld	s5,56(sp)
    80003c58:	7b42                	ld	s6,48(sp)
    80003c5a:	7ba2                	ld	s7,40(sp)
    80003c5c:	6165                	addi	sp,sp,112
    80003c5e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003c60:	89da                	mv	s3,s6
    80003c62:	bff1                	j	80003c3e <writei+0xec>
    80003c64:	64e6                	ld	s1,88(sp)
    80003c66:	7c02                	ld	s8,32(sp)
    80003c68:	6ce2                	ld	s9,24(sp)
    80003c6a:	6d42                	ld	s10,16(sp)
    80003c6c:	6da2                	ld	s11,8(sp)
    80003c6e:	bfc1                	j	80003c3e <writei+0xec>
    return -1;
    80003c70:	557d                	li	a0,-1
}
    80003c72:	8082                	ret
    return -1;
    80003c74:	557d                	li	a0,-1
    80003c76:	bfe1                	j	80003c4e <writei+0xfc>
    return -1;
    80003c78:	557d                	li	a0,-1
    80003c7a:	bfd1                	j	80003c4e <writei+0xfc>

0000000080003c7c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003c7c:	1141                	addi	sp,sp,-16
    80003c7e:	e406                	sd	ra,8(sp)
    80003c80:	e022                	sd	s0,0(sp)
    80003c82:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003c84:	4639                	li	a2,14
    80003c86:	ffffd097          	auipc	ra,0xffffd
    80003c8a:	196080e7          	jalr	406(ra) # 80000e1c <strncmp>
}
    80003c8e:	60a2                	ld	ra,8(sp)
    80003c90:	6402                	ld	s0,0(sp)
    80003c92:	0141                	addi	sp,sp,16
    80003c94:	8082                	ret

0000000080003c96 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003c96:	7139                	addi	sp,sp,-64
    80003c98:	fc06                	sd	ra,56(sp)
    80003c9a:	f822                	sd	s0,48(sp)
    80003c9c:	f426                	sd	s1,40(sp)
    80003c9e:	f04a                	sd	s2,32(sp)
    80003ca0:	ec4e                	sd	s3,24(sp)
    80003ca2:	e852                	sd	s4,16(sp)
    80003ca4:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003ca6:	04451703          	lh	a4,68(a0)
    80003caa:	4785                	li	a5,1
    80003cac:	00f71a63          	bne	a4,a5,80003cc0 <dirlookup+0x2a>
    80003cb0:	892a                	mv	s2,a0
    80003cb2:	89ae                	mv	s3,a1
    80003cb4:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003cb6:	457c                	lw	a5,76(a0)
    80003cb8:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003cba:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003cbc:	e79d                	bnez	a5,80003cea <dirlookup+0x54>
    80003cbe:	a8a5                	j	80003d36 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003cc0:	00005517          	auipc	a0,0x5
    80003cc4:	82850513          	addi	a0,a0,-2008 # 800084e8 <etext+0x4e8>
    80003cc8:	ffffd097          	auipc	ra,0xffffd
    80003ccc:	898080e7          	jalr	-1896(ra) # 80000560 <panic>
      panic("dirlookup read");
    80003cd0:	00005517          	auipc	a0,0x5
    80003cd4:	83050513          	addi	a0,a0,-2000 # 80008500 <etext+0x500>
    80003cd8:	ffffd097          	auipc	ra,0xffffd
    80003cdc:	888080e7          	jalr	-1912(ra) # 80000560 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ce0:	24c1                	addiw	s1,s1,16
    80003ce2:	04c92783          	lw	a5,76(s2)
    80003ce6:	04f4f763          	bgeu	s1,a5,80003d34 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003cea:	4741                	li	a4,16
    80003cec:	86a6                	mv	a3,s1
    80003cee:	fc040613          	addi	a2,s0,-64
    80003cf2:	4581                	li	a1,0
    80003cf4:	854a                	mv	a0,s2
    80003cf6:	00000097          	auipc	ra,0x0
    80003cfa:	d4c080e7          	jalr	-692(ra) # 80003a42 <readi>
    80003cfe:	47c1                	li	a5,16
    80003d00:	fcf518e3          	bne	a0,a5,80003cd0 <dirlookup+0x3a>
    if(de.inum == 0)
    80003d04:	fc045783          	lhu	a5,-64(s0)
    80003d08:	dfe1                	beqz	a5,80003ce0 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003d0a:	fc240593          	addi	a1,s0,-62
    80003d0e:	854e                	mv	a0,s3
    80003d10:	00000097          	auipc	ra,0x0
    80003d14:	f6c080e7          	jalr	-148(ra) # 80003c7c <namecmp>
    80003d18:	f561                	bnez	a0,80003ce0 <dirlookup+0x4a>
      if(poff)
    80003d1a:	000a0463          	beqz	s4,80003d22 <dirlookup+0x8c>
        *poff = off;
    80003d1e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003d22:	fc045583          	lhu	a1,-64(s0)
    80003d26:	00092503          	lw	a0,0(s2)
    80003d2a:	fffff097          	auipc	ra,0xfffff
    80003d2e:	720080e7          	jalr	1824(ra) # 8000344a <iget>
    80003d32:	a011                	j	80003d36 <dirlookup+0xa0>
  return 0;
    80003d34:	4501                	li	a0,0
}
    80003d36:	70e2                	ld	ra,56(sp)
    80003d38:	7442                	ld	s0,48(sp)
    80003d3a:	74a2                	ld	s1,40(sp)
    80003d3c:	7902                	ld	s2,32(sp)
    80003d3e:	69e2                	ld	s3,24(sp)
    80003d40:	6a42                	ld	s4,16(sp)
    80003d42:	6121                	addi	sp,sp,64
    80003d44:	8082                	ret

0000000080003d46 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003d46:	711d                	addi	sp,sp,-96
    80003d48:	ec86                	sd	ra,88(sp)
    80003d4a:	e8a2                	sd	s0,80(sp)
    80003d4c:	e4a6                	sd	s1,72(sp)
    80003d4e:	e0ca                	sd	s2,64(sp)
    80003d50:	fc4e                	sd	s3,56(sp)
    80003d52:	f852                	sd	s4,48(sp)
    80003d54:	f456                	sd	s5,40(sp)
    80003d56:	f05a                	sd	s6,32(sp)
    80003d58:	ec5e                	sd	s7,24(sp)
    80003d5a:	e862                	sd	s8,16(sp)
    80003d5c:	e466                	sd	s9,8(sp)
    80003d5e:	1080                	addi	s0,sp,96
    80003d60:	84aa                	mv	s1,a0
    80003d62:	8b2e                	mv	s6,a1
    80003d64:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003d66:	00054703          	lbu	a4,0(a0)
    80003d6a:	02f00793          	li	a5,47
    80003d6e:	02f70263          	beq	a4,a5,80003d92 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003d72:	ffffe097          	auipc	ra,0xffffe
    80003d76:	cf0080e7          	jalr	-784(ra) # 80001a62 <myproc>
    80003d7a:	15053503          	ld	a0,336(a0)
    80003d7e:	00000097          	auipc	ra,0x0
    80003d82:	9ce080e7          	jalr	-1586(ra) # 8000374c <idup>
    80003d86:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003d88:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003d8c:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003d8e:	4b85                	li	s7,1
    80003d90:	a875                	j	80003e4c <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003d92:	4585                	li	a1,1
    80003d94:	4505                	li	a0,1
    80003d96:	fffff097          	auipc	ra,0xfffff
    80003d9a:	6b4080e7          	jalr	1716(ra) # 8000344a <iget>
    80003d9e:	8a2a                	mv	s4,a0
    80003da0:	b7e5                	j	80003d88 <namex+0x42>
      iunlockput(ip);
    80003da2:	8552                	mv	a0,s4
    80003da4:	00000097          	auipc	ra,0x0
    80003da8:	c4c080e7          	jalr	-948(ra) # 800039f0 <iunlockput>
      return 0;
    80003dac:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003dae:	8552                	mv	a0,s4
    80003db0:	60e6                	ld	ra,88(sp)
    80003db2:	6446                	ld	s0,80(sp)
    80003db4:	64a6                	ld	s1,72(sp)
    80003db6:	6906                	ld	s2,64(sp)
    80003db8:	79e2                	ld	s3,56(sp)
    80003dba:	7a42                	ld	s4,48(sp)
    80003dbc:	7aa2                	ld	s5,40(sp)
    80003dbe:	7b02                	ld	s6,32(sp)
    80003dc0:	6be2                	ld	s7,24(sp)
    80003dc2:	6c42                	ld	s8,16(sp)
    80003dc4:	6ca2                	ld	s9,8(sp)
    80003dc6:	6125                	addi	sp,sp,96
    80003dc8:	8082                	ret
      iunlock(ip);
    80003dca:	8552                	mv	a0,s4
    80003dcc:	00000097          	auipc	ra,0x0
    80003dd0:	a84080e7          	jalr	-1404(ra) # 80003850 <iunlock>
      return ip;
    80003dd4:	bfe9                	j	80003dae <namex+0x68>
      iunlockput(ip);
    80003dd6:	8552                	mv	a0,s4
    80003dd8:	00000097          	auipc	ra,0x0
    80003ddc:	c18080e7          	jalr	-1000(ra) # 800039f0 <iunlockput>
      return 0;
    80003de0:	8a4e                	mv	s4,s3
    80003de2:	b7f1                	j	80003dae <namex+0x68>
  len = path - s;
    80003de4:	40998633          	sub	a2,s3,s1
    80003de8:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003dec:	099c5863          	bge	s8,s9,80003e7c <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003df0:	4639                	li	a2,14
    80003df2:	85a6                	mv	a1,s1
    80003df4:	8556                	mv	a0,s5
    80003df6:	ffffd097          	auipc	ra,0xffffd
    80003dfa:	fb2080e7          	jalr	-78(ra) # 80000da8 <memmove>
    80003dfe:	84ce                	mv	s1,s3
  while(*path == '/')
    80003e00:	0004c783          	lbu	a5,0(s1)
    80003e04:	01279763          	bne	a5,s2,80003e12 <namex+0xcc>
    path++;
    80003e08:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003e0a:	0004c783          	lbu	a5,0(s1)
    80003e0e:	ff278de3          	beq	a5,s2,80003e08 <namex+0xc2>
    ilock(ip);
    80003e12:	8552                	mv	a0,s4
    80003e14:	00000097          	auipc	ra,0x0
    80003e18:	976080e7          	jalr	-1674(ra) # 8000378a <ilock>
    if(ip->type != T_DIR){
    80003e1c:	044a1783          	lh	a5,68(s4)
    80003e20:	f97791e3          	bne	a5,s7,80003da2 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80003e24:	000b0563          	beqz	s6,80003e2e <namex+0xe8>
    80003e28:	0004c783          	lbu	a5,0(s1)
    80003e2c:	dfd9                	beqz	a5,80003dca <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003e2e:	4601                	li	a2,0
    80003e30:	85d6                	mv	a1,s5
    80003e32:	8552                	mv	a0,s4
    80003e34:	00000097          	auipc	ra,0x0
    80003e38:	e62080e7          	jalr	-414(ra) # 80003c96 <dirlookup>
    80003e3c:	89aa                	mv	s3,a0
    80003e3e:	dd41                	beqz	a0,80003dd6 <namex+0x90>
    iunlockput(ip);
    80003e40:	8552                	mv	a0,s4
    80003e42:	00000097          	auipc	ra,0x0
    80003e46:	bae080e7          	jalr	-1106(ra) # 800039f0 <iunlockput>
    ip = next;
    80003e4a:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003e4c:	0004c783          	lbu	a5,0(s1)
    80003e50:	01279763          	bne	a5,s2,80003e5e <namex+0x118>
    path++;
    80003e54:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003e56:	0004c783          	lbu	a5,0(s1)
    80003e5a:	ff278de3          	beq	a5,s2,80003e54 <namex+0x10e>
  if(*path == 0)
    80003e5e:	cb9d                	beqz	a5,80003e94 <namex+0x14e>
  while(*path != '/' && *path != 0)
    80003e60:	0004c783          	lbu	a5,0(s1)
    80003e64:	89a6                	mv	s3,s1
  len = path - s;
    80003e66:	4c81                	li	s9,0
    80003e68:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003e6a:	01278963          	beq	a5,s2,80003e7c <namex+0x136>
    80003e6e:	dbbd                	beqz	a5,80003de4 <namex+0x9e>
    path++;
    80003e70:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003e72:	0009c783          	lbu	a5,0(s3)
    80003e76:	ff279ce3          	bne	a5,s2,80003e6e <namex+0x128>
    80003e7a:	b7ad                	j	80003de4 <namex+0x9e>
    memmove(name, s, len);
    80003e7c:	2601                	sext.w	a2,a2
    80003e7e:	85a6                	mv	a1,s1
    80003e80:	8556                	mv	a0,s5
    80003e82:	ffffd097          	auipc	ra,0xffffd
    80003e86:	f26080e7          	jalr	-218(ra) # 80000da8 <memmove>
    name[len] = 0;
    80003e8a:	9cd6                	add	s9,s9,s5
    80003e8c:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003e90:	84ce                	mv	s1,s3
    80003e92:	b7bd                	j	80003e00 <namex+0xba>
  if(nameiparent){
    80003e94:	f00b0de3          	beqz	s6,80003dae <namex+0x68>
    iput(ip);
    80003e98:	8552                	mv	a0,s4
    80003e9a:	00000097          	auipc	ra,0x0
    80003e9e:	aae080e7          	jalr	-1362(ra) # 80003948 <iput>
    return 0;
    80003ea2:	4a01                	li	s4,0
    80003ea4:	b729                	j	80003dae <namex+0x68>

0000000080003ea6 <dirlink>:
{
    80003ea6:	7139                	addi	sp,sp,-64
    80003ea8:	fc06                	sd	ra,56(sp)
    80003eaa:	f822                	sd	s0,48(sp)
    80003eac:	f04a                	sd	s2,32(sp)
    80003eae:	ec4e                	sd	s3,24(sp)
    80003eb0:	e852                	sd	s4,16(sp)
    80003eb2:	0080                	addi	s0,sp,64
    80003eb4:	892a                	mv	s2,a0
    80003eb6:	8a2e                	mv	s4,a1
    80003eb8:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003eba:	4601                	li	a2,0
    80003ebc:	00000097          	auipc	ra,0x0
    80003ec0:	dda080e7          	jalr	-550(ra) # 80003c96 <dirlookup>
    80003ec4:	ed25                	bnez	a0,80003f3c <dirlink+0x96>
    80003ec6:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ec8:	04c92483          	lw	s1,76(s2)
    80003ecc:	c49d                	beqz	s1,80003efa <dirlink+0x54>
    80003ece:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ed0:	4741                	li	a4,16
    80003ed2:	86a6                	mv	a3,s1
    80003ed4:	fc040613          	addi	a2,s0,-64
    80003ed8:	4581                	li	a1,0
    80003eda:	854a                	mv	a0,s2
    80003edc:	00000097          	auipc	ra,0x0
    80003ee0:	b66080e7          	jalr	-1178(ra) # 80003a42 <readi>
    80003ee4:	47c1                	li	a5,16
    80003ee6:	06f51163          	bne	a0,a5,80003f48 <dirlink+0xa2>
    if(de.inum == 0)
    80003eea:	fc045783          	lhu	a5,-64(s0)
    80003eee:	c791                	beqz	a5,80003efa <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ef0:	24c1                	addiw	s1,s1,16
    80003ef2:	04c92783          	lw	a5,76(s2)
    80003ef6:	fcf4ede3          	bltu	s1,a5,80003ed0 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003efa:	4639                	li	a2,14
    80003efc:	85d2                	mv	a1,s4
    80003efe:	fc240513          	addi	a0,s0,-62
    80003f02:	ffffd097          	auipc	ra,0xffffd
    80003f06:	f50080e7          	jalr	-176(ra) # 80000e52 <strncpy>
  de.inum = inum;
    80003f0a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003f0e:	4741                	li	a4,16
    80003f10:	86a6                	mv	a3,s1
    80003f12:	fc040613          	addi	a2,s0,-64
    80003f16:	4581                	li	a1,0
    80003f18:	854a                	mv	a0,s2
    80003f1a:	00000097          	auipc	ra,0x0
    80003f1e:	c38080e7          	jalr	-968(ra) # 80003b52 <writei>
    80003f22:	1541                	addi	a0,a0,-16
    80003f24:	00a03533          	snez	a0,a0
    80003f28:	40a00533          	neg	a0,a0
    80003f2c:	74a2                	ld	s1,40(sp)
}
    80003f2e:	70e2                	ld	ra,56(sp)
    80003f30:	7442                	ld	s0,48(sp)
    80003f32:	7902                	ld	s2,32(sp)
    80003f34:	69e2                	ld	s3,24(sp)
    80003f36:	6a42                	ld	s4,16(sp)
    80003f38:	6121                	addi	sp,sp,64
    80003f3a:	8082                	ret
    iput(ip);
    80003f3c:	00000097          	auipc	ra,0x0
    80003f40:	a0c080e7          	jalr	-1524(ra) # 80003948 <iput>
    return -1;
    80003f44:	557d                	li	a0,-1
    80003f46:	b7e5                	j	80003f2e <dirlink+0x88>
      panic("dirlink read");
    80003f48:	00004517          	auipc	a0,0x4
    80003f4c:	5c850513          	addi	a0,a0,1480 # 80008510 <etext+0x510>
    80003f50:	ffffc097          	auipc	ra,0xffffc
    80003f54:	610080e7          	jalr	1552(ra) # 80000560 <panic>

0000000080003f58 <namei>:

struct inode*
namei(char *path)
{
    80003f58:	1101                	addi	sp,sp,-32
    80003f5a:	ec06                	sd	ra,24(sp)
    80003f5c:	e822                	sd	s0,16(sp)
    80003f5e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003f60:	fe040613          	addi	a2,s0,-32
    80003f64:	4581                	li	a1,0
    80003f66:	00000097          	auipc	ra,0x0
    80003f6a:	de0080e7          	jalr	-544(ra) # 80003d46 <namex>
}
    80003f6e:	60e2                	ld	ra,24(sp)
    80003f70:	6442                	ld	s0,16(sp)
    80003f72:	6105                	addi	sp,sp,32
    80003f74:	8082                	ret

0000000080003f76 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003f76:	1141                	addi	sp,sp,-16
    80003f78:	e406                	sd	ra,8(sp)
    80003f7a:	e022                	sd	s0,0(sp)
    80003f7c:	0800                	addi	s0,sp,16
    80003f7e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003f80:	4585                	li	a1,1
    80003f82:	00000097          	auipc	ra,0x0
    80003f86:	dc4080e7          	jalr	-572(ra) # 80003d46 <namex>
}
    80003f8a:	60a2                	ld	ra,8(sp)
    80003f8c:	6402                	ld	s0,0(sp)
    80003f8e:	0141                	addi	sp,sp,16
    80003f90:	8082                	ret

0000000080003f92 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003f92:	1101                	addi	sp,sp,-32
    80003f94:	ec06                	sd	ra,24(sp)
    80003f96:	e822                	sd	s0,16(sp)
    80003f98:	e426                	sd	s1,8(sp)
    80003f9a:	e04a                	sd	s2,0(sp)
    80003f9c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003f9e:	0001f917          	auipc	s2,0x1f
    80003fa2:	50290913          	addi	s2,s2,1282 # 800234a0 <log>
    80003fa6:	01892583          	lw	a1,24(s2)
    80003faa:	02892503          	lw	a0,40(s2)
    80003fae:	fffff097          	auipc	ra,0xfffff
    80003fb2:	fa8080e7          	jalr	-88(ra) # 80002f56 <bread>
    80003fb6:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003fb8:	02c92603          	lw	a2,44(s2)
    80003fbc:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003fbe:	00c05f63          	blez	a2,80003fdc <write_head+0x4a>
    80003fc2:	0001f717          	auipc	a4,0x1f
    80003fc6:	50e70713          	addi	a4,a4,1294 # 800234d0 <log+0x30>
    80003fca:	87aa                	mv	a5,a0
    80003fcc:	060a                	slli	a2,a2,0x2
    80003fce:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003fd0:	4314                	lw	a3,0(a4)
    80003fd2:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003fd4:	0711                	addi	a4,a4,4
    80003fd6:	0791                	addi	a5,a5,4
    80003fd8:	fec79ce3          	bne	a5,a2,80003fd0 <write_head+0x3e>
  }
  bwrite(buf);
    80003fdc:	8526                	mv	a0,s1
    80003fde:	fffff097          	auipc	ra,0xfffff
    80003fe2:	06a080e7          	jalr	106(ra) # 80003048 <bwrite>
  brelse(buf);
    80003fe6:	8526                	mv	a0,s1
    80003fe8:	fffff097          	auipc	ra,0xfffff
    80003fec:	09e080e7          	jalr	158(ra) # 80003086 <brelse>
}
    80003ff0:	60e2                	ld	ra,24(sp)
    80003ff2:	6442                	ld	s0,16(sp)
    80003ff4:	64a2                	ld	s1,8(sp)
    80003ff6:	6902                	ld	s2,0(sp)
    80003ff8:	6105                	addi	sp,sp,32
    80003ffa:	8082                	ret

0000000080003ffc <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ffc:	0001f797          	auipc	a5,0x1f
    80004000:	4d07a783          	lw	a5,1232(a5) # 800234cc <log+0x2c>
    80004004:	0af05d63          	blez	a5,800040be <install_trans+0xc2>
{
    80004008:	7139                	addi	sp,sp,-64
    8000400a:	fc06                	sd	ra,56(sp)
    8000400c:	f822                	sd	s0,48(sp)
    8000400e:	f426                	sd	s1,40(sp)
    80004010:	f04a                	sd	s2,32(sp)
    80004012:	ec4e                	sd	s3,24(sp)
    80004014:	e852                	sd	s4,16(sp)
    80004016:	e456                	sd	s5,8(sp)
    80004018:	e05a                	sd	s6,0(sp)
    8000401a:	0080                	addi	s0,sp,64
    8000401c:	8b2a                	mv	s6,a0
    8000401e:	0001fa97          	auipc	s5,0x1f
    80004022:	4b2a8a93          	addi	s5,s5,1202 # 800234d0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004026:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004028:	0001f997          	auipc	s3,0x1f
    8000402c:	47898993          	addi	s3,s3,1144 # 800234a0 <log>
    80004030:	a00d                	j	80004052 <install_trans+0x56>
    brelse(lbuf);
    80004032:	854a                	mv	a0,s2
    80004034:	fffff097          	auipc	ra,0xfffff
    80004038:	052080e7          	jalr	82(ra) # 80003086 <brelse>
    brelse(dbuf);
    8000403c:	8526                	mv	a0,s1
    8000403e:	fffff097          	auipc	ra,0xfffff
    80004042:	048080e7          	jalr	72(ra) # 80003086 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004046:	2a05                	addiw	s4,s4,1
    80004048:	0a91                	addi	s5,s5,4
    8000404a:	02c9a783          	lw	a5,44(s3)
    8000404e:	04fa5e63          	bge	s4,a5,800040aa <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004052:	0189a583          	lw	a1,24(s3)
    80004056:	014585bb          	addw	a1,a1,s4
    8000405a:	2585                	addiw	a1,a1,1
    8000405c:	0289a503          	lw	a0,40(s3)
    80004060:	fffff097          	auipc	ra,0xfffff
    80004064:	ef6080e7          	jalr	-266(ra) # 80002f56 <bread>
    80004068:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000406a:	000aa583          	lw	a1,0(s5)
    8000406e:	0289a503          	lw	a0,40(s3)
    80004072:	fffff097          	auipc	ra,0xfffff
    80004076:	ee4080e7          	jalr	-284(ra) # 80002f56 <bread>
    8000407a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000407c:	40000613          	li	a2,1024
    80004080:	05890593          	addi	a1,s2,88
    80004084:	05850513          	addi	a0,a0,88
    80004088:	ffffd097          	auipc	ra,0xffffd
    8000408c:	d20080e7          	jalr	-736(ra) # 80000da8 <memmove>
    bwrite(dbuf);  // write dst to disk
    80004090:	8526                	mv	a0,s1
    80004092:	fffff097          	auipc	ra,0xfffff
    80004096:	fb6080e7          	jalr	-74(ra) # 80003048 <bwrite>
    if(recovering == 0)
    8000409a:	f80b1ce3          	bnez	s6,80004032 <install_trans+0x36>
      bunpin(dbuf);
    8000409e:	8526                	mv	a0,s1
    800040a0:	fffff097          	auipc	ra,0xfffff
    800040a4:	0be080e7          	jalr	190(ra) # 8000315e <bunpin>
    800040a8:	b769                	j	80004032 <install_trans+0x36>
}
    800040aa:	70e2                	ld	ra,56(sp)
    800040ac:	7442                	ld	s0,48(sp)
    800040ae:	74a2                	ld	s1,40(sp)
    800040b0:	7902                	ld	s2,32(sp)
    800040b2:	69e2                	ld	s3,24(sp)
    800040b4:	6a42                	ld	s4,16(sp)
    800040b6:	6aa2                	ld	s5,8(sp)
    800040b8:	6b02                	ld	s6,0(sp)
    800040ba:	6121                	addi	sp,sp,64
    800040bc:	8082                	ret
    800040be:	8082                	ret

00000000800040c0 <initlog>:
{
    800040c0:	7179                	addi	sp,sp,-48
    800040c2:	f406                	sd	ra,40(sp)
    800040c4:	f022                	sd	s0,32(sp)
    800040c6:	ec26                	sd	s1,24(sp)
    800040c8:	e84a                	sd	s2,16(sp)
    800040ca:	e44e                	sd	s3,8(sp)
    800040cc:	1800                	addi	s0,sp,48
    800040ce:	892a                	mv	s2,a0
    800040d0:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800040d2:	0001f497          	auipc	s1,0x1f
    800040d6:	3ce48493          	addi	s1,s1,974 # 800234a0 <log>
    800040da:	00004597          	auipc	a1,0x4
    800040de:	44658593          	addi	a1,a1,1094 # 80008520 <etext+0x520>
    800040e2:	8526                	mv	a0,s1
    800040e4:	ffffd097          	auipc	ra,0xffffd
    800040e8:	adc080e7          	jalr	-1316(ra) # 80000bc0 <initlock>
  log.start = sb->logstart;
    800040ec:	0149a583          	lw	a1,20(s3)
    800040f0:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800040f2:	0109a783          	lw	a5,16(s3)
    800040f6:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800040f8:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800040fc:	854a                	mv	a0,s2
    800040fe:	fffff097          	auipc	ra,0xfffff
    80004102:	e58080e7          	jalr	-424(ra) # 80002f56 <bread>
  log.lh.n = lh->n;
    80004106:	4d30                	lw	a2,88(a0)
    80004108:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000410a:	00c05f63          	blez	a2,80004128 <initlog+0x68>
    8000410e:	87aa                	mv	a5,a0
    80004110:	0001f717          	auipc	a4,0x1f
    80004114:	3c070713          	addi	a4,a4,960 # 800234d0 <log+0x30>
    80004118:	060a                	slli	a2,a2,0x2
    8000411a:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000411c:	4ff4                	lw	a3,92(a5)
    8000411e:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004120:	0791                	addi	a5,a5,4
    80004122:	0711                	addi	a4,a4,4
    80004124:	fec79ce3          	bne	a5,a2,8000411c <initlog+0x5c>
  brelse(buf);
    80004128:	fffff097          	auipc	ra,0xfffff
    8000412c:	f5e080e7          	jalr	-162(ra) # 80003086 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004130:	4505                	li	a0,1
    80004132:	00000097          	auipc	ra,0x0
    80004136:	eca080e7          	jalr	-310(ra) # 80003ffc <install_trans>
  log.lh.n = 0;
    8000413a:	0001f797          	auipc	a5,0x1f
    8000413e:	3807a923          	sw	zero,914(a5) # 800234cc <log+0x2c>
  write_head(); // clear the log
    80004142:	00000097          	auipc	ra,0x0
    80004146:	e50080e7          	jalr	-432(ra) # 80003f92 <write_head>
}
    8000414a:	70a2                	ld	ra,40(sp)
    8000414c:	7402                	ld	s0,32(sp)
    8000414e:	64e2                	ld	s1,24(sp)
    80004150:	6942                	ld	s2,16(sp)
    80004152:	69a2                	ld	s3,8(sp)
    80004154:	6145                	addi	sp,sp,48
    80004156:	8082                	ret

0000000080004158 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004158:	1101                	addi	sp,sp,-32
    8000415a:	ec06                	sd	ra,24(sp)
    8000415c:	e822                	sd	s0,16(sp)
    8000415e:	e426                	sd	s1,8(sp)
    80004160:	e04a                	sd	s2,0(sp)
    80004162:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004164:	0001f517          	auipc	a0,0x1f
    80004168:	33c50513          	addi	a0,a0,828 # 800234a0 <log>
    8000416c:	ffffd097          	auipc	ra,0xffffd
    80004170:	ae4080e7          	jalr	-1308(ra) # 80000c50 <acquire>
  while(1){
    if(log.committing){
    80004174:	0001f497          	auipc	s1,0x1f
    80004178:	32c48493          	addi	s1,s1,812 # 800234a0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000417c:	4979                	li	s2,30
    8000417e:	a039                	j	8000418c <begin_op+0x34>
      sleep(&log, &log.lock);
    80004180:	85a6                	mv	a1,s1
    80004182:	8526                	mv	a0,s1
    80004184:	ffffe097          	auipc	ra,0xffffe
    80004188:	fa8080e7          	jalr	-88(ra) # 8000212c <sleep>
    if(log.committing){
    8000418c:	50dc                	lw	a5,36(s1)
    8000418e:	fbed                	bnez	a5,80004180 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004190:	5098                	lw	a4,32(s1)
    80004192:	2705                	addiw	a4,a4,1
    80004194:	0027179b          	slliw	a5,a4,0x2
    80004198:	9fb9                	addw	a5,a5,a4
    8000419a:	0017979b          	slliw	a5,a5,0x1
    8000419e:	54d4                	lw	a3,44(s1)
    800041a0:	9fb5                	addw	a5,a5,a3
    800041a2:	00f95963          	bge	s2,a5,800041b4 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800041a6:	85a6                	mv	a1,s1
    800041a8:	8526                	mv	a0,s1
    800041aa:	ffffe097          	auipc	ra,0xffffe
    800041ae:	f82080e7          	jalr	-126(ra) # 8000212c <sleep>
    800041b2:	bfe9                	j	8000418c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800041b4:	0001f517          	auipc	a0,0x1f
    800041b8:	2ec50513          	addi	a0,a0,748 # 800234a0 <log>
    800041bc:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800041be:	ffffd097          	auipc	ra,0xffffd
    800041c2:	b46080e7          	jalr	-1210(ra) # 80000d04 <release>
      break;
    }
  }
}
    800041c6:	60e2                	ld	ra,24(sp)
    800041c8:	6442                	ld	s0,16(sp)
    800041ca:	64a2                	ld	s1,8(sp)
    800041cc:	6902                	ld	s2,0(sp)
    800041ce:	6105                	addi	sp,sp,32
    800041d0:	8082                	ret

00000000800041d2 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800041d2:	7139                	addi	sp,sp,-64
    800041d4:	fc06                	sd	ra,56(sp)
    800041d6:	f822                	sd	s0,48(sp)
    800041d8:	f426                	sd	s1,40(sp)
    800041da:	f04a                	sd	s2,32(sp)
    800041dc:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800041de:	0001f497          	auipc	s1,0x1f
    800041e2:	2c248493          	addi	s1,s1,706 # 800234a0 <log>
    800041e6:	8526                	mv	a0,s1
    800041e8:	ffffd097          	auipc	ra,0xffffd
    800041ec:	a68080e7          	jalr	-1432(ra) # 80000c50 <acquire>
  log.outstanding -= 1;
    800041f0:	509c                	lw	a5,32(s1)
    800041f2:	37fd                	addiw	a5,a5,-1
    800041f4:	0007891b          	sext.w	s2,a5
    800041f8:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800041fa:	50dc                	lw	a5,36(s1)
    800041fc:	e7b9                	bnez	a5,8000424a <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    800041fe:	06091163          	bnez	s2,80004260 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004202:	0001f497          	auipc	s1,0x1f
    80004206:	29e48493          	addi	s1,s1,670 # 800234a0 <log>
    8000420a:	4785                	li	a5,1
    8000420c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000420e:	8526                	mv	a0,s1
    80004210:	ffffd097          	auipc	ra,0xffffd
    80004214:	af4080e7          	jalr	-1292(ra) # 80000d04 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004218:	54dc                	lw	a5,44(s1)
    8000421a:	06f04763          	bgtz	a5,80004288 <end_op+0xb6>
    acquire(&log.lock);
    8000421e:	0001f497          	auipc	s1,0x1f
    80004222:	28248493          	addi	s1,s1,642 # 800234a0 <log>
    80004226:	8526                	mv	a0,s1
    80004228:	ffffd097          	auipc	ra,0xffffd
    8000422c:	a28080e7          	jalr	-1496(ra) # 80000c50 <acquire>
    log.committing = 0;
    80004230:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004234:	8526                	mv	a0,s1
    80004236:	ffffe097          	auipc	ra,0xffffe
    8000423a:	f5a080e7          	jalr	-166(ra) # 80002190 <wakeup>
    release(&log.lock);
    8000423e:	8526                	mv	a0,s1
    80004240:	ffffd097          	auipc	ra,0xffffd
    80004244:	ac4080e7          	jalr	-1340(ra) # 80000d04 <release>
}
    80004248:	a815                	j	8000427c <end_op+0xaa>
    8000424a:	ec4e                	sd	s3,24(sp)
    8000424c:	e852                	sd	s4,16(sp)
    8000424e:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80004250:	00004517          	auipc	a0,0x4
    80004254:	2d850513          	addi	a0,a0,728 # 80008528 <etext+0x528>
    80004258:	ffffc097          	auipc	ra,0xffffc
    8000425c:	308080e7          	jalr	776(ra) # 80000560 <panic>
    wakeup(&log);
    80004260:	0001f497          	auipc	s1,0x1f
    80004264:	24048493          	addi	s1,s1,576 # 800234a0 <log>
    80004268:	8526                	mv	a0,s1
    8000426a:	ffffe097          	auipc	ra,0xffffe
    8000426e:	f26080e7          	jalr	-218(ra) # 80002190 <wakeup>
  release(&log.lock);
    80004272:	8526                	mv	a0,s1
    80004274:	ffffd097          	auipc	ra,0xffffd
    80004278:	a90080e7          	jalr	-1392(ra) # 80000d04 <release>
}
    8000427c:	70e2                	ld	ra,56(sp)
    8000427e:	7442                	ld	s0,48(sp)
    80004280:	74a2                	ld	s1,40(sp)
    80004282:	7902                	ld	s2,32(sp)
    80004284:	6121                	addi	sp,sp,64
    80004286:	8082                	ret
    80004288:	ec4e                	sd	s3,24(sp)
    8000428a:	e852                	sd	s4,16(sp)
    8000428c:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000428e:	0001fa97          	auipc	s5,0x1f
    80004292:	242a8a93          	addi	s5,s5,578 # 800234d0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004296:	0001fa17          	auipc	s4,0x1f
    8000429a:	20aa0a13          	addi	s4,s4,522 # 800234a0 <log>
    8000429e:	018a2583          	lw	a1,24(s4)
    800042a2:	012585bb          	addw	a1,a1,s2
    800042a6:	2585                	addiw	a1,a1,1
    800042a8:	028a2503          	lw	a0,40(s4)
    800042ac:	fffff097          	auipc	ra,0xfffff
    800042b0:	caa080e7          	jalr	-854(ra) # 80002f56 <bread>
    800042b4:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800042b6:	000aa583          	lw	a1,0(s5)
    800042ba:	028a2503          	lw	a0,40(s4)
    800042be:	fffff097          	auipc	ra,0xfffff
    800042c2:	c98080e7          	jalr	-872(ra) # 80002f56 <bread>
    800042c6:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800042c8:	40000613          	li	a2,1024
    800042cc:	05850593          	addi	a1,a0,88
    800042d0:	05848513          	addi	a0,s1,88
    800042d4:	ffffd097          	auipc	ra,0xffffd
    800042d8:	ad4080e7          	jalr	-1324(ra) # 80000da8 <memmove>
    bwrite(to);  // write the log
    800042dc:	8526                	mv	a0,s1
    800042de:	fffff097          	auipc	ra,0xfffff
    800042e2:	d6a080e7          	jalr	-662(ra) # 80003048 <bwrite>
    brelse(from);
    800042e6:	854e                	mv	a0,s3
    800042e8:	fffff097          	auipc	ra,0xfffff
    800042ec:	d9e080e7          	jalr	-610(ra) # 80003086 <brelse>
    brelse(to);
    800042f0:	8526                	mv	a0,s1
    800042f2:	fffff097          	auipc	ra,0xfffff
    800042f6:	d94080e7          	jalr	-620(ra) # 80003086 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800042fa:	2905                	addiw	s2,s2,1
    800042fc:	0a91                	addi	s5,s5,4
    800042fe:	02ca2783          	lw	a5,44(s4)
    80004302:	f8f94ee3          	blt	s2,a5,8000429e <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004306:	00000097          	auipc	ra,0x0
    8000430a:	c8c080e7          	jalr	-884(ra) # 80003f92 <write_head>
    install_trans(0); // Now install writes to home locations
    8000430e:	4501                	li	a0,0
    80004310:	00000097          	auipc	ra,0x0
    80004314:	cec080e7          	jalr	-788(ra) # 80003ffc <install_trans>
    log.lh.n = 0;
    80004318:	0001f797          	auipc	a5,0x1f
    8000431c:	1a07aa23          	sw	zero,436(a5) # 800234cc <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004320:	00000097          	auipc	ra,0x0
    80004324:	c72080e7          	jalr	-910(ra) # 80003f92 <write_head>
    80004328:	69e2                	ld	s3,24(sp)
    8000432a:	6a42                	ld	s4,16(sp)
    8000432c:	6aa2                	ld	s5,8(sp)
    8000432e:	bdc5                	j	8000421e <end_op+0x4c>

0000000080004330 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004330:	1101                	addi	sp,sp,-32
    80004332:	ec06                	sd	ra,24(sp)
    80004334:	e822                	sd	s0,16(sp)
    80004336:	e426                	sd	s1,8(sp)
    80004338:	e04a                	sd	s2,0(sp)
    8000433a:	1000                	addi	s0,sp,32
    8000433c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000433e:	0001f917          	auipc	s2,0x1f
    80004342:	16290913          	addi	s2,s2,354 # 800234a0 <log>
    80004346:	854a                	mv	a0,s2
    80004348:	ffffd097          	auipc	ra,0xffffd
    8000434c:	908080e7          	jalr	-1784(ra) # 80000c50 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004350:	02c92603          	lw	a2,44(s2)
    80004354:	47f5                	li	a5,29
    80004356:	06c7c563          	blt	a5,a2,800043c0 <log_write+0x90>
    8000435a:	0001f797          	auipc	a5,0x1f
    8000435e:	1627a783          	lw	a5,354(a5) # 800234bc <log+0x1c>
    80004362:	37fd                	addiw	a5,a5,-1
    80004364:	04f65e63          	bge	a2,a5,800043c0 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004368:	0001f797          	auipc	a5,0x1f
    8000436c:	1587a783          	lw	a5,344(a5) # 800234c0 <log+0x20>
    80004370:	06f05063          	blez	a5,800043d0 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004374:	4781                	li	a5,0
    80004376:	06c05563          	blez	a2,800043e0 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000437a:	44cc                	lw	a1,12(s1)
    8000437c:	0001f717          	auipc	a4,0x1f
    80004380:	15470713          	addi	a4,a4,340 # 800234d0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004384:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004386:	4314                	lw	a3,0(a4)
    80004388:	04b68c63          	beq	a3,a1,800043e0 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000438c:	2785                	addiw	a5,a5,1
    8000438e:	0711                	addi	a4,a4,4
    80004390:	fef61be3          	bne	a2,a5,80004386 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004394:	0621                	addi	a2,a2,8
    80004396:	060a                	slli	a2,a2,0x2
    80004398:	0001f797          	auipc	a5,0x1f
    8000439c:	10878793          	addi	a5,a5,264 # 800234a0 <log>
    800043a0:	97b2                	add	a5,a5,a2
    800043a2:	44d8                	lw	a4,12(s1)
    800043a4:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800043a6:	8526                	mv	a0,s1
    800043a8:	fffff097          	auipc	ra,0xfffff
    800043ac:	d7a080e7          	jalr	-646(ra) # 80003122 <bpin>
    log.lh.n++;
    800043b0:	0001f717          	auipc	a4,0x1f
    800043b4:	0f070713          	addi	a4,a4,240 # 800234a0 <log>
    800043b8:	575c                	lw	a5,44(a4)
    800043ba:	2785                	addiw	a5,a5,1
    800043bc:	d75c                	sw	a5,44(a4)
    800043be:	a82d                	j	800043f8 <log_write+0xc8>
    panic("too big a transaction");
    800043c0:	00004517          	auipc	a0,0x4
    800043c4:	17850513          	addi	a0,a0,376 # 80008538 <etext+0x538>
    800043c8:	ffffc097          	auipc	ra,0xffffc
    800043cc:	198080e7          	jalr	408(ra) # 80000560 <panic>
    panic("log_write outside of trans");
    800043d0:	00004517          	auipc	a0,0x4
    800043d4:	18050513          	addi	a0,a0,384 # 80008550 <etext+0x550>
    800043d8:	ffffc097          	auipc	ra,0xffffc
    800043dc:	188080e7          	jalr	392(ra) # 80000560 <panic>
  log.lh.block[i] = b->blockno;
    800043e0:	00878693          	addi	a3,a5,8
    800043e4:	068a                	slli	a3,a3,0x2
    800043e6:	0001f717          	auipc	a4,0x1f
    800043ea:	0ba70713          	addi	a4,a4,186 # 800234a0 <log>
    800043ee:	9736                	add	a4,a4,a3
    800043f0:	44d4                	lw	a3,12(s1)
    800043f2:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800043f4:	faf609e3          	beq	a2,a5,800043a6 <log_write+0x76>
  }
  release(&log.lock);
    800043f8:	0001f517          	auipc	a0,0x1f
    800043fc:	0a850513          	addi	a0,a0,168 # 800234a0 <log>
    80004400:	ffffd097          	auipc	ra,0xffffd
    80004404:	904080e7          	jalr	-1788(ra) # 80000d04 <release>
}
    80004408:	60e2                	ld	ra,24(sp)
    8000440a:	6442                	ld	s0,16(sp)
    8000440c:	64a2                	ld	s1,8(sp)
    8000440e:	6902                	ld	s2,0(sp)
    80004410:	6105                	addi	sp,sp,32
    80004412:	8082                	ret

0000000080004414 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004414:	1101                	addi	sp,sp,-32
    80004416:	ec06                	sd	ra,24(sp)
    80004418:	e822                	sd	s0,16(sp)
    8000441a:	e426                	sd	s1,8(sp)
    8000441c:	e04a                	sd	s2,0(sp)
    8000441e:	1000                	addi	s0,sp,32
    80004420:	84aa                	mv	s1,a0
    80004422:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004424:	00004597          	auipc	a1,0x4
    80004428:	14c58593          	addi	a1,a1,332 # 80008570 <etext+0x570>
    8000442c:	0521                	addi	a0,a0,8
    8000442e:	ffffc097          	auipc	ra,0xffffc
    80004432:	792080e7          	jalr	1938(ra) # 80000bc0 <initlock>
  lk->name = name;
    80004436:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000443a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000443e:	0204a423          	sw	zero,40(s1)
}
    80004442:	60e2                	ld	ra,24(sp)
    80004444:	6442                	ld	s0,16(sp)
    80004446:	64a2                	ld	s1,8(sp)
    80004448:	6902                	ld	s2,0(sp)
    8000444a:	6105                	addi	sp,sp,32
    8000444c:	8082                	ret

000000008000444e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000444e:	1101                	addi	sp,sp,-32
    80004450:	ec06                	sd	ra,24(sp)
    80004452:	e822                	sd	s0,16(sp)
    80004454:	e426                	sd	s1,8(sp)
    80004456:	e04a                	sd	s2,0(sp)
    80004458:	1000                	addi	s0,sp,32
    8000445a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000445c:	00850913          	addi	s2,a0,8
    80004460:	854a                	mv	a0,s2
    80004462:	ffffc097          	auipc	ra,0xffffc
    80004466:	7ee080e7          	jalr	2030(ra) # 80000c50 <acquire>
  while (lk->locked) {
    8000446a:	409c                	lw	a5,0(s1)
    8000446c:	cb89                	beqz	a5,8000447e <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000446e:	85ca                	mv	a1,s2
    80004470:	8526                	mv	a0,s1
    80004472:	ffffe097          	auipc	ra,0xffffe
    80004476:	cba080e7          	jalr	-838(ra) # 8000212c <sleep>
  while (lk->locked) {
    8000447a:	409c                	lw	a5,0(s1)
    8000447c:	fbed                	bnez	a5,8000446e <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000447e:	4785                	li	a5,1
    80004480:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004482:	ffffd097          	auipc	ra,0xffffd
    80004486:	5e0080e7          	jalr	1504(ra) # 80001a62 <myproc>
    8000448a:	591c                	lw	a5,48(a0)
    8000448c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000448e:	854a                	mv	a0,s2
    80004490:	ffffd097          	auipc	ra,0xffffd
    80004494:	874080e7          	jalr	-1932(ra) # 80000d04 <release>
}
    80004498:	60e2                	ld	ra,24(sp)
    8000449a:	6442                	ld	s0,16(sp)
    8000449c:	64a2                	ld	s1,8(sp)
    8000449e:	6902                	ld	s2,0(sp)
    800044a0:	6105                	addi	sp,sp,32
    800044a2:	8082                	ret

00000000800044a4 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800044a4:	1101                	addi	sp,sp,-32
    800044a6:	ec06                	sd	ra,24(sp)
    800044a8:	e822                	sd	s0,16(sp)
    800044aa:	e426                	sd	s1,8(sp)
    800044ac:	e04a                	sd	s2,0(sp)
    800044ae:	1000                	addi	s0,sp,32
    800044b0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800044b2:	00850913          	addi	s2,a0,8
    800044b6:	854a                	mv	a0,s2
    800044b8:	ffffc097          	auipc	ra,0xffffc
    800044bc:	798080e7          	jalr	1944(ra) # 80000c50 <acquire>
  lk->locked = 0;
    800044c0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800044c4:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800044c8:	8526                	mv	a0,s1
    800044ca:	ffffe097          	auipc	ra,0xffffe
    800044ce:	cc6080e7          	jalr	-826(ra) # 80002190 <wakeup>
  release(&lk->lk);
    800044d2:	854a                	mv	a0,s2
    800044d4:	ffffd097          	auipc	ra,0xffffd
    800044d8:	830080e7          	jalr	-2000(ra) # 80000d04 <release>
}
    800044dc:	60e2                	ld	ra,24(sp)
    800044de:	6442                	ld	s0,16(sp)
    800044e0:	64a2                	ld	s1,8(sp)
    800044e2:	6902                	ld	s2,0(sp)
    800044e4:	6105                	addi	sp,sp,32
    800044e6:	8082                	ret

00000000800044e8 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800044e8:	7179                	addi	sp,sp,-48
    800044ea:	f406                	sd	ra,40(sp)
    800044ec:	f022                	sd	s0,32(sp)
    800044ee:	ec26                	sd	s1,24(sp)
    800044f0:	e84a                	sd	s2,16(sp)
    800044f2:	1800                	addi	s0,sp,48
    800044f4:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800044f6:	00850913          	addi	s2,a0,8
    800044fa:	854a                	mv	a0,s2
    800044fc:	ffffc097          	auipc	ra,0xffffc
    80004500:	754080e7          	jalr	1876(ra) # 80000c50 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004504:	409c                	lw	a5,0(s1)
    80004506:	ef91                	bnez	a5,80004522 <holdingsleep+0x3a>
    80004508:	4481                	li	s1,0
  release(&lk->lk);
    8000450a:	854a                	mv	a0,s2
    8000450c:	ffffc097          	auipc	ra,0xffffc
    80004510:	7f8080e7          	jalr	2040(ra) # 80000d04 <release>
  return r;
}
    80004514:	8526                	mv	a0,s1
    80004516:	70a2                	ld	ra,40(sp)
    80004518:	7402                	ld	s0,32(sp)
    8000451a:	64e2                	ld	s1,24(sp)
    8000451c:	6942                	ld	s2,16(sp)
    8000451e:	6145                	addi	sp,sp,48
    80004520:	8082                	ret
    80004522:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004524:	0284a983          	lw	s3,40(s1)
    80004528:	ffffd097          	auipc	ra,0xffffd
    8000452c:	53a080e7          	jalr	1338(ra) # 80001a62 <myproc>
    80004530:	5904                	lw	s1,48(a0)
    80004532:	413484b3          	sub	s1,s1,s3
    80004536:	0014b493          	seqz	s1,s1
    8000453a:	69a2                	ld	s3,8(sp)
    8000453c:	b7f9                	j	8000450a <holdingsleep+0x22>

000000008000453e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000453e:	1141                	addi	sp,sp,-16
    80004540:	e406                	sd	ra,8(sp)
    80004542:	e022                	sd	s0,0(sp)
    80004544:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004546:	00004597          	auipc	a1,0x4
    8000454a:	03a58593          	addi	a1,a1,58 # 80008580 <etext+0x580>
    8000454e:	0001f517          	auipc	a0,0x1f
    80004552:	09a50513          	addi	a0,a0,154 # 800235e8 <ftable>
    80004556:	ffffc097          	auipc	ra,0xffffc
    8000455a:	66a080e7          	jalr	1642(ra) # 80000bc0 <initlock>
}
    8000455e:	60a2                	ld	ra,8(sp)
    80004560:	6402                	ld	s0,0(sp)
    80004562:	0141                	addi	sp,sp,16
    80004564:	8082                	ret

0000000080004566 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004566:	1101                	addi	sp,sp,-32
    80004568:	ec06                	sd	ra,24(sp)
    8000456a:	e822                	sd	s0,16(sp)
    8000456c:	e426                	sd	s1,8(sp)
    8000456e:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004570:	0001f517          	auipc	a0,0x1f
    80004574:	07850513          	addi	a0,a0,120 # 800235e8 <ftable>
    80004578:	ffffc097          	auipc	ra,0xffffc
    8000457c:	6d8080e7          	jalr	1752(ra) # 80000c50 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004580:	0001f497          	auipc	s1,0x1f
    80004584:	08048493          	addi	s1,s1,128 # 80023600 <ftable+0x18>
    80004588:	00020717          	auipc	a4,0x20
    8000458c:	01870713          	addi	a4,a4,24 # 800245a0 <disk>
    if(f->ref == 0){
    80004590:	40dc                	lw	a5,4(s1)
    80004592:	cf99                	beqz	a5,800045b0 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004594:	02848493          	addi	s1,s1,40
    80004598:	fee49ce3          	bne	s1,a4,80004590 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000459c:	0001f517          	auipc	a0,0x1f
    800045a0:	04c50513          	addi	a0,a0,76 # 800235e8 <ftable>
    800045a4:	ffffc097          	auipc	ra,0xffffc
    800045a8:	760080e7          	jalr	1888(ra) # 80000d04 <release>
  return 0;
    800045ac:	4481                	li	s1,0
    800045ae:	a819                	j	800045c4 <filealloc+0x5e>
      f->ref = 1;
    800045b0:	4785                	li	a5,1
    800045b2:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800045b4:	0001f517          	auipc	a0,0x1f
    800045b8:	03450513          	addi	a0,a0,52 # 800235e8 <ftable>
    800045bc:	ffffc097          	auipc	ra,0xffffc
    800045c0:	748080e7          	jalr	1864(ra) # 80000d04 <release>
}
    800045c4:	8526                	mv	a0,s1
    800045c6:	60e2                	ld	ra,24(sp)
    800045c8:	6442                	ld	s0,16(sp)
    800045ca:	64a2                	ld	s1,8(sp)
    800045cc:	6105                	addi	sp,sp,32
    800045ce:	8082                	ret

00000000800045d0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800045d0:	1101                	addi	sp,sp,-32
    800045d2:	ec06                	sd	ra,24(sp)
    800045d4:	e822                	sd	s0,16(sp)
    800045d6:	e426                	sd	s1,8(sp)
    800045d8:	1000                	addi	s0,sp,32
    800045da:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800045dc:	0001f517          	auipc	a0,0x1f
    800045e0:	00c50513          	addi	a0,a0,12 # 800235e8 <ftable>
    800045e4:	ffffc097          	auipc	ra,0xffffc
    800045e8:	66c080e7          	jalr	1644(ra) # 80000c50 <acquire>
  if(f->ref < 1)
    800045ec:	40dc                	lw	a5,4(s1)
    800045ee:	02f05263          	blez	a5,80004612 <filedup+0x42>
    panic("filedup");
  f->ref++;
    800045f2:	2785                	addiw	a5,a5,1
    800045f4:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800045f6:	0001f517          	auipc	a0,0x1f
    800045fa:	ff250513          	addi	a0,a0,-14 # 800235e8 <ftable>
    800045fe:	ffffc097          	auipc	ra,0xffffc
    80004602:	706080e7          	jalr	1798(ra) # 80000d04 <release>
  return f;
}
    80004606:	8526                	mv	a0,s1
    80004608:	60e2                	ld	ra,24(sp)
    8000460a:	6442                	ld	s0,16(sp)
    8000460c:	64a2                	ld	s1,8(sp)
    8000460e:	6105                	addi	sp,sp,32
    80004610:	8082                	ret
    panic("filedup");
    80004612:	00004517          	auipc	a0,0x4
    80004616:	f7650513          	addi	a0,a0,-138 # 80008588 <etext+0x588>
    8000461a:	ffffc097          	auipc	ra,0xffffc
    8000461e:	f46080e7          	jalr	-186(ra) # 80000560 <panic>

0000000080004622 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004622:	7139                	addi	sp,sp,-64
    80004624:	fc06                	sd	ra,56(sp)
    80004626:	f822                	sd	s0,48(sp)
    80004628:	f426                	sd	s1,40(sp)
    8000462a:	0080                	addi	s0,sp,64
    8000462c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000462e:	0001f517          	auipc	a0,0x1f
    80004632:	fba50513          	addi	a0,a0,-70 # 800235e8 <ftable>
    80004636:	ffffc097          	auipc	ra,0xffffc
    8000463a:	61a080e7          	jalr	1562(ra) # 80000c50 <acquire>
  if(f->ref < 1)
    8000463e:	40dc                	lw	a5,4(s1)
    80004640:	04f05c63          	blez	a5,80004698 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80004644:	37fd                	addiw	a5,a5,-1
    80004646:	0007871b          	sext.w	a4,a5
    8000464a:	c0dc                	sw	a5,4(s1)
    8000464c:	06e04263          	bgtz	a4,800046b0 <fileclose+0x8e>
    80004650:	f04a                	sd	s2,32(sp)
    80004652:	ec4e                	sd	s3,24(sp)
    80004654:	e852                	sd	s4,16(sp)
    80004656:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004658:	0004a903          	lw	s2,0(s1)
    8000465c:	0094ca83          	lbu	s5,9(s1)
    80004660:	0104ba03          	ld	s4,16(s1)
    80004664:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004668:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000466c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004670:	0001f517          	auipc	a0,0x1f
    80004674:	f7850513          	addi	a0,a0,-136 # 800235e8 <ftable>
    80004678:	ffffc097          	auipc	ra,0xffffc
    8000467c:	68c080e7          	jalr	1676(ra) # 80000d04 <release>

  if(ff.type == FD_PIPE){
    80004680:	4785                	li	a5,1
    80004682:	04f90463          	beq	s2,a5,800046ca <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004686:	3979                	addiw	s2,s2,-2
    80004688:	4785                	li	a5,1
    8000468a:	0527fb63          	bgeu	a5,s2,800046e0 <fileclose+0xbe>
    8000468e:	7902                	ld	s2,32(sp)
    80004690:	69e2                	ld	s3,24(sp)
    80004692:	6a42                	ld	s4,16(sp)
    80004694:	6aa2                	ld	s5,8(sp)
    80004696:	a02d                	j	800046c0 <fileclose+0x9e>
    80004698:	f04a                	sd	s2,32(sp)
    8000469a:	ec4e                	sd	s3,24(sp)
    8000469c:	e852                	sd	s4,16(sp)
    8000469e:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800046a0:	00004517          	auipc	a0,0x4
    800046a4:	ef050513          	addi	a0,a0,-272 # 80008590 <etext+0x590>
    800046a8:	ffffc097          	auipc	ra,0xffffc
    800046ac:	eb8080e7          	jalr	-328(ra) # 80000560 <panic>
    release(&ftable.lock);
    800046b0:	0001f517          	auipc	a0,0x1f
    800046b4:	f3850513          	addi	a0,a0,-200 # 800235e8 <ftable>
    800046b8:	ffffc097          	auipc	ra,0xffffc
    800046bc:	64c080e7          	jalr	1612(ra) # 80000d04 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800046c0:	70e2                	ld	ra,56(sp)
    800046c2:	7442                	ld	s0,48(sp)
    800046c4:	74a2                	ld	s1,40(sp)
    800046c6:	6121                	addi	sp,sp,64
    800046c8:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800046ca:	85d6                	mv	a1,s5
    800046cc:	8552                	mv	a0,s4
    800046ce:	00000097          	auipc	ra,0x0
    800046d2:	3a2080e7          	jalr	930(ra) # 80004a70 <pipeclose>
    800046d6:	7902                	ld	s2,32(sp)
    800046d8:	69e2                	ld	s3,24(sp)
    800046da:	6a42                	ld	s4,16(sp)
    800046dc:	6aa2                	ld	s5,8(sp)
    800046de:	b7cd                	j	800046c0 <fileclose+0x9e>
    begin_op();
    800046e0:	00000097          	auipc	ra,0x0
    800046e4:	a78080e7          	jalr	-1416(ra) # 80004158 <begin_op>
    iput(ff.ip);
    800046e8:	854e                	mv	a0,s3
    800046ea:	fffff097          	auipc	ra,0xfffff
    800046ee:	25e080e7          	jalr	606(ra) # 80003948 <iput>
    end_op();
    800046f2:	00000097          	auipc	ra,0x0
    800046f6:	ae0080e7          	jalr	-1312(ra) # 800041d2 <end_op>
    800046fa:	7902                	ld	s2,32(sp)
    800046fc:	69e2                	ld	s3,24(sp)
    800046fe:	6a42                	ld	s4,16(sp)
    80004700:	6aa2                	ld	s5,8(sp)
    80004702:	bf7d                	j	800046c0 <fileclose+0x9e>

0000000080004704 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004704:	715d                	addi	sp,sp,-80
    80004706:	e486                	sd	ra,72(sp)
    80004708:	e0a2                	sd	s0,64(sp)
    8000470a:	fc26                	sd	s1,56(sp)
    8000470c:	f44e                	sd	s3,40(sp)
    8000470e:	0880                	addi	s0,sp,80
    80004710:	84aa                	mv	s1,a0
    80004712:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004714:	ffffd097          	auipc	ra,0xffffd
    80004718:	34e080e7          	jalr	846(ra) # 80001a62 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000471c:	409c                	lw	a5,0(s1)
    8000471e:	37f9                	addiw	a5,a5,-2
    80004720:	4705                	li	a4,1
    80004722:	04f76863          	bltu	a4,a5,80004772 <filestat+0x6e>
    80004726:	f84a                	sd	s2,48(sp)
    80004728:	892a                	mv	s2,a0
    ilock(f->ip);
    8000472a:	6c88                	ld	a0,24(s1)
    8000472c:	fffff097          	auipc	ra,0xfffff
    80004730:	05e080e7          	jalr	94(ra) # 8000378a <ilock>
    stati(f->ip, &st);
    80004734:	fb840593          	addi	a1,s0,-72
    80004738:	6c88                	ld	a0,24(s1)
    8000473a:	fffff097          	auipc	ra,0xfffff
    8000473e:	2de080e7          	jalr	734(ra) # 80003a18 <stati>
    iunlock(f->ip);
    80004742:	6c88                	ld	a0,24(s1)
    80004744:	fffff097          	auipc	ra,0xfffff
    80004748:	10c080e7          	jalr	268(ra) # 80003850 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000474c:	46e1                	li	a3,24
    8000474e:	fb840613          	addi	a2,s0,-72
    80004752:	85ce                	mv	a1,s3
    80004754:	05093503          	ld	a0,80(s2)
    80004758:	ffffd097          	auipc	ra,0xffffd
    8000475c:	fa2080e7          	jalr	-94(ra) # 800016fa <copyout>
    80004760:	41f5551b          	sraiw	a0,a0,0x1f
    80004764:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004766:	60a6                	ld	ra,72(sp)
    80004768:	6406                	ld	s0,64(sp)
    8000476a:	74e2                	ld	s1,56(sp)
    8000476c:	79a2                	ld	s3,40(sp)
    8000476e:	6161                	addi	sp,sp,80
    80004770:	8082                	ret
  return -1;
    80004772:	557d                	li	a0,-1
    80004774:	bfcd                	j	80004766 <filestat+0x62>

0000000080004776 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004776:	7179                	addi	sp,sp,-48
    80004778:	f406                	sd	ra,40(sp)
    8000477a:	f022                	sd	s0,32(sp)
    8000477c:	e84a                	sd	s2,16(sp)
    8000477e:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004780:	00854783          	lbu	a5,8(a0)
    80004784:	cbc5                	beqz	a5,80004834 <fileread+0xbe>
    80004786:	ec26                	sd	s1,24(sp)
    80004788:	e44e                	sd	s3,8(sp)
    8000478a:	84aa                	mv	s1,a0
    8000478c:	89ae                	mv	s3,a1
    8000478e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004790:	411c                	lw	a5,0(a0)
    80004792:	4705                	li	a4,1
    80004794:	04e78963          	beq	a5,a4,800047e6 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004798:	470d                	li	a4,3
    8000479a:	04e78f63          	beq	a5,a4,800047f8 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000479e:	4709                	li	a4,2
    800047a0:	08e79263          	bne	a5,a4,80004824 <fileread+0xae>
    ilock(f->ip);
    800047a4:	6d08                	ld	a0,24(a0)
    800047a6:	fffff097          	auipc	ra,0xfffff
    800047aa:	fe4080e7          	jalr	-28(ra) # 8000378a <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800047ae:	874a                	mv	a4,s2
    800047b0:	5094                	lw	a3,32(s1)
    800047b2:	864e                	mv	a2,s3
    800047b4:	4585                	li	a1,1
    800047b6:	6c88                	ld	a0,24(s1)
    800047b8:	fffff097          	auipc	ra,0xfffff
    800047bc:	28a080e7          	jalr	650(ra) # 80003a42 <readi>
    800047c0:	892a                	mv	s2,a0
    800047c2:	00a05563          	blez	a0,800047cc <fileread+0x56>
      f->off += r;
    800047c6:	509c                	lw	a5,32(s1)
    800047c8:	9fa9                	addw	a5,a5,a0
    800047ca:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800047cc:	6c88                	ld	a0,24(s1)
    800047ce:	fffff097          	auipc	ra,0xfffff
    800047d2:	082080e7          	jalr	130(ra) # 80003850 <iunlock>
    800047d6:	64e2                	ld	s1,24(sp)
    800047d8:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    800047da:	854a                	mv	a0,s2
    800047dc:	70a2                	ld	ra,40(sp)
    800047de:	7402                	ld	s0,32(sp)
    800047e0:	6942                	ld	s2,16(sp)
    800047e2:	6145                	addi	sp,sp,48
    800047e4:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800047e6:	6908                	ld	a0,16(a0)
    800047e8:	00000097          	auipc	ra,0x0
    800047ec:	400080e7          	jalr	1024(ra) # 80004be8 <piperead>
    800047f0:	892a                	mv	s2,a0
    800047f2:	64e2                	ld	s1,24(sp)
    800047f4:	69a2                	ld	s3,8(sp)
    800047f6:	b7d5                	j	800047da <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800047f8:	02451783          	lh	a5,36(a0)
    800047fc:	03079693          	slli	a3,a5,0x30
    80004800:	92c1                	srli	a3,a3,0x30
    80004802:	4725                	li	a4,9
    80004804:	02d76a63          	bltu	a4,a3,80004838 <fileread+0xc2>
    80004808:	0792                	slli	a5,a5,0x4
    8000480a:	0001f717          	auipc	a4,0x1f
    8000480e:	d3e70713          	addi	a4,a4,-706 # 80023548 <devsw>
    80004812:	97ba                	add	a5,a5,a4
    80004814:	639c                	ld	a5,0(a5)
    80004816:	c78d                	beqz	a5,80004840 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80004818:	4505                	li	a0,1
    8000481a:	9782                	jalr	a5
    8000481c:	892a                	mv	s2,a0
    8000481e:	64e2                	ld	s1,24(sp)
    80004820:	69a2                	ld	s3,8(sp)
    80004822:	bf65                	j	800047da <fileread+0x64>
    panic("fileread");
    80004824:	00004517          	auipc	a0,0x4
    80004828:	d7c50513          	addi	a0,a0,-644 # 800085a0 <etext+0x5a0>
    8000482c:	ffffc097          	auipc	ra,0xffffc
    80004830:	d34080e7          	jalr	-716(ra) # 80000560 <panic>
    return -1;
    80004834:	597d                	li	s2,-1
    80004836:	b755                	j	800047da <fileread+0x64>
      return -1;
    80004838:	597d                	li	s2,-1
    8000483a:	64e2                	ld	s1,24(sp)
    8000483c:	69a2                	ld	s3,8(sp)
    8000483e:	bf71                	j	800047da <fileread+0x64>
    80004840:	597d                	li	s2,-1
    80004842:	64e2                	ld	s1,24(sp)
    80004844:	69a2                	ld	s3,8(sp)
    80004846:	bf51                	j	800047da <fileread+0x64>

0000000080004848 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004848:	00954783          	lbu	a5,9(a0)
    8000484c:	12078963          	beqz	a5,8000497e <filewrite+0x136>
{
    80004850:	715d                	addi	sp,sp,-80
    80004852:	e486                	sd	ra,72(sp)
    80004854:	e0a2                	sd	s0,64(sp)
    80004856:	f84a                	sd	s2,48(sp)
    80004858:	f052                	sd	s4,32(sp)
    8000485a:	e85a                	sd	s6,16(sp)
    8000485c:	0880                	addi	s0,sp,80
    8000485e:	892a                	mv	s2,a0
    80004860:	8b2e                	mv	s6,a1
    80004862:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004864:	411c                	lw	a5,0(a0)
    80004866:	4705                	li	a4,1
    80004868:	02e78763          	beq	a5,a4,80004896 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000486c:	470d                	li	a4,3
    8000486e:	02e78a63          	beq	a5,a4,800048a2 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004872:	4709                	li	a4,2
    80004874:	0ee79863          	bne	a5,a4,80004964 <filewrite+0x11c>
    80004878:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000487a:	0cc05463          	blez	a2,80004942 <filewrite+0xfa>
    8000487e:	fc26                	sd	s1,56(sp)
    80004880:	ec56                	sd	s5,24(sp)
    80004882:	e45e                	sd	s7,8(sp)
    80004884:	e062                	sd	s8,0(sp)
    int i = 0;
    80004886:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80004888:	6b85                	lui	s7,0x1
    8000488a:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    8000488e:	6c05                	lui	s8,0x1
    80004890:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004894:	a851                	j	80004928 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80004896:	6908                	ld	a0,16(a0)
    80004898:	00000097          	auipc	ra,0x0
    8000489c:	248080e7          	jalr	584(ra) # 80004ae0 <pipewrite>
    800048a0:	a85d                	j	80004956 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800048a2:	02451783          	lh	a5,36(a0)
    800048a6:	03079693          	slli	a3,a5,0x30
    800048aa:	92c1                	srli	a3,a3,0x30
    800048ac:	4725                	li	a4,9
    800048ae:	0cd76a63          	bltu	a4,a3,80004982 <filewrite+0x13a>
    800048b2:	0792                	slli	a5,a5,0x4
    800048b4:	0001f717          	auipc	a4,0x1f
    800048b8:	c9470713          	addi	a4,a4,-876 # 80023548 <devsw>
    800048bc:	97ba                	add	a5,a5,a4
    800048be:	679c                	ld	a5,8(a5)
    800048c0:	c3f9                	beqz	a5,80004986 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    800048c2:	4505                	li	a0,1
    800048c4:	9782                	jalr	a5
    800048c6:	a841                	j	80004956 <filewrite+0x10e>
      if(n1 > max)
    800048c8:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800048cc:	00000097          	auipc	ra,0x0
    800048d0:	88c080e7          	jalr	-1908(ra) # 80004158 <begin_op>
      ilock(f->ip);
    800048d4:	01893503          	ld	a0,24(s2)
    800048d8:	fffff097          	auipc	ra,0xfffff
    800048dc:	eb2080e7          	jalr	-334(ra) # 8000378a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800048e0:	8756                	mv	a4,s5
    800048e2:	02092683          	lw	a3,32(s2)
    800048e6:	01698633          	add	a2,s3,s6
    800048ea:	4585                	li	a1,1
    800048ec:	01893503          	ld	a0,24(s2)
    800048f0:	fffff097          	auipc	ra,0xfffff
    800048f4:	262080e7          	jalr	610(ra) # 80003b52 <writei>
    800048f8:	84aa                	mv	s1,a0
    800048fa:	00a05763          	blez	a0,80004908 <filewrite+0xc0>
        f->off += r;
    800048fe:	02092783          	lw	a5,32(s2)
    80004902:	9fa9                	addw	a5,a5,a0
    80004904:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004908:	01893503          	ld	a0,24(s2)
    8000490c:	fffff097          	auipc	ra,0xfffff
    80004910:	f44080e7          	jalr	-188(ra) # 80003850 <iunlock>
      end_op();
    80004914:	00000097          	auipc	ra,0x0
    80004918:	8be080e7          	jalr	-1858(ra) # 800041d2 <end_op>

      if(r != n1){
    8000491c:	029a9563          	bne	s5,s1,80004946 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80004920:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004924:	0149da63          	bge	s3,s4,80004938 <filewrite+0xf0>
      int n1 = n - i;
    80004928:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    8000492c:	0004879b          	sext.w	a5,s1
    80004930:	f8fbdce3          	bge	s7,a5,800048c8 <filewrite+0x80>
    80004934:	84e2                	mv	s1,s8
    80004936:	bf49                	j	800048c8 <filewrite+0x80>
    80004938:	74e2                	ld	s1,56(sp)
    8000493a:	6ae2                	ld	s5,24(sp)
    8000493c:	6ba2                	ld	s7,8(sp)
    8000493e:	6c02                	ld	s8,0(sp)
    80004940:	a039                	j	8000494e <filewrite+0x106>
    int i = 0;
    80004942:	4981                	li	s3,0
    80004944:	a029                	j	8000494e <filewrite+0x106>
    80004946:	74e2                	ld	s1,56(sp)
    80004948:	6ae2                	ld	s5,24(sp)
    8000494a:	6ba2                	ld	s7,8(sp)
    8000494c:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    8000494e:	033a1e63          	bne	s4,s3,8000498a <filewrite+0x142>
    80004952:	8552                	mv	a0,s4
    80004954:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004956:	60a6                	ld	ra,72(sp)
    80004958:	6406                	ld	s0,64(sp)
    8000495a:	7942                	ld	s2,48(sp)
    8000495c:	7a02                	ld	s4,32(sp)
    8000495e:	6b42                	ld	s6,16(sp)
    80004960:	6161                	addi	sp,sp,80
    80004962:	8082                	ret
    80004964:	fc26                	sd	s1,56(sp)
    80004966:	f44e                	sd	s3,40(sp)
    80004968:	ec56                	sd	s5,24(sp)
    8000496a:	e45e                	sd	s7,8(sp)
    8000496c:	e062                	sd	s8,0(sp)
    panic("filewrite");
    8000496e:	00004517          	auipc	a0,0x4
    80004972:	c4250513          	addi	a0,a0,-958 # 800085b0 <etext+0x5b0>
    80004976:	ffffc097          	auipc	ra,0xffffc
    8000497a:	bea080e7          	jalr	-1046(ra) # 80000560 <panic>
    return -1;
    8000497e:	557d                	li	a0,-1
}
    80004980:	8082                	ret
      return -1;
    80004982:	557d                	li	a0,-1
    80004984:	bfc9                	j	80004956 <filewrite+0x10e>
    80004986:	557d                	li	a0,-1
    80004988:	b7f9                	j	80004956 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    8000498a:	557d                	li	a0,-1
    8000498c:	79a2                	ld	s3,40(sp)
    8000498e:	b7e1                	j	80004956 <filewrite+0x10e>

0000000080004990 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004990:	7179                	addi	sp,sp,-48
    80004992:	f406                	sd	ra,40(sp)
    80004994:	f022                	sd	s0,32(sp)
    80004996:	ec26                	sd	s1,24(sp)
    80004998:	e052                	sd	s4,0(sp)
    8000499a:	1800                	addi	s0,sp,48
    8000499c:	84aa                	mv	s1,a0
    8000499e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800049a0:	0005b023          	sd	zero,0(a1)
    800049a4:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800049a8:	00000097          	auipc	ra,0x0
    800049ac:	bbe080e7          	jalr	-1090(ra) # 80004566 <filealloc>
    800049b0:	e088                	sd	a0,0(s1)
    800049b2:	cd49                	beqz	a0,80004a4c <pipealloc+0xbc>
    800049b4:	00000097          	auipc	ra,0x0
    800049b8:	bb2080e7          	jalr	-1102(ra) # 80004566 <filealloc>
    800049bc:	00aa3023          	sd	a0,0(s4)
    800049c0:	c141                	beqz	a0,80004a40 <pipealloc+0xb0>
    800049c2:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800049c4:	ffffc097          	auipc	ra,0xffffc
    800049c8:	19c080e7          	jalr	412(ra) # 80000b60 <kalloc>
    800049cc:	892a                	mv	s2,a0
    800049ce:	c13d                	beqz	a0,80004a34 <pipealloc+0xa4>
    800049d0:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800049d2:	4985                	li	s3,1
    800049d4:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800049d8:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800049dc:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800049e0:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800049e4:	00004597          	auipc	a1,0x4
    800049e8:	bdc58593          	addi	a1,a1,-1060 # 800085c0 <etext+0x5c0>
    800049ec:	ffffc097          	auipc	ra,0xffffc
    800049f0:	1d4080e7          	jalr	468(ra) # 80000bc0 <initlock>
  (*f0)->type = FD_PIPE;
    800049f4:	609c                	ld	a5,0(s1)
    800049f6:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800049fa:	609c                	ld	a5,0(s1)
    800049fc:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004a00:	609c                	ld	a5,0(s1)
    80004a02:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004a06:	609c                	ld	a5,0(s1)
    80004a08:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004a0c:	000a3783          	ld	a5,0(s4)
    80004a10:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004a14:	000a3783          	ld	a5,0(s4)
    80004a18:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004a1c:	000a3783          	ld	a5,0(s4)
    80004a20:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004a24:	000a3783          	ld	a5,0(s4)
    80004a28:	0127b823          	sd	s2,16(a5)
  return 0;
    80004a2c:	4501                	li	a0,0
    80004a2e:	6942                	ld	s2,16(sp)
    80004a30:	69a2                	ld	s3,8(sp)
    80004a32:	a03d                	j	80004a60 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004a34:	6088                	ld	a0,0(s1)
    80004a36:	c119                	beqz	a0,80004a3c <pipealloc+0xac>
    80004a38:	6942                	ld	s2,16(sp)
    80004a3a:	a029                	j	80004a44 <pipealloc+0xb4>
    80004a3c:	6942                	ld	s2,16(sp)
    80004a3e:	a039                	j	80004a4c <pipealloc+0xbc>
    80004a40:	6088                	ld	a0,0(s1)
    80004a42:	c50d                	beqz	a0,80004a6c <pipealloc+0xdc>
    fileclose(*f0);
    80004a44:	00000097          	auipc	ra,0x0
    80004a48:	bde080e7          	jalr	-1058(ra) # 80004622 <fileclose>
  if(*f1)
    80004a4c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004a50:	557d                	li	a0,-1
  if(*f1)
    80004a52:	c799                	beqz	a5,80004a60 <pipealloc+0xd0>
    fileclose(*f1);
    80004a54:	853e                	mv	a0,a5
    80004a56:	00000097          	auipc	ra,0x0
    80004a5a:	bcc080e7          	jalr	-1076(ra) # 80004622 <fileclose>
  return -1;
    80004a5e:	557d                	li	a0,-1
}
    80004a60:	70a2                	ld	ra,40(sp)
    80004a62:	7402                	ld	s0,32(sp)
    80004a64:	64e2                	ld	s1,24(sp)
    80004a66:	6a02                	ld	s4,0(sp)
    80004a68:	6145                	addi	sp,sp,48
    80004a6a:	8082                	ret
  return -1;
    80004a6c:	557d                	li	a0,-1
    80004a6e:	bfcd                	j	80004a60 <pipealloc+0xd0>

0000000080004a70 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004a70:	1101                	addi	sp,sp,-32
    80004a72:	ec06                	sd	ra,24(sp)
    80004a74:	e822                	sd	s0,16(sp)
    80004a76:	e426                	sd	s1,8(sp)
    80004a78:	e04a                	sd	s2,0(sp)
    80004a7a:	1000                	addi	s0,sp,32
    80004a7c:	84aa                	mv	s1,a0
    80004a7e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004a80:	ffffc097          	auipc	ra,0xffffc
    80004a84:	1d0080e7          	jalr	464(ra) # 80000c50 <acquire>
  if(writable){
    80004a88:	02090d63          	beqz	s2,80004ac2 <pipeclose+0x52>
    pi->writeopen = 0;
    80004a8c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004a90:	21848513          	addi	a0,s1,536
    80004a94:	ffffd097          	auipc	ra,0xffffd
    80004a98:	6fc080e7          	jalr	1788(ra) # 80002190 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004a9c:	2204b783          	ld	a5,544(s1)
    80004aa0:	eb95                	bnez	a5,80004ad4 <pipeclose+0x64>
    release(&pi->lock);
    80004aa2:	8526                	mv	a0,s1
    80004aa4:	ffffc097          	auipc	ra,0xffffc
    80004aa8:	260080e7          	jalr	608(ra) # 80000d04 <release>
    kfree((char*)pi);
    80004aac:	8526                	mv	a0,s1
    80004aae:	ffffc097          	auipc	ra,0xffffc
    80004ab2:	fb4080e7          	jalr	-76(ra) # 80000a62 <kfree>
  } else
    release(&pi->lock);
}
    80004ab6:	60e2                	ld	ra,24(sp)
    80004ab8:	6442                	ld	s0,16(sp)
    80004aba:	64a2                	ld	s1,8(sp)
    80004abc:	6902                	ld	s2,0(sp)
    80004abe:	6105                	addi	sp,sp,32
    80004ac0:	8082                	ret
    pi->readopen = 0;
    80004ac2:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004ac6:	21c48513          	addi	a0,s1,540
    80004aca:	ffffd097          	auipc	ra,0xffffd
    80004ace:	6c6080e7          	jalr	1734(ra) # 80002190 <wakeup>
    80004ad2:	b7e9                	j	80004a9c <pipeclose+0x2c>
    release(&pi->lock);
    80004ad4:	8526                	mv	a0,s1
    80004ad6:	ffffc097          	auipc	ra,0xffffc
    80004ada:	22e080e7          	jalr	558(ra) # 80000d04 <release>
}
    80004ade:	bfe1                	j	80004ab6 <pipeclose+0x46>

0000000080004ae0 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004ae0:	711d                	addi	sp,sp,-96
    80004ae2:	ec86                	sd	ra,88(sp)
    80004ae4:	e8a2                	sd	s0,80(sp)
    80004ae6:	e4a6                	sd	s1,72(sp)
    80004ae8:	e0ca                	sd	s2,64(sp)
    80004aea:	fc4e                	sd	s3,56(sp)
    80004aec:	f852                	sd	s4,48(sp)
    80004aee:	f456                	sd	s5,40(sp)
    80004af0:	1080                	addi	s0,sp,96
    80004af2:	84aa                	mv	s1,a0
    80004af4:	8aae                	mv	s5,a1
    80004af6:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004af8:	ffffd097          	auipc	ra,0xffffd
    80004afc:	f6a080e7          	jalr	-150(ra) # 80001a62 <myproc>
    80004b00:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004b02:	8526                	mv	a0,s1
    80004b04:	ffffc097          	auipc	ra,0xffffc
    80004b08:	14c080e7          	jalr	332(ra) # 80000c50 <acquire>
  while(i < n){
    80004b0c:	0d405863          	blez	s4,80004bdc <pipewrite+0xfc>
    80004b10:	f05a                	sd	s6,32(sp)
    80004b12:	ec5e                	sd	s7,24(sp)
    80004b14:	e862                	sd	s8,16(sp)
  int i = 0;
    80004b16:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004b18:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004b1a:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004b1e:	21c48b93          	addi	s7,s1,540
    80004b22:	a089                	j	80004b64 <pipewrite+0x84>
      release(&pi->lock);
    80004b24:	8526                	mv	a0,s1
    80004b26:	ffffc097          	auipc	ra,0xffffc
    80004b2a:	1de080e7          	jalr	478(ra) # 80000d04 <release>
      return -1;
    80004b2e:	597d                	li	s2,-1
    80004b30:	7b02                	ld	s6,32(sp)
    80004b32:	6be2                	ld	s7,24(sp)
    80004b34:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004b36:	854a                	mv	a0,s2
    80004b38:	60e6                	ld	ra,88(sp)
    80004b3a:	6446                	ld	s0,80(sp)
    80004b3c:	64a6                	ld	s1,72(sp)
    80004b3e:	6906                	ld	s2,64(sp)
    80004b40:	79e2                	ld	s3,56(sp)
    80004b42:	7a42                	ld	s4,48(sp)
    80004b44:	7aa2                	ld	s5,40(sp)
    80004b46:	6125                	addi	sp,sp,96
    80004b48:	8082                	ret
      wakeup(&pi->nread);
    80004b4a:	8562                	mv	a0,s8
    80004b4c:	ffffd097          	auipc	ra,0xffffd
    80004b50:	644080e7          	jalr	1604(ra) # 80002190 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004b54:	85a6                	mv	a1,s1
    80004b56:	855e                	mv	a0,s7
    80004b58:	ffffd097          	auipc	ra,0xffffd
    80004b5c:	5d4080e7          	jalr	1492(ra) # 8000212c <sleep>
  while(i < n){
    80004b60:	05495f63          	bge	s2,s4,80004bbe <pipewrite+0xde>
    if(pi->readopen == 0 || killed(pr)){
    80004b64:	2204a783          	lw	a5,544(s1)
    80004b68:	dfd5                	beqz	a5,80004b24 <pipewrite+0x44>
    80004b6a:	854e                	mv	a0,s3
    80004b6c:	ffffe097          	auipc	ra,0xffffe
    80004b70:	868080e7          	jalr	-1944(ra) # 800023d4 <killed>
    80004b74:	f945                	bnez	a0,80004b24 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004b76:	2184a783          	lw	a5,536(s1)
    80004b7a:	21c4a703          	lw	a4,540(s1)
    80004b7e:	2007879b          	addiw	a5,a5,512
    80004b82:	fcf704e3          	beq	a4,a5,80004b4a <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004b86:	4685                	li	a3,1
    80004b88:	01590633          	add	a2,s2,s5
    80004b8c:	faf40593          	addi	a1,s0,-81
    80004b90:	0509b503          	ld	a0,80(s3)
    80004b94:	ffffd097          	auipc	ra,0xffffd
    80004b98:	bf2080e7          	jalr	-1038(ra) # 80001786 <copyin>
    80004b9c:	05650263          	beq	a0,s6,80004be0 <pipewrite+0x100>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004ba0:	21c4a783          	lw	a5,540(s1)
    80004ba4:	0017871b          	addiw	a4,a5,1
    80004ba8:	20e4ae23          	sw	a4,540(s1)
    80004bac:	1ff7f793          	andi	a5,a5,511
    80004bb0:	97a6                	add	a5,a5,s1
    80004bb2:	faf44703          	lbu	a4,-81(s0)
    80004bb6:	00e78c23          	sb	a4,24(a5)
      i++;
    80004bba:	2905                	addiw	s2,s2,1
    80004bbc:	b755                	j	80004b60 <pipewrite+0x80>
    80004bbe:	7b02                	ld	s6,32(sp)
    80004bc0:	6be2                	ld	s7,24(sp)
    80004bc2:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80004bc4:	21848513          	addi	a0,s1,536
    80004bc8:	ffffd097          	auipc	ra,0xffffd
    80004bcc:	5c8080e7          	jalr	1480(ra) # 80002190 <wakeup>
  release(&pi->lock);
    80004bd0:	8526                	mv	a0,s1
    80004bd2:	ffffc097          	auipc	ra,0xffffc
    80004bd6:	132080e7          	jalr	306(ra) # 80000d04 <release>
  return i;
    80004bda:	bfb1                	j	80004b36 <pipewrite+0x56>
  int i = 0;
    80004bdc:	4901                	li	s2,0
    80004bde:	b7dd                	j	80004bc4 <pipewrite+0xe4>
    80004be0:	7b02                	ld	s6,32(sp)
    80004be2:	6be2                	ld	s7,24(sp)
    80004be4:	6c42                	ld	s8,16(sp)
    80004be6:	bff9                	j	80004bc4 <pipewrite+0xe4>

0000000080004be8 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004be8:	715d                	addi	sp,sp,-80
    80004bea:	e486                	sd	ra,72(sp)
    80004bec:	e0a2                	sd	s0,64(sp)
    80004bee:	fc26                	sd	s1,56(sp)
    80004bf0:	f84a                	sd	s2,48(sp)
    80004bf2:	f44e                	sd	s3,40(sp)
    80004bf4:	f052                	sd	s4,32(sp)
    80004bf6:	ec56                	sd	s5,24(sp)
    80004bf8:	0880                	addi	s0,sp,80
    80004bfa:	84aa                	mv	s1,a0
    80004bfc:	892e                	mv	s2,a1
    80004bfe:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004c00:	ffffd097          	auipc	ra,0xffffd
    80004c04:	e62080e7          	jalr	-414(ra) # 80001a62 <myproc>
    80004c08:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004c0a:	8526                	mv	a0,s1
    80004c0c:	ffffc097          	auipc	ra,0xffffc
    80004c10:	044080e7          	jalr	68(ra) # 80000c50 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004c14:	2184a703          	lw	a4,536(s1)
    80004c18:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004c1c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004c20:	02f71963          	bne	a4,a5,80004c52 <piperead+0x6a>
    80004c24:	2244a783          	lw	a5,548(s1)
    80004c28:	cf95                	beqz	a5,80004c64 <piperead+0x7c>
    if(killed(pr)){
    80004c2a:	8552                	mv	a0,s4
    80004c2c:	ffffd097          	auipc	ra,0xffffd
    80004c30:	7a8080e7          	jalr	1960(ra) # 800023d4 <killed>
    80004c34:	e10d                	bnez	a0,80004c56 <piperead+0x6e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004c36:	85a6                	mv	a1,s1
    80004c38:	854e                	mv	a0,s3
    80004c3a:	ffffd097          	auipc	ra,0xffffd
    80004c3e:	4f2080e7          	jalr	1266(ra) # 8000212c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004c42:	2184a703          	lw	a4,536(s1)
    80004c46:	21c4a783          	lw	a5,540(s1)
    80004c4a:	fcf70de3          	beq	a4,a5,80004c24 <piperead+0x3c>
    80004c4e:	e85a                	sd	s6,16(sp)
    80004c50:	a819                	j	80004c66 <piperead+0x7e>
    80004c52:	e85a                	sd	s6,16(sp)
    80004c54:	a809                	j	80004c66 <piperead+0x7e>
      release(&pi->lock);
    80004c56:	8526                	mv	a0,s1
    80004c58:	ffffc097          	auipc	ra,0xffffc
    80004c5c:	0ac080e7          	jalr	172(ra) # 80000d04 <release>
      return -1;
    80004c60:	59fd                	li	s3,-1
    80004c62:	a0a5                	j	80004cca <piperead+0xe2>
    80004c64:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004c66:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004c68:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004c6a:	05505463          	blez	s5,80004cb2 <piperead+0xca>
    if(pi->nread == pi->nwrite)
    80004c6e:	2184a783          	lw	a5,536(s1)
    80004c72:	21c4a703          	lw	a4,540(s1)
    80004c76:	02f70e63          	beq	a4,a5,80004cb2 <piperead+0xca>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004c7a:	0017871b          	addiw	a4,a5,1
    80004c7e:	20e4ac23          	sw	a4,536(s1)
    80004c82:	1ff7f793          	andi	a5,a5,511
    80004c86:	97a6                	add	a5,a5,s1
    80004c88:	0187c783          	lbu	a5,24(a5)
    80004c8c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004c90:	4685                	li	a3,1
    80004c92:	fbf40613          	addi	a2,s0,-65
    80004c96:	85ca                	mv	a1,s2
    80004c98:	050a3503          	ld	a0,80(s4)
    80004c9c:	ffffd097          	auipc	ra,0xffffd
    80004ca0:	a5e080e7          	jalr	-1442(ra) # 800016fa <copyout>
    80004ca4:	01650763          	beq	a0,s6,80004cb2 <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004ca8:	2985                	addiw	s3,s3,1
    80004caa:	0905                	addi	s2,s2,1
    80004cac:	fd3a91e3          	bne	s5,s3,80004c6e <piperead+0x86>
    80004cb0:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004cb2:	21c48513          	addi	a0,s1,540
    80004cb6:	ffffd097          	auipc	ra,0xffffd
    80004cba:	4da080e7          	jalr	1242(ra) # 80002190 <wakeup>
  release(&pi->lock);
    80004cbe:	8526                	mv	a0,s1
    80004cc0:	ffffc097          	auipc	ra,0xffffc
    80004cc4:	044080e7          	jalr	68(ra) # 80000d04 <release>
    80004cc8:	6b42                	ld	s6,16(sp)
  return i;
}
    80004cca:	854e                	mv	a0,s3
    80004ccc:	60a6                	ld	ra,72(sp)
    80004cce:	6406                	ld	s0,64(sp)
    80004cd0:	74e2                	ld	s1,56(sp)
    80004cd2:	7942                	ld	s2,48(sp)
    80004cd4:	79a2                	ld	s3,40(sp)
    80004cd6:	7a02                	ld	s4,32(sp)
    80004cd8:	6ae2                	ld	s5,24(sp)
    80004cda:	6161                	addi	sp,sp,80
    80004cdc:	8082                	ret

0000000080004cde <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004cde:	1141                	addi	sp,sp,-16
    80004ce0:	e422                	sd	s0,8(sp)
    80004ce2:	0800                	addi	s0,sp,16
    80004ce4:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004ce6:	8905                	andi	a0,a0,1
    80004ce8:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004cea:	8b89                	andi	a5,a5,2
    80004cec:	c399                	beqz	a5,80004cf2 <flags2perm+0x14>
      perm |= PTE_W;
    80004cee:	00456513          	ori	a0,a0,4
    return perm;
}
    80004cf2:	6422                	ld	s0,8(sp)
    80004cf4:	0141                	addi	sp,sp,16
    80004cf6:	8082                	ret

0000000080004cf8 <exec>:

int
exec(char *path, char **argv)
{
    80004cf8:	df010113          	addi	sp,sp,-528
    80004cfc:	20113423          	sd	ra,520(sp)
    80004d00:	20813023          	sd	s0,512(sp)
    80004d04:	ffa6                	sd	s1,504(sp)
    80004d06:	fbca                	sd	s2,496(sp)
    80004d08:	0c00                	addi	s0,sp,528
    80004d0a:	892a                	mv	s2,a0
    80004d0c:	dea43c23          	sd	a0,-520(s0)
    80004d10:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004d14:	ffffd097          	auipc	ra,0xffffd
    80004d18:	d4e080e7          	jalr	-690(ra) # 80001a62 <myproc>
    80004d1c:	84aa                	mv	s1,a0

  begin_op();
    80004d1e:	fffff097          	auipc	ra,0xfffff
    80004d22:	43a080e7          	jalr	1082(ra) # 80004158 <begin_op>

  if((ip = namei(path)) == 0){
    80004d26:	854a                	mv	a0,s2
    80004d28:	fffff097          	auipc	ra,0xfffff
    80004d2c:	230080e7          	jalr	560(ra) # 80003f58 <namei>
    80004d30:	c135                	beqz	a0,80004d94 <exec+0x9c>
    80004d32:	f3d2                	sd	s4,480(sp)
    80004d34:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004d36:	fffff097          	auipc	ra,0xfffff
    80004d3a:	a54080e7          	jalr	-1452(ra) # 8000378a <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004d3e:	04000713          	li	a4,64
    80004d42:	4681                	li	a3,0
    80004d44:	e5040613          	addi	a2,s0,-432
    80004d48:	4581                	li	a1,0
    80004d4a:	8552                	mv	a0,s4
    80004d4c:	fffff097          	auipc	ra,0xfffff
    80004d50:	cf6080e7          	jalr	-778(ra) # 80003a42 <readi>
    80004d54:	04000793          	li	a5,64
    80004d58:	00f51a63          	bne	a0,a5,80004d6c <exec+0x74>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004d5c:	e5042703          	lw	a4,-432(s0)
    80004d60:	464c47b7          	lui	a5,0x464c4
    80004d64:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004d68:	02f70c63          	beq	a4,a5,80004da0 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004d6c:	8552                	mv	a0,s4
    80004d6e:	fffff097          	auipc	ra,0xfffff
    80004d72:	c82080e7          	jalr	-894(ra) # 800039f0 <iunlockput>
    end_op();
    80004d76:	fffff097          	auipc	ra,0xfffff
    80004d7a:	45c080e7          	jalr	1116(ra) # 800041d2 <end_op>
  }
  return -1;
    80004d7e:	557d                	li	a0,-1
    80004d80:	7a1e                	ld	s4,480(sp)
}
    80004d82:	20813083          	ld	ra,520(sp)
    80004d86:	20013403          	ld	s0,512(sp)
    80004d8a:	74fe                	ld	s1,504(sp)
    80004d8c:	795e                	ld	s2,496(sp)
    80004d8e:	21010113          	addi	sp,sp,528
    80004d92:	8082                	ret
    end_op();
    80004d94:	fffff097          	auipc	ra,0xfffff
    80004d98:	43e080e7          	jalr	1086(ra) # 800041d2 <end_op>
    return -1;
    80004d9c:	557d                	li	a0,-1
    80004d9e:	b7d5                	j	80004d82 <exec+0x8a>
    80004da0:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004da2:	8526                	mv	a0,s1
    80004da4:	ffffd097          	auipc	ra,0xffffd
    80004da8:	d82080e7          	jalr	-638(ra) # 80001b26 <proc_pagetable>
    80004dac:	8b2a                	mv	s6,a0
    80004dae:	30050f63          	beqz	a0,800050cc <exec+0x3d4>
    80004db2:	f7ce                	sd	s3,488(sp)
    80004db4:	efd6                	sd	s5,472(sp)
    80004db6:	e7de                	sd	s7,456(sp)
    80004db8:	e3e2                	sd	s8,448(sp)
    80004dba:	ff66                	sd	s9,440(sp)
    80004dbc:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004dbe:	e7042d03          	lw	s10,-400(s0)
    80004dc2:	e8845783          	lhu	a5,-376(s0)
    80004dc6:	14078d63          	beqz	a5,80004f20 <exec+0x228>
    80004dca:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004dcc:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004dce:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004dd0:	6c85                	lui	s9,0x1
    80004dd2:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004dd6:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004dda:	6a85                	lui	s5,0x1
    80004ddc:	a0b5                	j	80004e48 <exec+0x150>
      panic("loadseg: address should exist");
    80004dde:	00003517          	auipc	a0,0x3
    80004de2:	7ea50513          	addi	a0,a0,2026 # 800085c8 <etext+0x5c8>
    80004de6:	ffffb097          	auipc	ra,0xffffb
    80004dea:	77a080e7          	jalr	1914(ra) # 80000560 <panic>
    if(sz - i < PGSIZE)
    80004dee:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004df0:	8726                	mv	a4,s1
    80004df2:	012c06bb          	addw	a3,s8,s2
    80004df6:	4581                	li	a1,0
    80004df8:	8552                	mv	a0,s4
    80004dfa:	fffff097          	auipc	ra,0xfffff
    80004dfe:	c48080e7          	jalr	-952(ra) # 80003a42 <readi>
    80004e02:	2501                	sext.w	a0,a0
    80004e04:	28a49863          	bne	s1,a0,80005094 <exec+0x39c>
  for(i = 0; i < sz; i += PGSIZE){
    80004e08:	012a893b          	addw	s2,s5,s2
    80004e0c:	03397563          	bgeu	s2,s3,80004e36 <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    80004e10:	02091593          	slli	a1,s2,0x20
    80004e14:	9181                	srli	a1,a1,0x20
    80004e16:	95de                	add	a1,a1,s7
    80004e18:	855a                	mv	a0,s6
    80004e1a:	ffffc097          	auipc	ra,0xffffc
    80004e1e:	2b4080e7          	jalr	692(ra) # 800010ce <walkaddr>
    80004e22:	862a                	mv	a2,a0
    if(pa == 0)
    80004e24:	dd4d                	beqz	a0,80004dde <exec+0xe6>
    if(sz - i < PGSIZE)
    80004e26:	412984bb          	subw	s1,s3,s2
    80004e2a:	0004879b          	sext.w	a5,s1
    80004e2e:	fcfcf0e3          	bgeu	s9,a5,80004dee <exec+0xf6>
    80004e32:	84d6                	mv	s1,s5
    80004e34:	bf6d                	j	80004dee <exec+0xf6>
    sz = sz1;
    80004e36:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004e3a:	2d85                	addiw	s11,s11,1
    80004e3c:	038d0d1b          	addiw	s10,s10,56
    80004e40:	e8845783          	lhu	a5,-376(s0)
    80004e44:	08fdd663          	bge	s11,a5,80004ed0 <exec+0x1d8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004e48:	2d01                	sext.w	s10,s10
    80004e4a:	03800713          	li	a4,56
    80004e4e:	86ea                	mv	a3,s10
    80004e50:	e1840613          	addi	a2,s0,-488
    80004e54:	4581                	li	a1,0
    80004e56:	8552                	mv	a0,s4
    80004e58:	fffff097          	auipc	ra,0xfffff
    80004e5c:	bea080e7          	jalr	-1046(ra) # 80003a42 <readi>
    80004e60:	03800793          	li	a5,56
    80004e64:	20f51063          	bne	a0,a5,80005064 <exec+0x36c>
    if(ph.type != ELF_PROG_LOAD)
    80004e68:	e1842783          	lw	a5,-488(s0)
    80004e6c:	4705                	li	a4,1
    80004e6e:	fce796e3          	bne	a5,a4,80004e3a <exec+0x142>
    if(ph.memsz < ph.filesz)
    80004e72:	e4043483          	ld	s1,-448(s0)
    80004e76:	e3843783          	ld	a5,-456(s0)
    80004e7a:	1ef4e963          	bltu	s1,a5,8000506c <exec+0x374>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004e7e:	e2843783          	ld	a5,-472(s0)
    80004e82:	94be                	add	s1,s1,a5
    80004e84:	1ef4e863          	bltu	s1,a5,80005074 <exec+0x37c>
    if(ph.vaddr % PGSIZE != 0)
    80004e88:	df043703          	ld	a4,-528(s0)
    80004e8c:	8ff9                	and	a5,a5,a4
    80004e8e:	1e079763          	bnez	a5,8000507c <exec+0x384>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004e92:	e1c42503          	lw	a0,-484(s0)
    80004e96:	00000097          	auipc	ra,0x0
    80004e9a:	e48080e7          	jalr	-440(ra) # 80004cde <flags2perm>
    80004e9e:	86aa                	mv	a3,a0
    80004ea0:	8626                	mv	a2,s1
    80004ea2:	85ca                	mv	a1,s2
    80004ea4:	855a                	mv	a0,s6
    80004ea6:	ffffc097          	auipc	ra,0xffffc
    80004eaa:	5ec080e7          	jalr	1516(ra) # 80001492 <uvmalloc>
    80004eae:	e0a43423          	sd	a0,-504(s0)
    80004eb2:	1c050963          	beqz	a0,80005084 <exec+0x38c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004eb6:	e2843b83          	ld	s7,-472(s0)
    80004eba:	e2042c03          	lw	s8,-480(s0)
    80004ebe:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004ec2:	00098463          	beqz	s3,80004eca <exec+0x1d2>
    80004ec6:	4901                	li	s2,0
    80004ec8:	b7a1                	j	80004e10 <exec+0x118>
    sz = sz1;
    80004eca:	e0843903          	ld	s2,-504(s0)
    80004ece:	b7b5                	j	80004e3a <exec+0x142>
    80004ed0:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004ed2:	8552                	mv	a0,s4
    80004ed4:	fffff097          	auipc	ra,0xfffff
    80004ed8:	b1c080e7          	jalr	-1252(ra) # 800039f0 <iunlockput>
  end_op();
    80004edc:	fffff097          	auipc	ra,0xfffff
    80004ee0:	2f6080e7          	jalr	758(ra) # 800041d2 <end_op>
  p = myproc();
    80004ee4:	ffffd097          	auipc	ra,0xffffd
    80004ee8:	b7e080e7          	jalr	-1154(ra) # 80001a62 <myproc>
    80004eec:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004eee:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004ef2:	6985                	lui	s3,0x1
    80004ef4:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004ef6:	99ca                	add	s3,s3,s2
    80004ef8:	77fd                	lui	a5,0xfffff
    80004efa:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004efe:	4691                	li	a3,4
    80004f00:	6609                	lui	a2,0x2
    80004f02:	964e                	add	a2,a2,s3
    80004f04:	85ce                	mv	a1,s3
    80004f06:	855a                	mv	a0,s6
    80004f08:	ffffc097          	auipc	ra,0xffffc
    80004f0c:	58a080e7          	jalr	1418(ra) # 80001492 <uvmalloc>
    80004f10:	892a                	mv	s2,a0
    80004f12:	e0a43423          	sd	a0,-504(s0)
    80004f16:	e519                	bnez	a0,80004f24 <exec+0x22c>
  if(pagetable)
    80004f18:	e1343423          	sd	s3,-504(s0)
    80004f1c:	4a01                	li	s4,0
    80004f1e:	aaa5                	j	80005096 <exec+0x39e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004f20:	4901                	li	s2,0
    80004f22:	bf45                	j	80004ed2 <exec+0x1da>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004f24:	75f9                	lui	a1,0xffffe
    80004f26:	95aa                	add	a1,a1,a0
    80004f28:	855a                	mv	a0,s6
    80004f2a:	ffffc097          	auipc	ra,0xffffc
    80004f2e:	79e080e7          	jalr	1950(ra) # 800016c8 <uvmclear>
  stackbase = sp - PGSIZE;
    80004f32:	7bfd                	lui	s7,0xfffff
    80004f34:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004f36:	e0043783          	ld	a5,-512(s0)
    80004f3a:	6388                	ld	a0,0(a5)
    80004f3c:	c52d                	beqz	a0,80004fa6 <exec+0x2ae>
    80004f3e:	e9040993          	addi	s3,s0,-368
    80004f42:	f9040c13          	addi	s8,s0,-112
    80004f46:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004f48:	ffffc097          	auipc	ra,0xffffc
    80004f4c:	f78080e7          	jalr	-136(ra) # 80000ec0 <strlen>
    80004f50:	0015079b          	addiw	a5,a0,1
    80004f54:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004f58:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004f5c:	13796863          	bltu	s2,s7,8000508c <exec+0x394>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004f60:	e0043d03          	ld	s10,-512(s0)
    80004f64:	000d3a03          	ld	s4,0(s10)
    80004f68:	8552                	mv	a0,s4
    80004f6a:	ffffc097          	auipc	ra,0xffffc
    80004f6e:	f56080e7          	jalr	-170(ra) # 80000ec0 <strlen>
    80004f72:	0015069b          	addiw	a3,a0,1
    80004f76:	8652                	mv	a2,s4
    80004f78:	85ca                	mv	a1,s2
    80004f7a:	855a                	mv	a0,s6
    80004f7c:	ffffc097          	auipc	ra,0xffffc
    80004f80:	77e080e7          	jalr	1918(ra) # 800016fa <copyout>
    80004f84:	10054663          	bltz	a0,80005090 <exec+0x398>
    ustack[argc] = sp;
    80004f88:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004f8c:	0485                	addi	s1,s1,1
    80004f8e:	008d0793          	addi	a5,s10,8
    80004f92:	e0f43023          	sd	a5,-512(s0)
    80004f96:	008d3503          	ld	a0,8(s10)
    80004f9a:	c909                	beqz	a0,80004fac <exec+0x2b4>
    if(argc >= MAXARG)
    80004f9c:	09a1                	addi	s3,s3,8
    80004f9e:	fb8995e3          	bne	s3,s8,80004f48 <exec+0x250>
  ip = 0;
    80004fa2:	4a01                	li	s4,0
    80004fa4:	a8cd                	j	80005096 <exec+0x39e>
  sp = sz;
    80004fa6:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004faa:	4481                	li	s1,0
  ustack[argc] = 0;
    80004fac:	00349793          	slli	a5,s1,0x3
    80004fb0:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffda8b0>
    80004fb4:	97a2                	add	a5,a5,s0
    80004fb6:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004fba:	00148693          	addi	a3,s1,1
    80004fbe:	068e                	slli	a3,a3,0x3
    80004fc0:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004fc4:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004fc8:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004fcc:	f57966e3          	bltu	s2,s7,80004f18 <exec+0x220>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004fd0:	e9040613          	addi	a2,s0,-368
    80004fd4:	85ca                	mv	a1,s2
    80004fd6:	855a                	mv	a0,s6
    80004fd8:	ffffc097          	auipc	ra,0xffffc
    80004fdc:	722080e7          	jalr	1826(ra) # 800016fa <copyout>
    80004fe0:	0e054863          	bltz	a0,800050d0 <exec+0x3d8>
  p->trapframe->a1 = sp;
    80004fe4:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004fe8:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004fec:	df843783          	ld	a5,-520(s0)
    80004ff0:	0007c703          	lbu	a4,0(a5)
    80004ff4:	cf11                	beqz	a4,80005010 <exec+0x318>
    80004ff6:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004ff8:	02f00693          	li	a3,47
    80004ffc:	a039                	j	8000500a <exec+0x312>
      last = s+1;
    80004ffe:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80005002:	0785                	addi	a5,a5,1
    80005004:	fff7c703          	lbu	a4,-1(a5)
    80005008:	c701                	beqz	a4,80005010 <exec+0x318>
    if(*s == '/')
    8000500a:	fed71ce3          	bne	a4,a3,80005002 <exec+0x30a>
    8000500e:	bfc5                	j	80004ffe <exec+0x306>
  safestrcpy(p->name, last, sizeof(p->name));
    80005010:	4641                	li	a2,16
    80005012:	df843583          	ld	a1,-520(s0)
    80005016:	158a8513          	addi	a0,s5,344
    8000501a:	ffffc097          	auipc	ra,0xffffc
    8000501e:	e74080e7          	jalr	-396(ra) # 80000e8e <safestrcpy>
  oldpagetable = p->pagetable;
    80005022:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80005026:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    8000502a:	e0843783          	ld	a5,-504(s0)
    8000502e:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005032:	058ab783          	ld	a5,88(s5)
    80005036:	e6843703          	ld	a4,-408(s0)
    8000503a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000503c:	058ab783          	ld	a5,88(s5)
    80005040:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005044:	85e6                	mv	a1,s9
    80005046:	ffffd097          	auipc	ra,0xffffd
    8000504a:	b7c080e7          	jalr	-1156(ra) # 80001bc2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000504e:	0004851b          	sext.w	a0,s1
    80005052:	79be                	ld	s3,488(sp)
    80005054:	7a1e                	ld	s4,480(sp)
    80005056:	6afe                	ld	s5,472(sp)
    80005058:	6b5e                	ld	s6,464(sp)
    8000505a:	6bbe                	ld	s7,456(sp)
    8000505c:	6c1e                	ld	s8,448(sp)
    8000505e:	7cfa                	ld	s9,440(sp)
    80005060:	7d5a                	ld	s10,432(sp)
    80005062:	b305                	j	80004d82 <exec+0x8a>
    80005064:	e1243423          	sd	s2,-504(s0)
    80005068:	7dba                	ld	s11,424(sp)
    8000506a:	a035                	j	80005096 <exec+0x39e>
    8000506c:	e1243423          	sd	s2,-504(s0)
    80005070:	7dba                	ld	s11,424(sp)
    80005072:	a015                	j	80005096 <exec+0x39e>
    80005074:	e1243423          	sd	s2,-504(s0)
    80005078:	7dba                	ld	s11,424(sp)
    8000507a:	a831                	j	80005096 <exec+0x39e>
    8000507c:	e1243423          	sd	s2,-504(s0)
    80005080:	7dba                	ld	s11,424(sp)
    80005082:	a811                	j	80005096 <exec+0x39e>
    80005084:	e1243423          	sd	s2,-504(s0)
    80005088:	7dba                	ld	s11,424(sp)
    8000508a:	a031                	j	80005096 <exec+0x39e>
  ip = 0;
    8000508c:	4a01                	li	s4,0
    8000508e:	a021                	j	80005096 <exec+0x39e>
    80005090:	4a01                	li	s4,0
  if(pagetable)
    80005092:	a011                	j	80005096 <exec+0x39e>
    80005094:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80005096:	e0843583          	ld	a1,-504(s0)
    8000509a:	855a                	mv	a0,s6
    8000509c:	ffffd097          	auipc	ra,0xffffd
    800050a0:	b26080e7          	jalr	-1242(ra) # 80001bc2 <proc_freepagetable>
  return -1;
    800050a4:	557d                	li	a0,-1
  if(ip){
    800050a6:	000a1b63          	bnez	s4,800050bc <exec+0x3c4>
    800050aa:	79be                	ld	s3,488(sp)
    800050ac:	7a1e                	ld	s4,480(sp)
    800050ae:	6afe                	ld	s5,472(sp)
    800050b0:	6b5e                	ld	s6,464(sp)
    800050b2:	6bbe                	ld	s7,456(sp)
    800050b4:	6c1e                	ld	s8,448(sp)
    800050b6:	7cfa                	ld	s9,440(sp)
    800050b8:	7d5a                	ld	s10,432(sp)
    800050ba:	b1e1                	j	80004d82 <exec+0x8a>
    800050bc:	79be                	ld	s3,488(sp)
    800050be:	6afe                	ld	s5,472(sp)
    800050c0:	6b5e                	ld	s6,464(sp)
    800050c2:	6bbe                	ld	s7,456(sp)
    800050c4:	6c1e                	ld	s8,448(sp)
    800050c6:	7cfa                	ld	s9,440(sp)
    800050c8:	7d5a                	ld	s10,432(sp)
    800050ca:	b14d                	j	80004d6c <exec+0x74>
    800050cc:	6b5e                	ld	s6,464(sp)
    800050ce:	b979                	j	80004d6c <exec+0x74>
  sz = sz1;
    800050d0:	e0843983          	ld	s3,-504(s0)
    800050d4:	b591                	j	80004f18 <exec+0x220>

00000000800050d6 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800050d6:	7179                	addi	sp,sp,-48
    800050d8:	f406                	sd	ra,40(sp)
    800050da:	f022                	sd	s0,32(sp)
    800050dc:	ec26                	sd	s1,24(sp)
    800050de:	e84a                	sd	s2,16(sp)
    800050e0:	1800                	addi	s0,sp,48
    800050e2:	892e                	mv	s2,a1
    800050e4:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800050e6:	fdc40593          	addi	a1,s0,-36
    800050ea:	ffffe097          	auipc	ra,0xffffe
    800050ee:	ab8080e7          	jalr	-1352(ra) # 80002ba2 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800050f2:	fdc42703          	lw	a4,-36(s0)
    800050f6:	47bd                	li	a5,15
    800050f8:	02e7eb63          	bltu	a5,a4,8000512e <argfd+0x58>
    800050fc:	ffffd097          	auipc	ra,0xffffd
    80005100:	966080e7          	jalr	-1690(ra) # 80001a62 <myproc>
    80005104:	fdc42703          	lw	a4,-36(s0)
    80005108:	01a70793          	addi	a5,a4,26
    8000510c:	078e                	slli	a5,a5,0x3
    8000510e:	953e                	add	a0,a0,a5
    80005110:	611c                	ld	a5,0(a0)
    80005112:	c385                	beqz	a5,80005132 <argfd+0x5c>
    return -1;
  if(pfd)
    80005114:	00090463          	beqz	s2,8000511c <argfd+0x46>
    *pfd = fd;
    80005118:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000511c:	4501                	li	a0,0
  if(pf)
    8000511e:	c091                	beqz	s1,80005122 <argfd+0x4c>
    *pf = f;
    80005120:	e09c                	sd	a5,0(s1)
}
    80005122:	70a2                	ld	ra,40(sp)
    80005124:	7402                	ld	s0,32(sp)
    80005126:	64e2                	ld	s1,24(sp)
    80005128:	6942                	ld	s2,16(sp)
    8000512a:	6145                	addi	sp,sp,48
    8000512c:	8082                	ret
    return -1;
    8000512e:	557d                	li	a0,-1
    80005130:	bfcd                	j	80005122 <argfd+0x4c>
    80005132:	557d                	li	a0,-1
    80005134:	b7fd                	j	80005122 <argfd+0x4c>

0000000080005136 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005136:	1101                	addi	sp,sp,-32
    80005138:	ec06                	sd	ra,24(sp)
    8000513a:	e822                	sd	s0,16(sp)
    8000513c:	e426                	sd	s1,8(sp)
    8000513e:	1000                	addi	s0,sp,32
    80005140:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005142:	ffffd097          	auipc	ra,0xffffd
    80005146:	920080e7          	jalr	-1760(ra) # 80001a62 <myproc>
    8000514a:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000514c:	0d050793          	addi	a5,a0,208
    80005150:	4501                	li	a0,0
    80005152:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005154:	6398                	ld	a4,0(a5)
    80005156:	cb19                	beqz	a4,8000516c <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005158:	2505                	addiw	a0,a0,1
    8000515a:	07a1                	addi	a5,a5,8
    8000515c:	fed51ce3          	bne	a0,a3,80005154 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005160:	557d                	li	a0,-1
}
    80005162:	60e2                	ld	ra,24(sp)
    80005164:	6442                	ld	s0,16(sp)
    80005166:	64a2                	ld	s1,8(sp)
    80005168:	6105                	addi	sp,sp,32
    8000516a:	8082                	ret
      p->ofile[fd] = f;
    8000516c:	01a50793          	addi	a5,a0,26
    80005170:	078e                	slli	a5,a5,0x3
    80005172:	963e                	add	a2,a2,a5
    80005174:	e204                	sd	s1,0(a2)
      return fd;
    80005176:	b7f5                	j	80005162 <fdalloc+0x2c>

0000000080005178 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005178:	715d                	addi	sp,sp,-80
    8000517a:	e486                	sd	ra,72(sp)
    8000517c:	e0a2                	sd	s0,64(sp)
    8000517e:	fc26                	sd	s1,56(sp)
    80005180:	f84a                	sd	s2,48(sp)
    80005182:	f44e                	sd	s3,40(sp)
    80005184:	ec56                	sd	s5,24(sp)
    80005186:	e85a                	sd	s6,16(sp)
    80005188:	0880                	addi	s0,sp,80
    8000518a:	8b2e                	mv	s6,a1
    8000518c:	89b2                	mv	s3,a2
    8000518e:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005190:	fb040593          	addi	a1,s0,-80
    80005194:	fffff097          	auipc	ra,0xfffff
    80005198:	de2080e7          	jalr	-542(ra) # 80003f76 <nameiparent>
    8000519c:	84aa                	mv	s1,a0
    8000519e:	14050e63          	beqz	a0,800052fa <create+0x182>
    return 0;

  ilock(dp);
    800051a2:	ffffe097          	auipc	ra,0xffffe
    800051a6:	5e8080e7          	jalr	1512(ra) # 8000378a <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800051aa:	4601                	li	a2,0
    800051ac:	fb040593          	addi	a1,s0,-80
    800051b0:	8526                	mv	a0,s1
    800051b2:	fffff097          	auipc	ra,0xfffff
    800051b6:	ae4080e7          	jalr	-1308(ra) # 80003c96 <dirlookup>
    800051ba:	8aaa                	mv	s5,a0
    800051bc:	c539                	beqz	a0,8000520a <create+0x92>
    iunlockput(dp);
    800051be:	8526                	mv	a0,s1
    800051c0:	fffff097          	auipc	ra,0xfffff
    800051c4:	830080e7          	jalr	-2000(ra) # 800039f0 <iunlockput>
    ilock(ip);
    800051c8:	8556                	mv	a0,s5
    800051ca:	ffffe097          	auipc	ra,0xffffe
    800051ce:	5c0080e7          	jalr	1472(ra) # 8000378a <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800051d2:	4789                	li	a5,2
    800051d4:	02fb1463          	bne	s6,a5,800051fc <create+0x84>
    800051d8:	044ad783          	lhu	a5,68(s5)
    800051dc:	37f9                	addiw	a5,a5,-2
    800051de:	17c2                	slli	a5,a5,0x30
    800051e0:	93c1                	srli	a5,a5,0x30
    800051e2:	4705                	li	a4,1
    800051e4:	00f76c63          	bltu	a4,a5,800051fc <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800051e8:	8556                	mv	a0,s5
    800051ea:	60a6                	ld	ra,72(sp)
    800051ec:	6406                	ld	s0,64(sp)
    800051ee:	74e2                	ld	s1,56(sp)
    800051f0:	7942                	ld	s2,48(sp)
    800051f2:	79a2                	ld	s3,40(sp)
    800051f4:	6ae2                	ld	s5,24(sp)
    800051f6:	6b42                	ld	s6,16(sp)
    800051f8:	6161                	addi	sp,sp,80
    800051fa:	8082                	ret
    iunlockput(ip);
    800051fc:	8556                	mv	a0,s5
    800051fe:	ffffe097          	auipc	ra,0xffffe
    80005202:	7f2080e7          	jalr	2034(ra) # 800039f0 <iunlockput>
    return 0;
    80005206:	4a81                	li	s5,0
    80005208:	b7c5                	j	800051e8 <create+0x70>
    8000520a:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    8000520c:	85da                	mv	a1,s6
    8000520e:	4088                	lw	a0,0(s1)
    80005210:	ffffe097          	auipc	ra,0xffffe
    80005214:	3d6080e7          	jalr	982(ra) # 800035e6 <ialloc>
    80005218:	8a2a                	mv	s4,a0
    8000521a:	c531                	beqz	a0,80005266 <create+0xee>
  ilock(ip);
    8000521c:	ffffe097          	auipc	ra,0xffffe
    80005220:	56e080e7          	jalr	1390(ra) # 8000378a <ilock>
  ip->major = major;
    80005224:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80005228:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000522c:	4905                	li	s2,1
    8000522e:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80005232:	8552                	mv	a0,s4
    80005234:	ffffe097          	auipc	ra,0xffffe
    80005238:	48a080e7          	jalr	1162(ra) # 800036be <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000523c:	032b0d63          	beq	s6,s2,80005276 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80005240:	004a2603          	lw	a2,4(s4)
    80005244:	fb040593          	addi	a1,s0,-80
    80005248:	8526                	mv	a0,s1
    8000524a:	fffff097          	auipc	ra,0xfffff
    8000524e:	c5c080e7          	jalr	-932(ra) # 80003ea6 <dirlink>
    80005252:	08054163          	bltz	a0,800052d4 <create+0x15c>
  iunlockput(dp);
    80005256:	8526                	mv	a0,s1
    80005258:	ffffe097          	auipc	ra,0xffffe
    8000525c:	798080e7          	jalr	1944(ra) # 800039f0 <iunlockput>
  return ip;
    80005260:	8ad2                	mv	s5,s4
    80005262:	7a02                	ld	s4,32(sp)
    80005264:	b751                	j	800051e8 <create+0x70>
    iunlockput(dp);
    80005266:	8526                	mv	a0,s1
    80005268:	ffffe097          	auipc	ra,0xffffe
    8000526c:	788080e7          	jalr	1928(ra) # 800039f0 <iunlockput>
    return 0;
    80005270:	8ad2                	mv	s5,s4
    80005272:	7a02                	ld	s4,32(sp)
    80005274:	bf95                	j	800051e8 <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005276:	004a2603          	lw	a2,4(s4)
    8000527a:	00003597          	auipc	a1,0x3
    8000527e:	36e58593          	addi	a1,a1,878 # 800085e8 <etext+0x5e8>
    80005282:	8552                	mv	a0,s4
    80005284:	fffff097          	auipc	ra,0xfffff
    80005288:	c22080e7          	jalr	-990(ra) # 80003ea6 <dirlink>
    8000528c:	04054463          	bltz	a0,800052d4 <create+0x15c>
    80005290:	40d0                	lw	a2,4(s1)
    80005292:	00003597          	auipc	a1,0x3
    80005296:	35e58593          	addi	a1,a1,862 # 800085f0 <etext+0x5f0>
    8000529a:	8552                	mv	a0,s4
    8000529c:	fffff097          	auipc	ra,0xfffff
    800052a0:	c0a080e7          	jalr	-1014(ra) # 80003ea6 <dirlink>
    800052a4:	02054863          	bltz	a0,800052d4 <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    800052a8:	004a2603          	lw	a2,4(s4)
    800052ac:	fb040593          	addi	a1,s0,-80
    800052b0:	8526                	mv	a0,s1
    800052b2:	fffff097          	auipc	ra,0xfffff
    800052b6:	bf4080e7          	jalr	-1036(ra) # 80003ea6 <dirlink>
    800052ba:	00054d63          	bltz	a0,800052d4 <create+0x15c>
    dp->nlink++;  // for ".."
    800052be:	04a4d783          	lhu	a5,74(s1)
    800052c2:	2785                	addiw	a5,a5,1
    800052c4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800052c8:	8526                	mv	a0,s1
    800052ca:	ffffe097          	auipc	ra,0xffffe
    800052ce:	3f4080e7          	jalr	1012(ra) # 800036be <iupdate>
    800052d2:	b751                	j	80005256 <create+0xde>
  ip->nlink = 0;
    800052d4:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800052d8:	8552                	mv	a0,s4
    800052da:	ffffe097          	auipc	ra,0xffffe
    800052de:	3e4080e7          	jalr	996(ra) # 800036be <iupdate>
  iunlockput(ip);
    800052e2:	8552                	mv	a0,s4
    800052e4:	ffffe097          	auipc	ra,0xffffe
    800052e8:	70c080e7          	jalr	1804(ra) # 800039f0 <iunlockput>
  iunlockput(dp);
    800052ec:	8526                	mv	a0,s1
    800052ee:	ffffe097          	auipc	ra,0xffffe
    800052f2:	702080e7          	jalr	1794(ra) # 800039f0 <iunlockput>
  return 0;
    800052f6:	7a02                	ld	s4,32(sp)
    800052f8:	bdc5                	j	800051e8 <create+0x70>
    return 0;
    800052fa:	8aaa                	mv	s5,a0
    800052fc:	b5f5                	j	800051e8 <create+0x70>

00000000800052fe <sys_dup>:
{
    800052fe:	7179                	addi	sp,sp,-48
    80005300:	f406                	sd	ra,40(sp)
    80005302:	f022                	sd	s0,32(sp)
    80005304:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005306:	fd840613          	addi	a2,s0,-40
    8000530a:	4581                	li	a1,0
    8000530c:	4501                	li	a0,0
    8000530e:	00000097          	auipc	ra,0x0
    80005312:	dc8080e7          	jalr	-568(ra) # 800050d6 <argfd>
    return -1;
    80005316:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005318:	02054763          	bltz	a0,80005346 <sys_dup+0x48>
    8000531c:	ec26                	sd	s1,24(sp)
    8000531e:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80005320:	fd843903          	ld	s2,-40(s0)
    80005324:	854a                	mv	a0,s2
    80005326:	00000097          	auipc	ra,0x0
    8000532a:	e10080e7          	jalr	-496(ra) # 80005136 <fdalloc>
    8000532e:	84aa                	mv	s1,a0
    return -1;
    80005330:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005332:	00054f63          	bltz	a0,80005350 <sys_dup+0x52>
  filedup(f);
    80005336:	854a                	mv	a0,s2
    80005338:	fffff097          	auipc	ra,0xfffff
    8000533c:	298080e7          	jalr	664(ra) # 800045d0 <filedup>
  return fd;
    80005340:	87a6                	mv	a5,s1
    80005342:	64e2                	ld	s1,24(sp)
    80005344:	6942                	ld	s2,16(sp)
}
    80005346:	853e                	mv	a0,a5
    80005348:	70a2                	ld	ra,40(sp)
    8000534a:	7402                	ld	s0,32(sp)
    8000534c:	6145                	addi	sp,sp,48
    8000534e:	8082                	ret
    80005350:	64e2                	ld	s1,24(sp)
    80005352:	6942                	ld	s2,16(sp)
    80005354:	bfcd                	j	80005346 <sys_dup+0x48>

0000000080005356 <sys_read>:
{
    80005356:	7179                	addi	sp,sp,-48
    80005358:	f406                	sd	ra,40(sp)
    8000535a:	f022                	sd	s0,32(sp)
    8000535c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000535e:	fd840593          	addi	a1,s0,-40
    80005362:	4505                	li	a0,1
    80005364:	ffffe097          	auipc	ra,0xffffe
    80005368:	85e080e7          	jalr	-1954(ra) # 80002bc2 <argaddr>
  argint(2, &n);
    8000536c:	fe440593          	addi	a1,s0,-28
    80005370:	4509                	li	a0,2
    80005372:	ffffe097          	auipc	ra,0xffffe
    80005376:	830080e7          	jalr	-2000(ra) # 80002ba2 <argint>
  if(argfd(0, 0, &f) < 0)
    8000537a:	fe840613          	addi	a2,s0,-24
    8000537e:	4581                	li	a1,0
    80005380:	4501                	li	a0,0
    80005382:	00000097          	auipc	ra,0x0
    80005386:	d54080e7          	jalr	-684(ra) # 800050d6 <argfd>
    8000538a:	87aa                	mv	a5,a0
    return -1;
    8000538c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000538e:	0007cc63          	bltz	a5,800053a6 <sys_read+0x50>
  return fileread(f, p, n);
    80005392:	fe442603          	lw	a2,-28(s0)
    80005396:	fd843583          	ld	a1,-40(s0)
    8000539a:	fe843503          	ld	a0,-24(s0)
    8000539e:	fffff097          	auipc	ra,0xfffff
    800053a2:	3d8080e7          	jalr	984(ra) # 80004776 <fileread>
}
    800053a6:	70a2                	ld	ra,40(sp)
    800053a8:	7402                	ld	s0,32(sp)
    800053aa:	6145                	addi	sp,sp,48
    800053ac:	8082                	ret

00000000800053ae <sys_write>:
{
    800053ae:	7179                	addi	sp,sp,-48
    800053b0:	f406                	sd	ra,40(sp)
    800053b2:	f022                	sd	s0,32(sp)
    800053b4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800053b6:	fd840593          	addi	a1,s0,-40
    800053ba:	4505                	li	a0,1
    800053bc:	ffffe097          	auipc	ra,0xffffe
    800053c0:	806080e7          	jalr	-2042(ra) # 80002bc2 <argaddr>
  argint(2, &n);
    800053c4:	fe440593          	addi	a1,s0,-28
    800053c8:	4509                	li	a0,2
    800053ca:	ffffd097          	auipc	ra,0xffffd
    800053ce:	7d8080e7          	jalr	2008(ra) # 80002ba2 <argint>
  if(argfd(0, 0, &f) < 0)
    800053d2:	fe840613          	addi	a2,s0,-24
    800053d6:	4581                	li	a1,0
    800053d8:	4501                	li	a0,0
    800053da:	00000097          	auipc	ra,0x0
    800053de:	cfc080e7          	jalr	-772(ra) # 800050d6 <argfd>
    800053e2:	87aa                	mv	a5,a0
    return -1;
    800053e4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800053e6:	0007cc63          	bltz	a5,800053fe <sys_write+0x50>
  return filewrite(f, p, n);
    800053ea:	fe442603          	lw	a2,-28(s0)
    800053ee:	fd843583          	ld	a1,-40(s0)
    800053f2:	fe843503          	ld	a0,-24(s0)
    800053f6:	fffff097          	auipc	ra,0xfffff
    800053fa:	452080e7          	jalr	1106(ra) # 80004848 <filewrite>
}
    800053fe:	70a2                	ld	ra,40(sp)
    80005400:	7402                	ld	s0,32(sp)
    80005402:	6145                	addi	sp,sp,48
    80005404:	8082                	ret

0000000080005406 <sys_close>:
{
    80005406:	1101                	addi	sp,sp,-32
    80005408:	ec06                	sd	ra,24(sp)
    8000540a:	e822                	sd	s0,16(sp)
    8000540c:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000540e:	fe040613          	addi	a2,s0,-32
    80005412:	fec40593          	addi	a1,s0,-20
    80005416:	4501                	li	a0,0
    80005418:	00000097          	auipc	ra,0x0
    8000541c:	cbe080e7          	jalr	-834(ra) # 800050d6 <argfd>
    return -1;
    80005420:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005422:	02054463          	bltz	a0,8000544a <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005426:	ffffc097          	auipc	ra,0xffffc
    8000542a:	63c080e7          	jalr	1596(ra) # 80001a62 <myproc>
    8000542e:	fec42783          	lw	a5,-20(s0)
    80005432:	07e9                	addi	a5,a5,26
    80005434:	078e                	slli	a5,a5,0x3
    80005436:	953e                	add	a0,a0,a5
    80005438:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000543c:	fe043503          	ld	a0,-32(s0)
    80005440:	fffff097          	auipc	ra,0xfffff
    80005444:	1e2080e7          	jalr	482(ra) # 80004622 <fileclose>
  return 0;
    80005448:	4781                	li	a5,0
}
    8000544a:	853e                	mv	a0,a5
    8000544c:	60e2                	ld	ra,24(sp)
    8000544e:	6442                	ld	s0,16(sp)
    80005450:	6105                	addi	sp,sp,32
    80005452:	8082                	ret

0000000080005454 <sys_fstat>:
{
    80005454:	1101                	addi	sp,sp,-32
    80005456:	ec06                	sd	ra,24(sp)
    80005458:	e822                	sd	s0,16(sp)
    8000545a:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000545c:	fe040593          	addi	a1,s0,-32
    80005460:	4505                	li	a0,1
    80005462:	ffffd097          	auipc	ra,0xffffd
    80005466:	760080e7          	jalr	1888(ra) # 80002bc2 <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000546a:	fe840613          	addi	a2,s0,-24
    8000546e:	4581                	li	a1,0
    80005470:	4501                	li	a0,0
    80005472:	00000097          	auipc	ra,0x0
    80005476:	c64080e7          	jalr	-924(ra) # 800050d6 <argfd>
    8000547a:	87aa                	mv	a5,a0
    return -1;
    8000547c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000547e:	0007ca63          	bltz	a5,80005492 <sys_fstat+0x3e>
  return filestat(f, st);
    80005482:	fe043583          	ld	a1,-32(s0)
    80005486:	fe843503          	ld	a0,-24(s0)
    8000548a:	fffff097          	auipc	ra,0xfffff
    8000548e:	27a080e7          	jalr	634(ra) # 80004704 <filestat>
}
    80005492:	60e2                	ld	ra,24(sp)
    80005494:	6442                	ld	s0,16(sp)
    80005496:	6105                	addi	sp,sp,32
    80005498:	8082                	ret

000000008000549a <sys_link>:
{
    8000549a:	7169                	addi	sp,sp,-304
    8000549c:	f606                	sd	ra,296(sp)
    8000549e:	f222                	sd	s0,288(sp)
    800054a0:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800054a2:	08000613          	li	a2,128
    800054a6:	ed040593          	addi	a1,s0,-304
    800054aa:	4501                	li	a0,0
    800054ac:	ffffd097          	auipc	ra,0xffffd
    800054b0:	736080e7          	jalr	1846(ra) # 80002be2 <argstr>
    return -1;
    800054b4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800054b6:	12054663          	bltz	a0,800055e2 <sys_link+0x148>
    800054ba:	08000613          	li	a2,128
    800054be:	f5040593          	addi	a1,s0,-176
    800054c2:	4505                	li	a0,1
    800054c4:	ffffd097          	auipc	ra,0xffffd
    800054c8:	71e080e7          	jalr	1822(ra) # 80002be2 <argstr>
    return -1;
    800054cc:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800054ce:	10054a63          	bltz	a0,800055e2 <sys_link+0x148>
    800054d2:	ee26                	sd	s1,280(sp)
  begin_op();
    800054d4:	fffff097          	auipc	ra,0xfffff
    800054d8:	c84080e7          	jalr	-892(ra) # 80004158 <begin_op>
  if((ip = namei(old)) == 0){
    800054dc:	ed040513          	addi	a0,s0,-304
    800054e0:	fffff097          	auipc	ra,0xfffff
    800054e4:	a78080e7          	jalr	-1416(ra) # 80003f58 <namei>
    800054e8:	84aa                	mv	s1,a0
    800054ea:	c949                	beqz	a0,8000557c <sys_link+0xe2>
  ilock(ip);
    800054ec:	ffffe097          	auipc	ra,0xffffe
    800054f0:	29e080e7          	jalr	670(ra) # 8000378a <ilock>
  if(ip->type == T_DIR){
    800054f4:	04449703          	lh	a4,68(s1)
    800054f8:	4785                	li	a5,1
    800054fa:	08f70863          	beq	a4,a5,8000558a <sys_link+0xf0>
    800054fe:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80005500:	04a4d783          	lhu	a5,74(s1)
    80005504:	2785                	addiw	a5,a5,1
    80005506:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000550a:	8526                	mv	a0,s1
    8000550c:	ffffe097          	auipc	ra,0xffffe
    80005510:	1b2080e7          	jalr	434(ra) # 800036be <iupdate>
  iunlock(ip);
    80005514:	8526                	mv	a0,s1
    80005516:	ffffe097          	auipc	ra,0xffffe
    8000551a:	33a080e7          	jalr	826(ra) # 80003850 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000551e:	fd040593          	addi	a1,s0,-48
    80005522:	f5040513          	addi	a0,s0,-176
    80005526:	fffff097          	auipc	ra,0xfffff
    8000552a:	a50080e7          	jalr	-1456(ra) # 80003f76 <nameiparent>
    8000552e:	892a                	mv	s2,a0
    80005530:	cd35                	beqz	a0,800055ac <sys_link+0x112>
  ilock(dp);
    80005532:	ffffe097          	auipc	ra,0xffffe
    80005536:	258080e7          	jalr	600(ra) # 8000378a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000553a:	00092703          	lw	a4,0(s2)
    8000553e:	409c                	lw	a5,0(s1)
    80005540:	06f71163          	bne	a4,a5,800055a2 <sys_link+0x108>
    80005544:	40d0                	lw	a2,4(s1)
    80005546:	fd040593          	addi	a1,s0,-48
    8000554a:	854a                	mv	a0,s2
    8000554c:	fffff097          	auipc	ra,0xfffff
    80005550:	95a080e7          	jalr	-1702(ra) # 80003ea6 <dirlink>
    80005554:	04054763          	bltz	a0,800055a2 <sys_link+0x108>
  iunlockput(dp);
    80005558:	854a                	mv	a0,s2
    8000555a:	ffffe097          	auipc	ra,0xffffe
    8000555e:	496080e7          	jalr	1174(ra) # 800039f0 <iunlockput>
  iput(ip);
    80005562:	8526                	mv	a0,s1
    80005564:	ffffe097          	auipc	ra,0xffffe
    80005568:	3e4080e7          	jalr	996(ra) # 80003948 <iput>
  end_op();
    8000556c:	fffff097          	auipc	ra,0xfffff
    80005570:	c66080e7          	jalr	-922(ra) # 800041d2 <end_op>
  return 0;
    80005574:	4781                	li	a5,0
    80005576:	64f2                	ld	s1,280(sp)
    80005578:	6952                	ld	s2,272(sp)
    8000557a:	a0a5                	j	800055e2 <sys_link+0x148>
    end_op();
    8000557c:	fffff097          	auipc	ra,0xfffff
    80005580:	c56080e7          	jalr	-938(ra) # 800041d2 <end_op>
    return -1;
    80005584:	57fd                	li	a5,-1
    80005586:	64f2                	ld	s1,280(sp)
    80005588:	a8a9                	j	800055e2 <sys_link+0x148>
    iunlockput(ip);
    8000558a:	8526                	mv	a0,s1
    8000558c:	ffffe097          	auipc	ra,0xffffe
    80005590:	464080e7          	jalr	1124(ra) # 800039f0 <iunlockput>
    end_op();
    80005594:	fffff097          	auipc	ra,0xfffff
    80005598:	c3e080e7          	jalr	-962(ra) # 800041d2 <end_op>
    return -1;
    8000559c:	57fd                	li	a5,-1
    8000559e:	64f2                	ld	s1,280(sp)
    800055a0:	a089                	j	800055e2 <sys_link+0x148>
    iunlockput(dp);
    800055a2:	854a                	mv	a0,s2
    800055a4:	ffffe097          	auipc	ra,0xffffe
    800055a8:	44c080e7          	jalr	1100(ra) # 800039f0 <iunlockput>
  ilock(ip);
    800055ac:	8526                	mv	a0,s1
    800055ae:	ffffe097          	auipc	ra,0xffffe
    800055b2:	1dc080e7          	jalr	476(ra) # 8000378a <ilock>
  ip->nlink--;
    800055b6:	04a4d783          	lhu	a5,74(s1)
    800055ba:	37fd                	addiw	a5,a5,-1
    800055bc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800055c0:	8526                	mv	a0,s1
    800055c2:	ffffe097          	auipc	ra,0xffffe
    800055c6:	0fc080e7          	jalr	252(ra) # 800036be <iupdate>
  iunlockput(ip);
    800055ca:	8526                	mv	a0,s1
    800055cc:	ffffe097          	auipc	ra,0xffffe
    800055d0:	424080e7          	jalr	1060(ra) # 800039f0 <iunlockput>
  end_op();
    800055d4:	fffff097          	auipc	ra,0xfffff
    800055d8:	bfe080e7          	jalr	-1026(ra) # 800041d2 <end_op>
  return -1;
    800055dc:	57fd                	li	a5,-1
    800055de:	64f2                	ld	s1,280(sp)
    800055e0:	6952                	ld	s2,272(sp)
}
    800055e2:	853e                	mv	a0,a5
    800055e4:	70b2                	ld	ra,296(sp)
    800055e6:	7412                	ld	s0,288(sp)
    800055e8:	6155                	addi	sp,sp,304
    800055ea:	8082                	ret

00000000800055ec <sys_unlink>:
{
    800055ec:	7151                	addi	sp,sp,-240
    800055ee:	f586                	sd	ra,232(sp)
    800055f0:	f1a2                	sd	s0,224(sp)
    800055f2:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800055f4:	08000613          	li	a2,128
    800055f8:	f3040593          	addi	a1,s0,-208
    800055fc:	4501                	li	a0,0
    800055fe:	ffffd097          	auipc	ra,0xffffd
    80005602:	5e4080e7          	jalr	1508(ra) # 80002be2 <argstr>
    80005606:	1a054a63          	bltz	a0,800057ba <sys_unlink+0x1ce>
    8000560a:	eda6                	sd	s1,216(sp)
  begin_op();
    8000560c:	fffff097          	auipc	ra,0xfffff
    80005610:	b4c080e7          	jalr	-1204(ra) # 80004158 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005614:	fb040593          	addi	a1,s0,-80
    80005618:	f3040513          	addi	a0,s0,-208
    8000561c:	fffff097          	auipc	ra,0xfffff
    80005620:	95a080e7          	jalr	-1702(ra) # 80003f76 <nameiparent>
    80005624:	84aa                	mv	s1,a0
    80005626:	cd71                	beqz	a0,80005702 <sys_unlink+0x116>
  ilock(dp);
    80005628:	ffffe097          	auipc	ra,0xffffe
    8000562c:	162080e7          	jalr	354(ra) # 8000378a <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005630:	00003597          	auipc	a1,0x3
    80005634:	fb858593          	addi	a1,a1,-72 # 800085e8 <etext+0x5e8>
    80005638:	fb040513          	addi	a0,s0,-80
    8000563c:	ffffe097          	auipc	ra,0xffffe
    80005640:	640080e7          	jalr	1600(ra) # 80003c7c <namecmp>
    80005644:	14050c63          	beqz	a0,8000579c <sys_unlink+0x1b0>
    80005648:	00003597          	auipc	a1,0x3
    8000564c:	fa858593          	addi	a1,a1,-88 # 800085f0 <etext+0x5f0>
    80005650:	fb040513          	addi	a0,s0,-80
    80005654:	ffffe097          	auipc	ra,0xffffe
    80005658:	628080e7          	jalr	1576(ra) # 80003c7c <namecmp>
    8000565c:	14050063          	beqz	a0,8000579c <sys_unlink+0x1b0>
    80005660:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005662:	f2c40613          	addi	a2,s0,-212
    80005666:	fb040593          	addi	a1,s0,-80
    8000566a:	8526                	mv	a0,s1
    8000566c:	ffffe097          	auipc	ra,0xffffe
    80005670:	62a080e7          	jalr	1578(ra) # 80003c96 <dirlookup>
    80005674:	892a                	mv	s2,a0
    80005676:	12050263          	beqz	a0,8000579a <sys_unlink+0x1ae>
  ilock(ip);
    8000567a:	ffffe097          	auipc	ra,0xffffe
    8000567e:	110080e7          	jalr	272(ra) # 8000378a <ilock>
  if(ip->nlink < 1)
    80005682:	04a91783          	lh	a5,74(s2)
    80005686:	08f05563          	blez	a5,80005710 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000568a:	04491703          	lh	a4,68(s2)
    8000568e:	4785                	li	a5,1
    80005690:	08f70963          	beq	a4,a5,80005722 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80005694:	4641                	li	a2,16
    80005696:	4581                	li	a1,0
    80005698:	fc040513          	addi	a0,s0,-64
    8000569c:	ffffb097          	auipc	ra,0xffffb
    800056a0:	6b0080e7          	jalr	1712(ra) # 80000d4c <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800056a4:	4741                	li	a4,16
    800056a6:	f2c42683          	lw	a3,-212(s0)
    800056aa:	fc040613          	addi	a2,s0,-64
    800056ae:	4581                	li	a1,0
    800056b0:	8526                	mv	a0,s1
    800056b2:	ffffe097          	auipc	ra,0xffffe
    800056b6:	4a0080e7          	jalr	1184(ra) # 80003b52 <writei>
    800056ba:	47c1                	li	a5,16
    800056bc:	0af51b63          	bne	a0,a5,80005772 <sys_unlink+0x186>
  if(ip->type == T_DIR){
    800056c0:	04491703          	lh	a4,68(s2)
    800056c4:	4785                	li	a5,1
    800056c6:	0af70f63          	beq	a4,a5,80005784 <sys_unlink+0x198>
  iunlockput(dp);
    800056ca:	8526                	mv	a0,s1
    800056cc:	ffffe097          	auipc	ra,0xffffe
    800056d0:	324080e7          	jalr	804(ra) # 800039f0 <iunlockput>
  ip->nlink--;
    800056d4:	04a95783          	lhu	a5,74(s2)
    800056d8:	37fd                	addiw	a5,a5,-1
    800056da:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800056de:	854a                	mv	a0,s2
    800056e0:	ffffe097          	auipc	ra,0xffffe
    800056e4:	fde080e7          	jalr	-34(ra) # 800036be <iupdate>
  iunlockput(ip);
    800056e8:	854a                	mv	a0,s2
    800056ea:	ffffe097          	auipc	ra,0xffffe
    800056ee:	306080e7          	jalr	774(ra) # 800039f0 <iunlockput>
  end_op();
    800056f2:	fffff097          	auipc	ra,0xfffff
    800056f6:	ae0080e7          	jalr	-1312(ra) # 800041d2 <end_op>
  return 0;
    800056fa:	4501                	li	a0,0
    800056fc:	64ee                	ld	s1,216(sp)
    800056fe:	694e                	ld	s2,208(sp)
    80005700:	a84d                	j	800057b2 <sys_unlink+0x1c6>
    end_op();
    80005702:	fffff097          	auipc	ra,0xfffff
    80005706:	ad0080e7          	jalr	-1328(ra) # 800041d2 <end_op>
    return -1;
    8000570a:	557d                	li	a0,-1
    8000570c:	64ee                	ld	s1,216(sp)
    8000570e:	a055                	j	800057b2 <sys_unlink+0x1c6>
    80005710:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80005712:	00003517          	auipc	a0,0x3
    80005716:	ee650513          	addi	a0,a0,-282 # 800085f8 <etext+0x5f8>
    8000571a:	ffffb097          	auipc	ra,0xffffb
    8000571e:	e46080e7          	jalr	-442(ra) # 80000560 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005722:	04c92703          	lw	a4,76(s2)
    80005726:	02000793          	li	a5,32
    8000572a:	f6e7f5e3          	bgeu	a5,a4,80005694 <sys_unlink+0xa8>
    8000572e:	e5ce                	sd	s3,200(sp)
    80005730:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005734:	4741                	li	a4,16
    80005736:	86ce                	mv	a3,s3
    80005738:	f1840613          	addi	a2,s0,-232
    8000573c:	4581                	li	a1,0
    8000573e:	854a                	mv	a0,s2
    80005740:	ffffe097          	auipc	ra,0xffffe
    80005744:	302080e7          	jalr	770(ra) # 80003a42 <readi>
    80005748:	47c1                	li	a5,16
    8000574a:	00f51c63          	bne	a0,a5,80005762 <sys_unlink+0x176>
    if(de.inum != 0)
    8000574e:	f1845783          	lhu	a5,-232(s0)
    80005752:	e7b5                	bnez	a5,800057be <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005754:	29c1                	addiw	s3,s3,16
    80005756:	04c92783          	lw	a5,76(s2)
    8000575a:	fcf9ede3          	bltu	s3,a5,80005734 <sys_unlink+0x148>
    8000575e:	69ae                	ld	s3,200(sp)
    80005760:	bf15                	j	80005694 <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80005762:	00003517          	auipc	a0,0x3
    80005766:	eae50513          	addi	a0,a0,-338 # 80008610 <etext+0x610>
    8000576a:	ffffb097          	auipc	ra,0xffffb
    8000576e:	df6080e7          	jalr	-522(ra) # 80000560 <panic>
    80005772:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80005774:	00003517          	auipc	a0,0x3
    80005778:	eb450513          	addi	a0,a0,-332 # 80008628 <etext+0x628>
    8000577c:	ffffb097          	auipc	ra,0xffffb
    80005780:	de4080e7          	jalr	-540(ra) # 80000560 <panic>
    dp->nlink--;
    80005784:	04a4d783          	lhu	a5,74(s1)
    80005788:	37fd                	addiw	a5,a5,-1
    8000578a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000578e:	8526                	mv	a0,s1
    80005790:	ffffe097          	auipc	ra,0xffffe
    80005794:	f2e080e7          	jalr	-210(ra) # 800036be <iupdate>
    80005798:	bf0d                	j	800056ca <sys_unlink+0xde>
    8000579a:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    8000579c:	8526                	mv	a0,s1
    8000579e:	ffffe097          	auipc	ra,0xffffe
    800057a2:	252080e7          	jalr	594(ra) # 800039f0 <iunlockput>
  end_op();
    800057a6:	fffff097          	auipc	ra,0xfffff
    800057aa:	a2c080e7          	jalr	-1492(ra) # 800041d2 <end_op>
  return -1;
    800057ae:	557d                	li	a0,-1
    800057b0:	64ee                	ld	s1,216(sp)
}
    800057b2:	70ae                	ld	ra,232(sp)
    800057b4:	740e                	ld	s0,224(sp)
    800057b6:	616d                	addi	sp,sp,240
    800057b8:	8082                	ret
    return -1;
    800057ba:	557d                	li	a0,-1
    800057bc:	bfdd                	j	800057b2 <sys_unlink+0x1c6>
    iunlockput(ip);
    800057be:	854a                	mv	a0,s2
    800057c0:	ffffe097          	auipc	ra,0xffffe
    800057c4:	230080e7          	jalr	560(ra) # 800039f0 <iunlockput>
    goto bad;
    800057c8:	694e                	ld	s2,208(sp)
    800057ca:	69ae                	ld	s3,200(sp)
    800057cc:	bfc1                	j	8000579c <sys_unlink+0x1b0>

00000000800057ce <sys_open>:

uint64
sys_open(void)
{
    800057ce:	7131                	addi	sp,sp,-192
    800057d0:	fd06                	sd	ra,184(sp)
    800057d2:	f922                	sd	s0,176(sp)
    800057d4:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800057d6:	f4c40593          	addi	a1,s0,-180
    800057da:	4505                	li	a0,1
    800057dc:	ffffd097          	auipc	ra,0xffffd
    800057e0:	3c6080e7          	jalr	966(ra) # 80002ba2 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800057e4:	08000613          	li	a2,128
    800057e8:	f5040593          	addi	a1,s0,-176
    800057ec:	4501                	li	a0,0
    800057ee:	ffffd097          	auipc	ra,0xffffd
    800057f2:	3f4080e7          	jalr	1012(ra) # 80002be2 <argstr>
    800057f6:	87aa                	mv	a5,a0
    return -1;
    800057f8:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800057fa:	0a07ce63          	bltz	a5,800058b6 <sys_open+0xe8>
    800057fe:	f526                	sd	s1,168(sp)

  begin_op();
    80005800:	fffff097          	auipc	ra,0xfffff
    80005804:	958080e7          	jalr	-1704(ra) # 80004158 <begin_op>

  if(omode & O_CREATE){
    80005808:	f4c42783          	lw	a5,-180(s0)
    8000580c:	2007f793          	andi	a5,a5,512
    80005810:	cfd5                	beqz	a5,800058cc <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005812:	4681                	li	a3,0
    80005814:	4601                	li	a2,0
    80005816:	4589                	li	a1,2
    80005818:	f5040513          	addi	a0,s0,-176
    8000581c:	00000097          	auipc	ra,0x0
    80005820:	95c080e7          	jalr	-1700(ra) # 80005178 <create>
    80005824:	84aa                	mv	s1,a0
    if(ip == 0){
    80005826:	cd41                	beqz	a0,800058be <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005828:	04449703          	lh	a4,68(s1)
    8000582c:	478d                	li	a5,3
    8000582e:	00f71763          	bne	a4,a5,8000583c <sys_open+0x6e>
    80005832:	0464d703          	lhu	a4,70(s1)
    80005836:	47a5                	li	a5,9
    80005838:	0ee7e163          	bltu	a5,a4,8000591a <sys_open+0x14c>
    8000583c:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000583e:	fffff097          	auipc	ra,0xfffff
    80005842:	d28080e7          	jalr	-728(ra) # 80004566 <filealloc>
    80005846:	892a                	mv	s2,a0
    80005848:	c97d                	beqz	a0,8000593e <sys_open+0x170>
    8000584a:	ed4e                	sd	s3,152(sp)
    8000584c:	00000097          	auipc	ra,0x0
    80005850:	8ea080e7          	jalr	-1814(ra) # 80005136 <fdalloc>
    80005854:	89aa                	mv	s3,a0
    80005856:	0c054e63          	bltz	a0,80005932 <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000585a:	04449703          	lh	a4,68(s1)
    8000585e:	478d                	li	a5,3
    80005860:	0ef70c63          	beq	a4,a5,80005958 <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005864:	4789                	li	a5,2
    80005866:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    8000586a:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    8000586e:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005872:	f4c42783          	lw	a5,-180(s0)
    80005876:	0017c713          	xori	a4,a5,1
    8000587a:	8b05                	andi	a4,a4,1
    8000587c:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005880:	0037f713          	andi	a4,a5,3
    80005884:	00e03733          	snez	a4,a4
    80005888:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000588c:	4007f793          	andi	a5,a5,1024
    80005890:	c791                	beqz	a5,8000589c <sys_open+0xce>
    80005892:	04449703          	lh	a4,68(s1)
    80005896:	4789                	li	a5,2
    80005898:	0cf70763          	beq	a4,a5,80005966 <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    8000589c:	8526                	mv	a0,s1
    8000589e:	ffffe097          	auipc	ra,0xffffe
    800058a2:	fb2080e7          	jalr	-78(ra) # 80003850 <iunlock>
  end_op();
    800058a6:	fffff097          	auipc	ra,0xfffff
    800058aa:	92c080e7          	jalr	-1748(ra) # 800041d2 <end_op>

  return fd;
    800058ae:	854e                	mv	a0,s3
    800058b0:	74aa                	ld	s1,168(sp)
    800058b2:	790a                	ld	s2,160(sp)
    800058b4:	69ea                	ld	s3,152(sp)
}
    800058b6:	70ea                	ld	ra,184(sp)
    800058b8:	744a                	ld	s0,176(sp)
    800058ba:	6129                	addi	sp,sp,192
    800058bc:	8082                	ret
      end_op();
    800058be:	fffff097          	auipc	ra,0xfffff
    800058c2:	914080e7          	jalr	-1772(ra) # 800041d2 <end_op>
      return -1;
    800058c6:	557d                	li	a0,-1
    800058c8:	74aa                	ld	s1,168(sp)
    800058ca:	b7f5                	j	800058b6 <sys_open+0xe8>
    if((ip = namei(path)) == 0){
    800058cc:	f5040513          	addi	a0,s0,-176
    800058d0:	ffffe097          	auipc	ra,0xffffe
    800058d4:	688080e7          	jalr	1672(ra) # 80003f58 <namei>
    800058d8:	84aa                	mv	s1,a0
    800058da:	c90d                	beqz	a0,8000590c <sys_open+0x13e>
    ilock(ip);
    800058dc:	ffffe097          	auipc	ra,0xffffe
    800058e0:	eae080e7          	jalr	-338(ra) # 8000378a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800058e4:	04449703          	lh	a4,68(s1)
    800058e8:	4785                	li	a5,1
    800058ea:	f2f71fe3          	bne	a4,a5,80005828 <sys_open+0x5a>
    800058ee:	f4c42783          	lw	a5,-180(s0)
    800058f2:	d7a9                	beqz	a5,8000583c <sys_open+0x6e>
      iunlockput(ip);
    800058f4:	8526                	mv	a0,s1
    800058f6:	ffffe097          	auipc	ra,0xffffe
    800058fa:	0fa080e7          	jalr	250(ra) # 800039f0 <iunlockput>
      end_op();
    800058fe:	fffff097          	auipc	ra,0xfffff
    80005902:	8d4080e7          	jalr	-1836(ra) # 800041d2 <end_op>
      return -1;
    80005906:	557d                	li	a0,-1
    80005908:	74aa                	ld	s1,168(sp)
    8000590a:	b775                	j	800058b6 <sys_open+0xe8>
      end_op();
    8000590c:	fffff097          	auipc	ra,0xfffff
    80005910:	8c6080e7          	jalr	-1850(ra) # 800041d2 <end_op>
      return -1;
    80005914:	557d                	li	a0,-1
    80005916:	74aa                	ld	s1,168(sp)
    80005918:	bf79                	j	800058b6 <sys_open+0xe8>
    iunlockput(ip);
    8000591a:	8526                	mv	a0,s1
    8000591c:	ffffe097          	auipc	ra,0xffffe
    80005920:	0d4080e7          	jalr	212(ra) # 800039f0 <iunlockput>
    end_op();
    80005924:	fffff097          	auipc	ra,0xfffff
    80005928:	8ae080e7          	jalr	-1874(ra) # 800041d2 <end_op>
    return -1;
    8000592c:	557d                	li	a0,-1
    8000592e:	74aa                	ld	s1,168(sp)
    80005930:	b759                	j	800058b6 <sys_open+0xe8>
      fileclose(f);
    80005932:	854a                	mv	a0,s2
    80005934:	fffff097          	auipc	ra,0xfffff
    80005938:	cee080e7          	jalr	-786(ra) # 80004622 <fileclose>
    8000593c:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    8000593e:	8526                	mv	a0,s1
    80005940:	ffffe097          	auipc	ra,0xffffe
    80005944:	0b0080e7          	jalr	176(ra) # 800039f0 <iunlockput>
    end_op();
    80005948:	fffff097          	auipc	ra,0xfffff
    8000594c:	88a080e7          	jalr	-1910(ra) # 800041d2 <end_op>
    return -1;
    80005950:	557d                	li	a0,-1
    80005952:	74aa                	ld	s1,168(sp)
    80005954:	790a                	ld	s2,160(sp)
    80005956:	b785                	j	800058b6 <sys_open+0xe8>
    f->type = FD_DEVICE;
    80005958:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    8000595c:	04649783          	lh	a5,70(s1)
    80005960:	02f91223          	sh	a5,36(s2)
    80005964:	b729                	j	8000586e <sys_open+0xa0>
    itrunc(ip);
    80005966:	8526                	mv	a0,s1
    80005968:	ffffe097          	auipc	ra,0xffffe
    8000596c:	f34080e7          	jalr	-204(ra) # 8000389c <itrunc>
    80005970:	b735                	j	8000589c <sys_open+0xce>

0000000080005972 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005972:	7175                	addi	sp,sp,-144
    80005974:	e506                	sd	ra,136(sp)
    80005976:	e122                	sd	s0,128(sp)
    80005978:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000597a:	ffffe097          	auipc	ra,0xffffe
    8000597e:	7de080e7          	jalr	2014(ra) # 80004158 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005982:	08000613          	li	a2,128
    80005986:	f7040593          	addi	a1,s0,-144
    8000598a:	4501                	li	a0,0
    8000598c:	ffffd097          	auipc	ra,0xffffd
    80005990:	256080e7          	jalr	598(ra) # 80002be2 <argstr>
    80005994:	02054963          	bltz	a0,800059c6 <sys_mkdir+0x54>
    80005998:	4681                	li	a3,0
    8000599a:	4601                	li	a2,0
    8000599c:	4585                	li	a1,1
    8000599e:	f7040513          	addi	a0,s0,-144
    800059a2:	fffff097          	auipc	ra,0xfffff
    800059a6:	7d6080e7          	jalr	2006(ra) # 80005178 <create>
    800059aa:	cd11                	beqz	a0,800059c6 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800059ac:	ffffe097          	auipc	ra,0xffffe
    800059b0:	044080e7          	jalr	68(ra) # 800039f0 <iunlockput>
  end_op();
    800059b4:	fffff097          	auipc	ra,0xfffff
    800059b8:	81e080e7          	jalr	-2018(ra) # 800041d2 <end_op>
  return 0;
    800059bc:	4501                	li	a0,0
}
    800059be:	60aa                	ld	ra,136(sp)
    800059c0:	640a                	ld	s0,128(sp)
    800059c2:	6149                	addi	sp,sp,144
    800059c4:	8082                	ret
    end_op();
    800059c6:	fffff097          	auipc	ra,0xfffff
    800059ca:	80c080e7          	jalr	-2036(ra) # 800041d2 <end_op>
    return -1;
    800059ce:	557d                	li	a0,-1
    800059d0:	b7fd                	j	800059be <sys_mkdir+0x4c>

00000000800059d2 <sys_mknod>:

uint64
sys_mknod(void)
{
    800059d2:	7135                	addi	sp,sp,-160
    800059d4:	ed06                	sd	ra,152(sp)
    800059d6:	e922                	sd	s0,144(sp)
    800059d8:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800059da:	ffffe097          	auipc	ra,0xffffe
    800059de:	77e080e7          	jalr	1918(ra) # 80004158 <begin_op>
  argint(1, &major);
    800059e2:	f6c40593          	addi	a1,s0,-148
    800059e6:	4505                	li	a0,1
    800059e8:	ffffd097          	auipc	ra,0xffffd
    800059ec:	1ba080e7          	jalr	442(ra) # 80002ba2 <argint>
  argint(2, &minor);
    800059f0:	f6840593          	addi	a1,s0,-152
    800059f4:	4509                	li	a0,2
    800059f6:	ffffd097          	auipc	ra,0xffffd
    800059fa:	1ac080e7          	jalr	428(ra) # 80002ba2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800059fe:	08000613          	li	a2,128
    80005a02:	f7040593          	addi	a1,s0,-144
    80005a06:	4501                	li	a0,0
    80005a08:	ffffd097          	auipc	ra,0xffffd
    80005a0c:	1da080e7          	jalr	474(ra) # 80002be2 <argstr>
    80005a10:	02054b63          	bltz	a0,80005a46 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005a14:	f6841683          	lh	a3,-152(s0)
    80005a18:	f6c41603          	lh	a2,-148(s0)
    80005a1c:	458d                	li	a1,3
    80005a1e:	f7040513          	addi	a0,s0,-144
    80005a22:	fffff097          	auipc	ra,0xfffff
    80005a26:	756080e7          	jalr	1878(ra) # 80005178 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005a2a:	cd11                	beqz	a0,80005a46 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005a2c:	ffffe097          	auipc	ra,0xffffe
    80005a30:	fc4080e7          	jalr	-60(ra) # 800039f0 <iunlockput>
  end_op();
    80005a34:	ffffe097          	auipc	ra,0xffffe
    80005a38:	79e080e7          	jalr	1950(ra) # 800041d2 <end_op>
  return 0;
    80005a3c:	4501                	li	a0,0
}
    80005a3e:	60ea                	ld	ra,152(sp)
    80005a40:	644a                	ld	s0,144(sp)
    80005a42:	610d                	addi	sp,sp,160
    80005a44:	8082                	ret
    end_op();
    80005a46:	ffffe097          	auipc	ra,0xffffe
    80005a4a:	78c080e7          	jalr	1932(ra) # 800041d2 <end_op>
    return -1;
    80005a4e:	557d                	li	a0,-1
    80005a50:	b7fd                	j	80005a3e <sys_mknod+0x6c>

0000000080005a52 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005a52:	7135                	addi	sp,sp,-160
    80005a54:	ed06                	sd	ra,152(sp)
    80005a56:	e922                	sd	s0,144(sp)
    80005a58:	e14a                	sd	s2,128(sp)
    80005a5a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005a5c:	ffffc097          	auipc	ra,0xffffc
    80005a60:	006080e7          	jalr	6(ra) # 80001a62 <myproc>
    80005a64:	892a                	mv	s2,a0
  
  begin_op();
    80005a66:	ffffe097          	auipc	ra,0xffffe
    80005a6a:	6f2080e7          	jalr	1778(ra) # 80004158 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005a6e:	08000613          	li	a2,128
    80005a72:	f6040593          	addi	a1,s0,-160
    80005a76:	4501                	li	a0,0
    80005a78:	ffffd097          	auipc	ra,0xffffd
    80005a7c:	16a080e7          	jalr	362(ra) # 80002be2 <argstr>
    80005a80:	04054d63          	bltz	a0,80005ada <sys_chdir+0x88>
    80005a84:	e526                	sd	s1,136(sp)
    80005a86:	f6040513          	addi	a0,s0,-160
    80005a8a:	ffffe097          	auipc	ra,0xffffe
    80005a8e:	4ce080e7          	jalr	1230(ra) # 80003f58 <namei>
    80005a92:	84aa                	mv	s1,a0
    80005a94:	c131                	beqz	a0,80005ad8 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005a96:	ffffe097          	auipc	ra,0xffffe
    80005a9a:	cf4080e7          	jalr	-780(ra) # 8000378a <ilock>
  if(ip->type != T_DIR){
    80005a9e:	04449703          	lh	a4,68(s1)
    80005aa2:	4785                	li	a5,1
    80005aa4:	04f71163          	bne	a4,a5,80005ae6 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005aa8:	8526                	mv	a0,s1
    80005aaa:	ffffe097          	auipc	ra,0xffffe
    80005aae:	da6080e7          	jalr	-602(ra) # 80003850 <iunlock>
  iput(p->cwd);
    80005ab2:	15093503          	ld	a0,336(s2)
    80005ab6:	ffffe097          	auipc	ra,0xffffe
    80005aba:	e92080e7          	jalr	-366(ra) # 80003948 <iput>
  end_op();
    80005abe:	ffffe097          	auipc	ra,0xffffe
    80005ac2:	714080e7          	jalr	1812(ra) # 800041d2 <end_op>
  p->cwd = ip;
    80005ac6:	14993823          	sd	s1,336(s2)
  return 0;
    80005aca:	4501                	li	a0,0
    80005acc:	64aa                	ld	s1,136(sp)
}
    80005ace:	60ea                	ld	ra,152(sp)
    80005ad0:	644a                	ld	s0,144(sp)
    80005ad2:	690a                	ld	s2,128(sp)
    80005ad4:	610d                	addi	sp,sp,160
    80005ad6:	8082                	ret
    80005ad8:	64aa                	ld	s1,136(sp)
    end_op();
    80005ada:	ffffe097          	auipc	ra,0xffffe
    80005ade:	6f8080e7          	jalr	1784(ra) # 800041d2 <end_op>
    return -1;
    80005ae2:	557d                	li	a0,-1
    80005ae4:	b7ed                	j	80005ace <sys_chdir+0x7c>
    iunlockput(ip);
    80005ae6:	8526                	mv	a0,s1
    80005ae8:	ffffe097          	auipc	ra,0xffffe
    80005aec:	f08080e7          	jalr	-248(ra) # 800039f0 <iunlockput>
    end_op();
    80005af0:	ffffe097          	auipc	ra,0xffffe
    80005af4:	6e2080e7          	jalr	1762(ra) # 800041d2 <end_op>
    return -1;
    80005af8:	557d                	li	a0,-1
    80005afa:	64aa                	ld	s1,136(sp)
    80005afc:	bfc9                	j	80005ace <sys_chdir+0x7c>

0000000080005afe <sys_exec>:

uint64
sys_exec(void)
{
    80005afe:	7121                	addi	sp,sp,-448
    80005b00:	ff06                	sd	ra,440(sp)
    80005b02:	fb22                	sd	s0,432(sp)
    80005b04:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005b06:	e4840593          	addi	a1,s0,-440
    80005b0a:	4505                	li	a0,1
    80005b0c:	ffffd097          	auipc	ra,0xffffd
    80005b10:	0b6080e7          	jalr	182(ra) # 80002bc2 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005b14:	08000613          	li	a2,128
    80005b18:	f5040593          	addi	a1,s0,-176
    80005b1c:	4501                	li	a0,0
    80005b1e:	ffffd097          	auipc	ra,0xffffd
    80005b22:	0c4080e7          	jalr	196(ra) # 80002be2 <argstr>
    80005b26:	87aa                	mv	a5,a0
    return -1;
    80005b28:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005b2a:	0e07c263          	bltz	a5,80005c0e <sys_exec+0x110>
    80005b2e:	f726                	sd	s1,424(sp)
    80005b30:	f34a                	sd	s2,416(sp)
    80005b32:	ef4e                	sd	s3,408(sp)
    80005b34:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005b36:	10000613          	li	a2,256
    80005b3a:	4581                	li	a1,0
    80005b3c:	e5040513          	addi	a0,s0,-432
    80005b40:	ffffb097          	auipc	ra,0xffffb
    80005b44:	20c080e7          	jalr	524(ra) # 80000d4c <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005b48:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005b4c:	89a6                	mv	s3,s1
    80005b4e:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005b50:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005b54:	00391513          	slli	a0,s2,0x3
    80005b58:	e4040593          	addi	a1,s0,-448
    80005b5c:	e4843783          	ld	a5,-440(s0)
    80005b60:	953e                	add	a0,a0,a5
    80005b62:	ffffd097          	auipc	ra,0xffffd
    80005b66:	fa2080e7          	jalr	-94(ra) # 80002b04 <fetchaddr>
    80005b6a:	02054a63          	bltz	a0,80005b9e <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80005b6e:	e4043783          	ld	a5,-448(s0)
    80005b72:	c7b9                	beqz	a5,80005bc0 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005b74:	ffffb097          	auipc	ra,0xffffb
    80005b78:	fec080e7          	jalr	-20(ra) # 80000b60 <kalloc>
    80005b7c:	85aa                	mv	a1,a0
    80005b7e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005b82:	cd11                	beqz	a0,80005b9e <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005b84:	6605                	lui	a2,0x1
    80005b86:	e4043503          	ld	a0,-448(s0)
    80005b8a:	ffffd097          	auipc	ra,0xffffd
    80005b8e:	fcc080e7          	jalr	-52(ra) # 80002b56 <fetchstr>
    80005b92:	00054663          	bltz	a0,80005b9e <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80005b96:	0905                	addi	s2,s2,1
    80005b98:	09a1                	addi	s3,s3,8
    80005b9a:	fb491de3          	bne	s2,s4,80005b54 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b9e:	f5040913          	addi	s2,s0,-176
    80005ba2:	6088                	ld	a0,0(s1)
    80005ba4:	c125                	beqz	a0,80005c04 <sys_exec+0x106>
    kfree(argv[i]);
    80005ba6:	ffffb097          	auipc	ra,0xffffb
    80005baa:	ebc080e7          	jalr	-324(ra) # 80000a62 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005bae:	04a1                	addi	s1,s1,8
    80005bb0:	ff2499e3          	bne	s1,s2,80005ba2 <sys_exec+0xa4>
  return -1;
    80005bb4:	557d                	li	a0,-1
    80005bb6:	74ba                	ld	s1,424(sp)
    80005bb8:	791a                	ld	s2,416(sp)
    80005bba:	69fa                	ld	s3,408(sp)
    80005bbc:	6a5a                	ld	s4,400(sp)
    80005bbe:	a881                	j	80005c0e <sys_exec+0x110>
      argv[i] = 0;
    80005bc0:	0009079b          	sext.w	a5,s2
    80005bc4:	078e                	slli	a5,a5,0x3
    80005bc6:	fd078793          	addi	a5,a5,-48
    80005bca:	97a2                	add	a5,a5,s0
    80005bcc:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005bd0:	e5040593          	addi	a1,s0,-432
    80005bd4:	f5040513          	addi	a0,s0,-176
    80005bd8:	fffff097          	auipc	ra,0xfffff
    80005bdc:	120080e7          	jalr	288(ra) # 80004cf8 <exec>
    80005be0:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005be2:	f5040993          	addi	s3,s0,-176
    80005be6:	6088                	ld	a0,0(s1)
    80005be8:	c901                	beqz	a0,80005bf8 <sys_exec+0xfa>
    kfree(argv[i]);
    80005bea:	ffffb097          	auipc	ra,0xffffb
    80005bee:	e78080e7          	jalr	-392(ra) # 80000a62 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005bf2:	04a1                	addi	s1,s1,8
    80005bf4:	ff3499e3          	bne	s1,s3,80005be6 <sys_exec+0xe8>
  return ret;
    80005bf8:	854a                	mv	a0,s2
    80005bfa:	74ba                	ld	s1,424(sp)
    80005bfc:	791a                	ld	s2,416(sp)
    80005bfe:	69fa                	ld	s3,408(sp)
    80005c00:	6a5a                	ld	s4,400(sp)
    80005c02:	a031                	j	80005c0e <sys_exec+0x110>
  return -1;
    80005c04:	557d                	li	a0,-1
    80005c06:	74ba                	ld	s1,424(sp)
    80005c08:	791a                	ld	s2,416(sp)
    80005c0a:	69fa                	ld	s3,408(sp)
    80005c0c:	6a5a                	ld	s4,400(sp)
}
    80005c0e:	70fa                	ld	ra,440(sp)
    80005c10:	745a                	ld	s0,432(sp)
    80005c12:	6139                	addi	sp,sp,448
    80005c14:	8082                	ret

0000000080005c16 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005c16:	7139                	addi	sp,sp,-64
    80005c18:	fc06                	sd	ra,56(sp)
    80005c1a:	f822                	sd	s0,48(sp)
    80005c1c:	f426                	sd	s1,40(sp)
    80005c1e:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005c20:	ffffc097          	auipc	ra,0xffffc
    80005c24:	e42080e7          	jalr	-446(ra) # 80001a62 <myproc>
    80005c28:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005c2a:	fd840593          	addi	a1,s0,-40
    80005c2e:	4501                	li	a0,0
    80005c30:	ffffd097          	auipc	ra,0xffffd
    80005c34:	f92080e7          	jalr	-110(ra) # 80002bc2 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005c38:	fc840593          	addi	a1,s0,-56
    80005c3c:	fd040513          	addi	a0,s0,-48
    80005c40:	fffff097          	auipc	ra,0xfffff
    80005c44:	d50080e7          	jalr	-688(ra) # 80004990 <pipealloc>
    return -1;
    80005c48:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005c4a:	0c054463          	bltz	a0,80005d12 <sys_pipe+0xfc>
  fd0 = -1;
    80005c4e:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005c52:	fd043503          	ld	a0,-48(s0)
    80005c56:	fffff097          	auipc	ra,0xfffff
    80005c5a:	4e0080e7          	jalr	1248(ra) # 80005136 <fdalloc>
    80005c5e:	fca42223          	sw	a0,-60(s0)
    80005c62:	08054b63          	bltz	a0,80005cf8 <sys_pipe+0xe2>
    80005c66:	fc843503          	ld	a0,-56(s0)
    80005c6a:	fffff097          	auipc	ra,0xfffff
    80005c6e:	4cc080e7          	jalr	1228(ra) # 80005136 <fdalloc>
    80005c72:	fca42023          	sw	a0,-64(s0)
    80005c76:	06054863          	bltz	a0,80005ce6 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005c7a:	4691                	li	a3,4
    80005c7c:	fc440613          	addi	a2,s0,-60
    80005c80:	fd843583          	ld	a1,-40(s0)
    80005c84:	68a8                	ld	a0,80(s1)
    80005c86:	ffffc097          	auipc	ra,0xffffc
    80005c8a:	a74080e7          	jalr	-1420(ra) # 800016fa <copyout>
    80005c8e:	02054063          	bltz	a0,80005cae <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005c92:	4691                	li	a3,4
    80005c94:	fc040613          	addi	a2,s0,-64
    80005c98:	fd843583          	ld	a1,-40(s0)
    80005c9c:	0591                	addi	a1,a1,4
    80005c9e:	68a8                	ld	a0,80(s1)
    80005ca0:	ffffc097          	auipc	ra,0xffffc
    80005ca4:	a5a080e7          	jalr	-1446(ra) # 800016fa <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005ca8:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005caa:	06055463          	bgez	a0,80005d12 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005cae:	fc442783          	lw	a5,-60(s0)
    80005cb2:	07e9                	addi	a5,a5,26
    80005cb4:	078e                	slli	a5,a5,0x3
    80005cb6:	97a6                	add	a5,a5,s1
    80005cb8:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005cbc:	fc042783          	lw	a5,-64(s0)
    80005cc0:	07e9                	addi	a5,a5,26
    80005cc2:	078e                	slli	a5,a5,0x3
    80005cc4:	94be                	add	s1,s1,a5
    80005cc6:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005cca:	fd043503          	ld	a0,-48(s0)
    80005cce:	fffff097          	auipc	ra,0xfffff
    80005cd2:	954080e7          	jalr	-1708(ra) # 80004622 <fileclose>
    fileclose(wf);
    80005cd6:	fc843503          	ld	a0,-56(s0)
    80005cda:	fffff097          	auipc	ra,0xfffff
    80005cde:	948080e7          	jalr	-1720(ra) # 80004622 <fileclose>
    return -1;
    80005ce2:	57fd                	li	a5,-1
    80005ce4:	a03d                	j	80005d12 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005ce6:	fc442783          	lw	a5,-60(s0)
    80005cea:	0007c763          	bltz	a5,80005cf8 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005cee:	07e9                	addi	a5,a5,26
    80005cf0:	078e                	slli	a5,a5,0x3
    80005cf2:	97a6                	add	a5,a5,s1
    80005cf4:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005cf8:	fd043503          	ld	a0,-48(s0)
    80005cfc:	fffff097          	auipc	ra,0xfffff
    80005d00:	926080e7          	jalr	-1754(ra) # 80004622 <fileclose>
    fileclose(wf);
    80005d04:	fc843503          	ld	a0,-56(s0)
    80005d08:	fffff097          	auipc	ra,0xfffff
    80005d0c:	91a080e7          	jalr	-1766(ra) # 80004622 <fileclose>
    return -1;
    80005d10:	57fd                	li	a5,-1
}
    80005d12:	853e                	mv	a0,a5
    80005d14:	70e2                	ld	ra,56(sp)
    80005d16:	7442                	ld	s0,48(sp)
    80005d18:	74a2                	ld	s1,40(sp)
    80005d1a:	6121                	addi	sp,sp,64
    80005d1c:	8082                	ret
	...

0000000080005d20 <kernelvec>:
    80005d20:	7111                	addi	sp,sp,-256
    80005d22:	e006                	sd	ra,0(sp)
    80005d24:	e40a                	sd	sp,8(sp)
    80005d26:	e80e                	sd	gp,16(sp)
    80005d28:	ec12                	sd	tp,24(sp)
    80005d2a:	f016                	sd	t0,32(sp)
    80005d2c:	f41a                	sd	t1,40(sp)
    80005d2e:	f81e                	sd	t2,48(sp)
    80005d30:	fc22                	sd	s0,56(sp)
    80005d32:	e0a6                	sd	s1,64(sp)
    80005d34:	e4aa                	sd	a0,72(sp)
    80005d36:	e8ae                	sd	a1,80(sp)
    80005d38:	ecb2                	sd	a2,88(sp)
    80005d3a:	f0b6                	sd	a3,96(sp)
    80005d3c:	f4ba                	sd	a4,104(sp)
    80005d3e:	f8be                	sd	a5,112(sp)
    80005d40:	fcc2                	sd	a6,120(sp)
    80005d42:	e146                	sd	a7,128(sp)
    80005d44:	e54a                	sd	s2,136(sp)
    80005d46:	e94e                	sd	s3,144(sp)
    80005d48:	ed52                	sd	s4,152(sp)
    80005d4a:	f156                	sd	s5,160(sp)
    80005d4c:	f55a                	sd	s6,168(sp)
    80005d4e:	f95e                	sd	s7,176(sp)
    80005d50:	fd62                	sd	s8,184(sp)
    80005d52:	e1e6                	sd	s9,192(sp)
    80005d54:	e5ea                	sd	s10,200(sp)
    80005d56:	e9ee                	sd	s11,208(sp)
    80005d58:	edf2                	sd	t3,216(sp)
    80005d5a:	f1f6                	sd	t4,224(sp)
    80005d5c:	f5fa                	sd	t5,232(sp)
    80005d5e:	f9fe                	sd	t6,240(sp)
    80005d60:	c71fc0ef          	jal	800029d0 <kerneltrap>
    80005d64:	6082                	ld	ra,0(sp)
    80005d66:	6122                	ld	sp,8(sp)
    80005d68:	61c2                	ld	gp,16(sp)
    80005d6a:	7282                	ld	t0,32(sp)
    80005d6c:	7322                	ld	t1,40(sp)
    80005d6e:	73c2                	ld	t2,48(sp)
    80005d70:	7462                	ld	s0,56(sp)
    80005d72:	6486                	ld	s1,64(sp)
    80005d74:	6526                	ld	a0,72(sp)
    80005d76:	65c6                	ld	a1,80(sp)
    80005d78:	6666                	ld	a2,88(sp)
    80005d7a:	7686                	ld	a3,96(sp)
    80005d7c:	7726                	ld	a4,104(sp)
    80005d7e:	77c6                	ld	a5,112(sp)
    80005d80:	7866                	ld	a6,120(sp)
    80005d82:	688a                	ld	a7,128(sp)
    80005d84:	692a                	ld	s2,136(sp)
    80005d86:	69ca                	ld	s3,144(sp)
    80005d88:	6a6a                	ld	s4,152(sp)
    80005d8a:	7a8a                	ld	s5,160(sp)
    80005d8c:	7b2a                	ld	s6,168(sp)
    80005d8e:	7bca                	ld	s7,176(sp)
    80005d90:	7c6a                	ld	s8,184(sp)
    80005d92:	6c8e                	ld	s9,192(sp)
    80005d94:	6d2e                	ld	s10,200(sp)
    80005d96:	6dce                	ld	s11,208(sp)
    80005d98:	6e6e                	ld	t3,216(sp)
    80005d9a:	7e8e                	ld	t4,224(sp)
    80005d9c:	7f2e                	ld	t5,232(sp)
    80005d9e:	7fce                	ld	t6,240(sp)
    80005da0:	6111                	addi	sp,sp,256
    80005da2:	10200073          	sret
    80005da6:	00000013          	nop
    80005daa:	00000013          	nop
    80005dae:	0001                	nop

0000000080005db0 <timervec>:
    80005db0:	34051573          	csrrw	a0,mscratch,a0
    80005db4:	e10c                	sd	a1,0(a0)
    80005db6:	e510                	sd	a2,8(a0)
    80005db8:	e914                	sd	a3,16(a0)
    80005dba:	6d0c                	ld	a1,24(a0)
    80005dbc:	7110                	ld	a2,32(a0)
    80005dbe:	6194                	ld	a3,0(a1)
    80005dc0:	96b2                	add	a3,a3,a2
    80005dc2:	e194                	sd	a3,0(a1)
    80005dc4:	4589                	li	a1,2
    80005dc6:	14459073          	csrw	sip,a1
    80005dca:	6914                	ld	a3,16(a0)
    80005dcc:	6510                	ld	a2,8(a0)
    80005dce:	610c                	ld	a1,0(a0)
    80005dd0:	34051573          	csrrw	a0,mscratch,a0
    80005dd4:	30200073          	mret
	...

0000000080005dda <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005dda:	1141                	addi	sp,sp,-16
    80005ddc:	e422                	sd	s0,8(sp)
    80005dde:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005de0:	0c0007b7          	lui	a5,0xc000
    80005de4:	4705                	li	a4,1
    80005de6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005de8:	0c0007b7          	lui	a5,0xc000
    80005dec:	c3d8                	sw	a4,4(a5)
}
    80005dee:	6422                	ld	s0,8(sp)
    80005df0:	0141                	addi	sp,sp,16
    80005df2:	8082                	ret

0000000080005df4 <plicinithart>:

void
plicinithart(void)
{
    80005df4:	1141                	addi	sp,sp,-16
    80005df6:	e406                	sd	ra,8(sp)
    80005df8:	e022                	sd	s0,0(sp)
    80005dfa:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005dfc:	ffffc097          	auipc	ra,0xffffc
    80005e00:	c3a080e7          	jalr	-966(ra) # 80001a36 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005e04:	0085171b          	slliw	a4,a0,0x8
    80005e08:	0c0027b7          	lui	a5,0xc002
    80005e0c:	97ba                	add	a5,a5,a4
    80005e0e:	40200713          	li	a4,1026
    80005e12:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005e16:	00d5151b          	slliw	a0,a0,0xd
    80005e1a:	0c2017b7          	lui	a5,0xc201
    80005e1e:	97aa                	add	a5,a5,a0
    80005e20:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005e24:	60a2                	ld	ra,8(sp)
    80005e26:	6402                	ld	s0,0(sp)
    80005e28:	0141                	addi	sp,sp,16
    80005e2a:	8082                	ret

0000000080005e2c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005e2c:	1141                	addi	sp,sp,-16
    80005e2e:	e406                	sd	ra,8(sp)
    80005e30:	e022                	sd	s0,0(sp)
    80005e32:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005e34:	ffffc097          	auipc	ra,0xffffc
    80005e38:	c02080e7          	jalr	-1022(ra) # 80001a36 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005e3c:	00d5151b          	slliw	a0,a0,0xd
    80005e40:	0c2017b7          	lui	a5,0xc201
    80005e44:	97aa                	add	a5,a5,a0
  return irq;
}
    80005e46:	43c8                	lw	a0,4(a5)
    80005e48:	60a2                	ld	ra,8(sp)
    80005e4a:	6402                	ld	s0,0(sp)
    80005e4c:	0141                	addi	sp,sp,16
    80005e4e:	8082                	ret

0000000080005e50 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005e50:	1101                	addi	sp,sp,-32
    80005e52:	ec06                	sd	ra,24(sp)
    80005e54:	e822                	sd	s0,16(sp)
    80005e56:	e426                	sd	s1,8(sp)
    80005e58:	1000                	addi	s0,sp,32
    80005e5a:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005e5c:	ffffc097          	auipc	ra,0xffffc
    80005e60:	bda080e7          	jalr	-1062(ra) # 80001a36 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005e64:	00d5151b          	slliw	a0,a0,0xd
    80005e68:	0c2017b7          	lui	a5,0xc201
    80005e6c:	97aa                	add	a5,a5,a0
    80005e6e:	c3c4                	sw	s1,4(a5)
}
    80005e70:	60e2                	ld	ra,24(sp)
    80005e72:	6442                	ld	s0,16(sp)
    80005e74:	64a2                	ld	s1,8(sp)
    80005e76:	6105                	addi	sp,sp,32
    80005e78:	8082                	ret

0000000080005e7a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005e7a:	1141                	addi	sp,sp,-16
    80005e7c:	e406                	sd	ra,8(sp)
    80005e7e:	e022                	sd	s0,0(sp)
    80005e80:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005e82:	479d                	li	a5,7
    80005e84:	04a7cc63          	blt	a5,a0,80005edc <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005e88:	0001e797          	auipc	a5,0x1e
    80005e8c:	71878793          	addi	a5,a5,1816 # 800245a0 <disk>
    80005e90:	97aa                	add	a5,a5,a0
    80005e92:	0187c783          	lbu	a5,24(a5)
    80005e96:	ebb9                	bnez	a5,80005eec <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005e98:	00451693          	slli	a3,a0,0x4
    80005e9c:	0001e797          	auipc	a5,0x1e
    80005ea0:	70478793          	addi	a5,a5,1796 # 800245a0 <disk>
    80005ea4:	6398                	ld	a4,0(a5)
    80005ea6:	9736                	add	a4,a4,a3
    80005ea8:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005eac:	6398                	ld	a4,0(a5)
    80005eae:	9736                	add	a4,a4,a3
    80005eb0:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005eb4:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005eb8:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005ebc:	97aa                	add	a5,a5,a0
    80005ebe:	4705                	li	a4,1
    80005ec0:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005ec4:	0001e517          	auipc	a0,0x1e
    80005ec8:	6f450513          	addi	a0,a0,1780 # 800245b8 <disk+0x18>
    80005ecc:	ffffc097          	auipc	ra,0xffffc
    80005ed0:	2c4080e7          	jalr	708(ra) # 80002190 <wakeup>
}
    80005ed4:	60a2                	ld	ra,8(sp)
    80005ed6:	6402                	ld	s0,0(sp)
    80005ed8:	0141                	addi	sp,sp,16
    80005eda:	8082                	ret
    panic("free_desc 1");
    80005edc:	00002517          	auipc	a0,0x2
    80005ee0:	75c50513          	addi	a0,a0,1884 # 80008638 <etext+0x638>
    80005ee4:	ffffa097          	auipc	ra,0xffffa
    80005ee8:	67c080e7          	jalr	1660(ra) # 80000560 <panic>
    panic("free_desc 2");
    80005eec:	00002517          	auipc	a0,0x2
    80005ef0:	75c50513          	addi	a0,a0,1884 # 80008648 <etext+0x648>
    80005ef4:	ffffa097          	auipc	ra,0xffffa
    80005ef8:	66c080e7          	jalr	1644(ra) # 80000560 <panic>

0000000080005efc <virtio_disk_init>:
{
    80005efc:	1101                	addi	sp,sp,-32
    80005efe:	ec06                	sd	ra,24(sp)
    80005f00:	e822                	sd	s0,16(sp)
    80005f02:	e426                	sd	s1,8(sp)
    80005f04:	e04a                	sd	s2,0(sp)
    80005f06:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005f08:	00002597          	auipc	a1,0x2
    80005f0c:	75058593          	addi	a1,a1,1872 # 80008658 <etext+0x658>
    80005f10:	0001e517          	auipc	a0,0x1e
    80005f14:	7b850513          	addi	a0,a0,1976 # 800246c8 <disk+0x128>
    80005f18:	ffffb097          	auipc	ra,0xffffb
    80005f1c:	ca8080e7          	jalr	-856(ra) # 80000bc0 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005f20:	100017b7          	lui	a5,0x10001
    80005f24:	4398                	lw	a4,0(a5)
    80005f26:	2701                	sext.w	a4,a4
    80005f28:	747277b7          	lui	a5,0x74727
    80005f2c:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005f30:	18f71c63          	bne	a4,a5,800060c8 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005f34:	100017b7          	lui	a5,0x10001
    80005f38:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80005f3a:	439c                	lw	a5,0(a5)
    80005f3c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005f3e:	4709                	li	a4,2
    80005f40:	18e79463          	bne	a5,a4,800060c8 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005f44:	100017b7          	lui	a5,0x10001
    80005f48:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80005f4a:	439c                	lw	a5,0(a5)
    80005f4c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005f4e:	16e79d63          	bne	a5,a4,800060c8 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005f52:	100017b7          	lui	a5,0x10001
    80005f56:	47d8                	lw	a4,12(a5)
    80005f58:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005f5a:	554d47b7          	lui	a5,0x554d4
    80005f5e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005f62:	16f71363          	bne	a4,a5,800060c8 <virtio_disk_init+0x1cc>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f66:	100017b7          	lui	a5,0x10001
    80005f6a:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f6e:	4705                	li	a4,1
    80005f70:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f72:	470d                	li	a4,3
    80005f74:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005f76:	10001737          	lui	a4,0x10001
    80005f7a:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005f7c:	c7ffe737          	lui	a4,0xc7ffe
    80005f80:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fda07f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005f84:	8ef9                	and	a3,a3,a4
    80005f86:	10001737          	lui	a4,0x10001
    80005f8a:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f8c:	472d                	li	a4,11
    80005f8e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f90:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80005f94:	439c                	lw	a5,0(a5)
    80005f96:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005f9a:	8ba1                	andi	a5,a5,8
    80005f9c:	12078e63          	beqz	a5,800060d8 <virtio_disk_init+0x1dc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005fa0:	100017b7          	lui	a5,0x10001
    80005fa4:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005fa8:	100017b7          	lui	a5,0x10001
    80005fac:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80005fb0:	439c                	lw	a5,0(a5)
    80005fb2:	2781                	sext.w	a5,a5
    80005fb4:	12079a63          	bnez	a5,800060e8 <virtio_disk_init+0x1ec>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005fb8:	100017b7          	lui	a5,0x10001
    80005fbc:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005fc0:	439c                	lw	a5,0(a5)
    80005fc2:	2781                	sext.w	a5,a5
  if(max == 0)
    80005fc4:	12078a63          	beqz	a5,800060f8 <virtio_disk_init+0x1fc>
  if(max < NUM)
    80005fc8:	471d                	li	a4,7
    80005fca:	12f77f63          	bgeu	a4,a5,80006108 <virtio_disk_init+0x20c>
  disk.desc = kalloc();
    80005fce:	ffffb097          	auipc	ra,0xffffb
    80005fd2:	b92080e7          	jalr	-1134(ra) # 80000b60 <kalloc>
    80005fd6:	0001e497          	auipc	s1,0x1e
    80005fda:	5ca48493          	addi	s1,s1,1482 # 800245a0 <disk>
    80005fde:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005fe0:	ffffb097          	auipc	ra,0xffffb
    80005fe4:	b80080e7          	jalr	-1152(ra) # 80000b60 <kalloc>
    80005fe8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80005fea:	ffffb097          	auipc	ra,0xffffb
    80005fee:	b76080e7          	jalr	-1162(ra) # 80000b60 <kalloc>
    80005ff2:	87aa                	mv	a5,a0
    80005ff4:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005ff6:	6088                	ld	a0,0(s1)
    80005ff8:	12050063          	beqz	a0,80006118 <virtio_disk_init+0x21c>
    80005ffc:	0001e717          	auipc	a4,0x1e
    80006000:	5ac73703          	ld	a4,1452(a4) # 800245a8 <disk+0x8>
    80006004:	10070a63          	beqz	a4,80006118 <virtio_disk_init+0x21c>
    80006008:	10078863          	beqz	a5,80006118 <virtio_disk_init+0x21c>
  memset(disk.desc, 0, PGSIZE);
    8000600c:	6605                	lui	a2,0x1
    8000600e:	4581                	li	a1,0
    80006010:	ffffb097          	auipc	ra,0xffffb
    80006014:	d3c080e7          	jalr	-708(ra) # 80000d4c <memset>
  memset(disk.avail, 0, PGSIZE);
    80006018:	0001e497          	auipc	s1,0x1e
    8000601c:	58848493          	addi	s1,s1,1416 # 800245a0 <disk>
    80006020:	6605                	lui	a2,0x1
    80006022:	4581                	li	a1,0
    80006024:	6488                	ld	a0,8(s1)
    80006026:	ffffb097          	auipc	ra,0xffffb
    8000602a:	d26080e7          	jalr	-730(ra) # 80000d4c <memset>
  memset(disk.used, 0, PGSIZE);
    8000602e:	6605                	lui	a2,0x1
    80006030:	4581                	li	a1,0
    80006032:	6888                	ld	a0,16(s1)
    80006034:	ffffb097          	auipc	ra,0xffffb
    80006038:	d18080e7          	jalr	-744(ra) # 80000d4c <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000603c:	100017b7          	lui	a5,0x10001
    80006040:	4721                	li	a4,8
    80006042:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006044:	4098                	lw	a4,0(s1)
    80006046:	100017b7          	lui	a5,0x10001
    8000604a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000604e:	40d8                	lw	a4,4(s1)
    80006050:	100017b7          	lui	a5,0x10001
    80006054:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80006058:	649c                	ld	a5,8(s1)
    8000605a:	0007869b          	sext.w	a3,a5
    8000605e:	10001737          	lui	a4,0x10001
    80006062:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80006066:	9781                	srai	a5,a5,0x20
    80006068:	10001737          	lui	a4,0x10001
    8000606c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80006070:	689c                	ld	a5,16(s1)
    80006072:	0007869b          	sext.w	a3,a5
    80006076:	10001737          	lui	a4,0x10001
    8000607a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000607e:	9781                	srai	a5,a5,0x20
    80006080:	10001737          	lui	a4,0x10001
    80006084:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80006088:	10001737          	lui	a4,0x10001
    8000608c:	4785                	li	a5,1
    8000608e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80006090:	00f48c23          	sb	a5,24(s1)
    80006094:	00f48ca3          	sb	a5,25(s1)
    80006098:	00f48d23          	sb	a5,26(s1)
    8000609c:	00f48da3          	sb	a5,27(s1)
    800060a0:	00f48e23          	sb	a5,28(s1)
    800060a4:	00f48ea3          	sb	a5,29(s1)
    800060a8:	00f48f23          	sb	a5,30(s1)
    800060ac:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800060b0:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800060b4:	100017b7          	lui	a5,0x10001
    800060b8:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    800060bc:	60e2                	ld	ra,24(sp)
    800060be:	6442                	ld	s0,16(sp)
    800060c0:	64a2                	ld	s1,8(sp)
    800060c2:	6902                	ld	s2,0(sp)
    800060c4:	6105                	addi	sp,sp,32
    800060c6:	8082                	ret
    panic("could not find virtio disk");
    800060c8:	00002517          	auipc	a0,0x2
    800060cc:	5a050513          	addi	a0,a0,1440 # 80008668 <etext+0x668>
    800060d0:	ffffa097          	auipc	ra,0xffffa
    800060d4:	490080e7          	jalr	1168(ra) # 80000560 <panic>
    panic("virtio disk FEATURES_OK unset");
    800060d8:	00002517          	auipc	a0,0x2
    800060dc:	5b050513          	addi	a0,a0,1456 # 80008688 <etext+0x688>
    800060e0:	ffffa097          	auipc	ra,0xffffa
    800060e4:	480080e7          	jalr	1152(ra) # 80000560 <panic>
    panic("virtio disk should not be ready");
    800060e8:	00002517          	auipc	a0,0x2
    800060ec:	5c050513          	addi	a0,a0,1472 # 800086a8 <etext+0x6a8>
    800060f0:	ffffa097          	auipc	ra,0xffffa
    800060f4:	470080e7          	jalr	1136(ra) # 80000560 <panic>
    panic("virtio disk has no queue 0");
    800060f8:	00002517          	auipc	a0,0x2
    800060fc:	5d050513          	addi	a0,a0,1488 # 800086c8 <etext+0x6c8>
    80006100:	ffffa097          	auipc	ra,0xffffa
    80006104:	460080e7          	jalr	1120(ra) # 80000560 <panic>
    panic("virtio disk max queue too short");
    80006108:	00002517          	auipc	a0,0x2
    8000610c:	5e050513          	addi	a0,a0,1504 # 800086e8 <etext+0x6e8>
    80006110:	ffffa097          	auipc	ra,0xffffa
    80006114:	450080e7          	jalr	1104(ra) # 80000560 <panic>
    panic("virtio disk kalloc");
    80006118:	00002517          	auipc	a0,0x2
    8000611c:	5f050513          	addi	a0,a0,1520 # 80008708 <etext+0x708>
    80006120:	ffffa097          	auipc	ra,0xffffa
    80006124:	440080e7          	jalr	1088(ra) # 80000560 <panic>

0000000080006128 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006128:	7159                	addi	sp,sp,-112
    8000612a:	f486                	sd	ra,104(sp)
    8000612c:	f0a2                	sd	s0,96(sp)
    8000612e:	eca6                	sd	s1,88(sp)
    80006130:	e8ca                	sd	s2,80(sp)
    80006132:	e4ce                	sd	s3,72(sp)
    80006134:	e0d2                	sd	s4,64(sp)
    80006136:	fc56                	sd	s5,56(sp)
    80006138:	f85a                	sd	s6,48(sp)
    8000613a:	f45e                	sd	s7,40(sp)
    8000613c:	f062                	sd	s8,32(sp)
    8000613e:	ec66                	sd	s9,24(sp)
    80006140:	1880                	addi	s0,sp,112
    80006142:	8a2a                	mv	s4,a0
    80006144:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006146:	00c52c83          	lw	s9,12(a0)
    8000614a:	001c9c9b          	slliw	s9,s9,0x1
    8000614e:	1c82                	slli	s9,s9,0x20
    80006150:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80006154:	0001e517          	auipc	a0,0x1e
    80006158:	57450513          	addi	a0,a0,1396 # 800246c8 <disk+0x128>
    8000615c:	ffffb097          	auipc	ra,0xffffb
    80006160:	af4080e7          	jalr	-1292(ra) # 80000c50 <acquire>
  for(int i = 0; i < 3; i++){
    80006164:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80006166:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006168:	0001eb17          	auipc	s6,0x1e
    8000616c:	438b0b13          	addi	s6,s6,1080 # 800245a0 <disk>
  for(int i = 0; i < 3; i++){
    80006170:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006172:	0001ec17          	auipc	s8,0x1e
    80006176:	556c0c13          	addi	s8,s8,1366 # 800246c8 <disk+0x128>
    8000617a:	a0ad                	j	800061e4 <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    8000617c:	00fb0733          	add	a4,s6,a5
    80006180:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80006184:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006186:	0207c563          	bltz	a5,800061b0 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    8000618a:	2905                	addiw	s2,s2,1
    8000618c:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    8000618e:	05590f63          	beq	s2,s5,800061ec <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    80006192:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006194:	0001e717          	auipc	a4,0x1e
    80006198:	40c70713          	addi	a4,a4,1036 # 800245a0 <disk>
    8000619c:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000619e:	01874683          	lbu	a3,24(a4)
    800061a2:	fee9                	bnez	a3,8000617c <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    800061a4:	2785                	addiw	a5,a5,1
    800061a6:	0705                	addi	a4,a4,1
    800061a8:	fe979be3          	bne	a5,s1,8000619e <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800061ac:	57fd                	li	a5,-1
    800061ae:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800061b0:	03205163          	blez	s2,800061d2 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    800061b4:	f9042503          	lw	a0,-112(s0)
    800061b8:	00000097          	auipc	ra,0x0
    800061bc:	cc2080e7          	jalr	-830(ra) # 80005e7a <free_desc>
      for(int j = 0; j < i; j++)
    800061c0:	4785                	li	a5,1
    800061c2:	0127d863          	bge	a5,s2,800061d2 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    800061c6:	f9442503          	lw	a0,-108(s0)
    800061ca:	00000097          	auipc	ra,0x0
    800061ce:	cb0080e7          	jalr	-848(ra) # 80005e7a <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800061d2:	85e2                	mv	a1,s8
    800061d4:	0001e517          	auipc	a0,0x1e
    800061d8:	3e450513          	addi	a0,a0,996 # 800245b8 <disk+0x18>
    800061dc:	ffffc097          	auipc	ra,0xffffc
    800061e0:	f50080e7          	jalr	-176(ra) # 8000212c <sleep>
  for(int i = 0; i < 3; i++){
    800061e4:	f9040613          	addi	a2,s0,-112
    800061e8:	894e                	mv	s2,s3
    800061ea:	b765                	j	80006192 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800061ec:	f9042503          	lw	a0,-112(s0)
    800061f0:	00451693          	slli	a3,a0,0x4

  if(write)
    800061f4:	0001e797          	auipc	a5,0x1e
    800061f8:	3ac78793          	addi	a5,a5,940 # 800245a0 <disk>
    800061fc:	00a50713          	addi	a4,a0,10
    80006200:	0712                	slli	a4,a4,0x4
    80006202:	973e                	add	a4,a4,a5
    80006204:	01703633          	snez	a2,s7
    80006208:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000620a:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    8000620e:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006212:	6398                	ld	a4,0(a5)
    80006214:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006216:	0a868613          	addi	a2,a3,168
    8000621a:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000621c:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000621e:	6390                	ld	a2,0(a5)
    80006220:	00d605b3          	add	a1,a2,a3
    80006224:	4741                	li	a4,16
    80006226:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006228:	4805                	li	a6,1
    8000622a:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    8000622e:	f9442703          	lw	a4,-108(s0)
    80006232:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006236:	0712                	slli	a4,a4,0x4
    80006238:	963a                	add	a2,a2,a4
    8000623a:	058a0593          	addi	a1,s4,88
    8000623e:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80006240:	0007b883          	ld	a7,0(a5)
    80006244:	9746                	add	a4,a4,a7
    80006246:	40000613          	li	a2,1024
    8000624a:	c710                	sw	a2,8(a4)
  if(write)
    8000624c:	001bb613          	seqz	a2,s7
    80006250:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006254:	00166613          	ori	a2,a2,1
    80006258:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    8000625c:	f9842583          	lw	a1,-104(s0)
    80006260:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006264:	00250613          	addi	a2,a0,2
    80006268:	0612                	slli	a2,a2,0x4
    8000626a:	963e                	add	a2,a2,a5
    8000626c:	577d                	li	a4,-1
    8000626e:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006272:	0592                	slli	a1,a1,0x4
    80006274:	98ae                	add	a7,a7,a1
    80006276:	03068713          	addi	a4,a3,48
    8000627a:	973e                	add	a4,a4,a5
    8000627c:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80006280:	6398                	ld	a4,0(a5)
    80006282:	972e                	add	a4,a4,a1
    80006284:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006288:	4689                	li	a3,2
    8000628a:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    8000628e:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006292:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80006296:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000629a:	6794                	ld	a3,8(a5)
    8000629c:	0026d703          	lhu	a4,2(a3)
    800062a0:	8b1d                	andi	a4,a4,7
    800062a2:	0706                	slli	a4,a4,0x1
    800062a4:	96ba                	add	a3,a3,a4
    800062a6:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800062aa:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800062ae:	6798                	ld	a4,8(a5)
    800062b0:	00275783          	lhu	a5,2(a4)
    800062b4:	2785                	addiw	a5,a5,1
    800062b6:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800062ba:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800062be:	100017b7          	lui	a5,0x10001
    800062c2:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800062c6:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    800062ca:	0001e917          	auipc	s2,0x1e
    800062ce:	3fe90913          	addi	s2,s2,1022 # 800246c8 <disk+0x128>
  while(b->disk == 1) {
    800062d2:	4485                	li	s1,1
    800062d4:	01079c63          	bne	a5,a6,800062ec <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800062d8:	85ca                	mv	a1,s2
    800062da:	8552                	mv	a0,s4
    800062dc:	ffffc097          	auipc	ra,0xffffc
    800062e0:	e50080e7          	jalr	-432(ra) # 8000212c <sleep>
  while(b->disk == 1) {
    800062e4:	004a2783          	lw	a5,4(s4)
    800062e8:	fe9788e3          	beq	a5,s1,800062d8 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800062ec:	f9042903          	lw	s2,-112(s0)
    800062f0:	00290713          	addi	a4,s2,2
    800062f4:	0712                	slli	a4,a4,0x4
    800062f6:	0001e797          	auipc	a5,0x1e
    800062fa:	2aa78793          	addi	a5,a5,682 # 800245a0 <disk>
    800062fe:	97ba                	add	a5,a5,a4
    80006300:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006304:	0001e997          	auipc	s3,0x1e
    80006308:	29c98993          	addi	s3,s3,668 # 800245a0 <disk>
    8000630c:	00491713          	slli	a4,s2,0x4
    80006310:	0009b783          	ld	a5,0(s3)
    80006314:	97ba                	add	a5,a5,a4
    80006316:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000631a:	854a                	mv	a0,s2
    8000631c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006320:	00000097          	auipc	ra,0x0
    80006324:	b5a080e7          	jalr	-1190(ra) # 80005e7a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006328:	8885                	andi	s1,s1,1
    8000632a:	f0ed                	bnez	s1,8000630c <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000632c:	0001e517          	auipc	a0,0x1e
    80006330:	39c50513          	addi	a0,a0,924 # 800246c8 <disk+0x128>
    80006334:	ffffb097          	auipc	ra,0xffffb
    80006338:	9d0080e7          	jalr	-1584(ra) # 80000d04 <release>
}
    8000633c:	70a6                	ld	ra,104(sp)
    8000633e:	7406                	ld	s0,96(sp)
    80006340:	64e6                	ld	s1,88(sp)
    80006342:	6946                	ld	s2,80(sp)
    80006344:	69a6                	ld	s3,72(sp)
    80006346:	6a06                	ld	s4,64(sp)
    80006348:	7ae2                	ld	s5,56(sp)
    8000634a:	7b42                	ld	s6,48(sp)
    8000634c:	7ba2                	ld	s7,40(sp)
    8000634e:	7c02                	ld	s8,32(sp)
    80006350:	6ce2                	ld	s9,24(sp)
    80006352:	6165                	addi	sp,sp,112
    80006354:	8082                	ret

0000000080006356 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006356:	1101                	addi	sp,sp,-32
    80006358:	ec06                	sd	ra,24(sp)
    8000635a:	e822                	sd	s0,16(sp)
    8000635c:	e426                	sd	s1,8(sp)
    8000635e:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006360:	0001e497          	auipc	s1,0x1e
    80006364:	24048493          	addi	s1,s1,576 # 800245a0 <disk>
    80006368:	0001e517          	auipc	a0,0x1e
    8000636c:	36050513          	addi	a0,a0,864 # 800246c8 <disk+0x128>
    80006370:	ffffb097          	auipc	ra,0xffffb
    80006374:	8e0080e7          	jalr	-1824(ra) # 80000c50 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006378:	100017b7          	lui	a5,0x10001
    8000637c:	53b8                	lw	a4,96(a5)
    8000637e:	8b0d                	andi	a4,a4,3
    80006380:	100017b7          	lui	a5,0x10001
    80006384:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80006386:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8000638a:	689c                	ld	a5,16(s1)
    8000638c:	0204d703          	lhu	a4,32(s1)
    80006390:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80006394:	04f70863          	beq	a4,a5,800063e4 <virtio_disk_intr+0x8e>
    __sync_synchronize();
    80006398:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000639c:	6898                	ld	a4,16(s1)
    8000639e:	0204d783          	lhu	a5,32(s1)
    800063a2:	8b9d                	andi	a5,a5,7
    800063a4:	078e                	slli	a5,a5,0x3
    800063a6:	97ba                	add	a5,a5,a4
    800063a8:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800063aa:	00278713          	addi	a4,a5,2
    800063ae:	0712                	slli	a4,a4,0x4
    800063b0:	9726                	add	a4,a4,s1
    800063b2:	01074703          	lbu	a4,16(a4)
    800063b6:	e721                	bnez	a4,800063fe <virtio_disk_intr+0xa8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800063b8:	0789                	addi	a5,a5,2
    800063ba:	0792                	slli	a5,a5,0x4
    800063bc:	97a6                	add	a5,a5,s1
    800063be:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800063c0:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800063c4:	ffffc097          	auipc	ra,0xffffc
    800063c8:	dcc080e7          	jalr	-564(ra) # 80002190 <wakeup>

    disk.used_idx += 1;
    800063cc:	0204d783          	lhu	a5,32(s1)
    800063d0:	2785                	addiw	a5,a5,1
    800063d2:	17c2                	slli	a5,a5,0x30
    800063d4:	93c1                	srli	a5,a5,0x30
    800063d6:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800063da:	6898                	ld	a4,16(s1)
    800063dc:	00275703          	lhu	a4,2(a4)
    800063e0:	faf71ce3          	bne	a4,a5,80006398 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    800063e4:	0001e517          	auipc	a0,0x1e
    800063e8:	2e450513          	addi	a0,a0,740 # 800246c8 <disk+0x128>
    800063ec:	ffffb097          	auipc	ra,0xffffb
    800063f0:	918080e7          	jalr	-1768(ra) # 80000d04 <release>
}
    800063f4:	60e2                	ld	ra,24(sp)
    800063f6:	6442                	ld	s0,16(sp)
    800063f8:	64a2                	ld	s1,8(sp)
    800063fa:	6105                	addi	sp,sp,32
    800063fc:	8082                	ret
      panic("virtio_disk_intr status");
    800063fe:	00002517          	auipc	a0,0x2
    80006402:	32250513          	addi	a0,a0,802 # 80008720 <etext+0x720>
    80006406:	ffffa097          	auipc	ra,0xffffa
    8000640a:	15a080e7          	jalr	346(ra) # 80000560 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
