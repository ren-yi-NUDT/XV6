
user/tests/_va:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
   8:	00000597          	auipc	a1,0x0
   c:	ff858593          	addi	a1,a1,-8 # 0 <main>
  10:	00001517          	auipc	a0,0x1
  14:	9a050513          	addi	a0,a0,-1632 # 9b0 <malloc+0x144>
  18:	00000097          	auipc	ra,0x0
  1c:	666080e7          	jalr	1638(ra) # 67e <printf>
  20:	00001597          	auipc	a1,0x1
  24:	3a058593          	addi	a1,a1,928 # 13c0 <global>
  28:	00001517          	auipc	a0,0x1
  2c:	9a050513          	addi	a0,a0,-1632 # 9c8 <malloc+0x15c>
  30:	00000097          	auipc	ra,0x0
  34:	64e080e7          	jalr	1614(ra) # 67e <printf>
  38:	4505                	li	a0,1
  3a:	00001097          	auipc	ra,0x1
  3e:	832080e7          	jalr	-1998(ra) # 86c <malloc>
  42:	85aa                	mv	a1,a0
  44:	00001517          	auipc	a0,0x1
  48:	99c50513          	addi	a0,a0,-1636 # 9e0 <malloc+0x174>
  4c:	00000097          	auipc	ra,0x0
  50:	632080e7          	jalr	1586(ra) # 67e <printf>
  54:	478d                	li	a5,3
  56:	fef42623          	sw	a5,-20(s0)
  5a:	fec40593          	addi	a1,s0,-20
  5e:	00001517          	auipc	a0,0x1
  62:	99a50513          	addi	a0,a0,-1638 # 9f8 <malloc+0x18c>
  66:	00000097          	auipc	ra,0x0
  6a:	618080e7          	jalr	1560(ra) # 67e <printf>
  6e:	4501                	li	a0,0
  70:	60e2                	ld	ra,24(sp)
  72:	6442                	ld	s0,16(sp)
  74:	6105                	addi	sp,sp,32
  76:	8082                	ret

0000000000000078 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  78:	1141                	addi	sp,sp,-16
  7a:	e406                	sd	ra,8(sp)
  7c:	e022                	sd	s0,0(sp)
  7e:	0800                	addi	s0,sp,16
  extern int main();
  main();
  80:	00000097          	auipc	ra,0x0
  84:	f80080e7          	jalr	-128(ra) # 0 <main>
  exit(0);
  88:	4501                	li	a0,0
  8a:	00000097          	auipc	ra,0x0
  8e:	274080e7          	jalr	628(ra) # 2fe <exit>

0000000000000092 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  92:	1141                	addi	sp,sp,-16
  94:	e422                	sd	s0,8(sp)
  96:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  98:	87aa                	mv	a5,a0
  9a:	0585                	addi	a1,a1,1
  9c:	0785                	addi	a5,a5,1
  9e:	fff5c703          	lbu	a4,-1(a1)
  a2:	fee78fa3          	sb	a4,-1(a5)
  a6:	fb75                	bnez	a4,9a <strcpy+0x8>
    ;
  return os;
}
  a8:	6422                	ld	s0,8(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret

00000000000000ae <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e422                	sd	s0,8(sp)
  b2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  b4:	00054783          	lbu	a5,0(a0)
  b8:	cb91                	beqz	a5,cc <strcmp+0x1e>
  ba:	0005c703          	lbu	a4,0(a1)
  be:	00f71763          	bne	a4,a5,cc <strcmp+0x1e>
    p++, q++;
  c2:	0505                	addi	a0,a0,1
  c4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  c6:	00054783          	lbu	a5,0(a0)
  ca:	fbe5                	bnez	a5,ba <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  cc:	0005c503          	lbu	a0,0(a1)
}
  d0:	40a7853b          	subw	a0,a5,a0
  d4:	6422                	ld	s0,8(sp)
  d6:	0141                	addi	sp,sp,16
  d8:	8082                	ret

00000000000000da <strlen>:

uint
strlen(const char *s)
{
  da:	1141                	addi	sp,sp,-16
  dc:	e422                	sd	s0,8(sp)
  de:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  e0:	00054783          	lbu	a5,0(a0)
  e4:	cf91                	beqz	a5,100 <strlen+0x26>
  e6:	0505                	addi	a0,a0,1
  e8:	87aa                	mv	a5,a0
  ea:	86be                	mv	a3,a5
  ec:	0785                	addi	a5,a5,1
  ee:	fff7c703          	lbu	a4,-1(a5)
  f2:	ff65                	bnez	a4,ea <strlen+0x10>
  f4:	40a6853b          	subw	a0,a3,a0
  f8:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  fa:	6422                	ld	s0,8(sp)
  fc:	0141                	addi	sp,sp,16
  fe:	8082                	ret
  for(n = 0; s[n]; n++)
 100:	4501                	li	a0,0
 102:	bfe5                	j	fa <strlen+0x20>

0000000000000104 <memset>:

void*
memset(void *dst, int c, uint n)
{
 104:	1141                	addi	sp,sp,-16
 106:	e422                	sd	s0,8(sp)
 108:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 10a:	ca19                	beqz	a2,120 <memset+0x1c>
 10c:	87aa                	mv	a5,a0
 10e:	1602                	slli	a2,a2,0x20
 110:	9201                	srli	a2,a2,0x20
 112:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 116:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 11a:	0785                	addi	a5,a5,1
 11c:	fee79de3          	bne	a5,a4,116 <memset+0x12>
  }
  return dst;
}
 120:	6422                	ld	s0,8(sp)
 122:	0141                	addi	sp,sp,16
 124:	8082                	ret

0000000000000126 <strchr>:

char*
strchr(const char *s, char c)
{
 126:	1141                	addi	sp,sp,-16
 128:	e422                	sd	s0,8(sp)
 12a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 12c:	00054783          	lbu	a5,0(a0)
 130:	cb99                	beqz	a5,146 <strchr+0x20>
    if(*s == c)
 132:	00f58763          	beq	a1,a5,140 <strchr+0x1a>
  for(; *s; s++)
 136:	0505                	addi	a0,a0,1
 138:	00054783          	lbu	a5,0(a0)
 13c:	fbfd                	bnez	a5,132 <strchr+0xc>
      return (char*)s;
  return 0;
 13e:	4501                	li	a0,0
}
 140:	6422                	ld	s0,8(sp)
 142:	0141                	addi	sp,sp,16
 144:	8082                	ret
  return 0;
 146:	4501                	li	a0,0
 148:	bfe5                	j	140 <strchr+0x1a>

000000000000014a <gets>:

char*
gets(char *buf, int max)
{
 14a:	711d                	addi	sp,sp,-96
 14c:	ec86                	sd	ra,88(sp)
 14e:	e8a2                	sd	s0,80(sp)
 150:	e4a6                	sd	s1,72(sp)
 152:	e0ca                	sd	s2,64(sp)
 154:	fc4e                	sd	s3,56(sp)
 156:	f852                	sd	s4,48(sp)
 158:	f456                	sd	s5,40(sp)
 15a:	f05a                	sd	s6,32(sp)
 15c:	ec5e                	sd	s7,24(sp)
 15e:	1080                	addi	s0,sp,96
 160:	8baa                	mv	s7,a0
 162:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 164:	892a                	mv	s2,a0
 166:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 168:	4aa9                	li	s5,10
 16a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 16c:	89a6                	mv	s3,s1
 16e:	2485                	addiw	s1,s1,1
 170:	0344d863          	bge	s1,s4,1a0 <gets+0x56>
    cc = read(0, &c, 1);
 174:	4605                	li	a2,1
 176:	faf40593          	addi	a1,s0,-81
 17a:	4501                	li	a0,0
 17c:	00000097          	auipc	ra,0x0
 180:	19a080e7          	jalr	410(ra) # 316 <read>
    if(cc < 1)
 184:	00a05e63          	blez	a0,1a0 <gets+0x56>
    buf[i++] = c;
 188:	faf44783          	lbu	a5,-81(s0)
 18c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 190:	01578763          	beq	a5,s5,19e <gets+0x54>
 194:	0905                	addi	s2,s2,1
 196:	fd679be3          	bne	a5,s6,16c <gets+0x22>
    buf[i++] = c;
 19a:	89a6                	mv	s3,s1
 19c:	a011                	j	1a0 <gets+0x56>
 19e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1a0:	99de                	add	s3,s3,s7
 1a2:	00098023          	sb	zero,0(s3)
  return buf;
}
 1a6:	855e                	mv	a0,s7
 1a8:	60e6                	ld	ra,88(sp)
 1aa:	6446                	ld	s0,80(sp)
 1ac:	64a6                	ld	s1,72(sp)
 1ae:	6906                	ld	s2,64(sp)
 1b0:	79e2                	ld	s3,56(sp)
 1b2:	7a42                	ld	s4,48(sp)
 1b4:	7aa2                	ld	s5,40(sp)
 1b6:	7b02                	ld	s6,32(sp)
 1b8:	6be2                	ld	s7,24(sp)
 1ba:	6125                	addi	sp,sp,96
 1bc:	8082                	ret

00000000000001be <stat>:

int
stat(const char *n, struct stat *st)
{
 1be:	1101                	addi	sp,sp,-32
 1c0:	ec06                	sd	ra,24(sp)
 1c2:	e822                	sd	s0,16(sp)
 1c4:	e04a                	sd	s2,0(sp)
 1c6:	1000                	addi	s0,sp,32
 1c8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ca:	4581                	li	a1,0
 1cc:	00000097          	auipc	ra,0x0
 1d0:	172080e7          	jalr	370(ra) # 33e <open>
  if(fd < 0)
 1d4:	02054663          	bltz	a0,200 <stat+0x42>
 1d8:	e426                	sd	s1,8(sp)
 1da:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1dc:	85ca                	mv	a1,s2
 1de:	00000097          	auipc	ra,0x0
 1e2:	178080e7          	jalr	376(ra) # 356 <fstat>
 1e6:	892a                	mv	s2,a0
  close(fd);
 1e8:	8526                	mv	a0,s1
 1ea:	00000097          	auipc	ra,0x0
 1ee:	13c080e7          	jalr	316(ra) # 326 <close>
  return r;
 1f2:	64a2                	ld	s1,8(sp)
}
 1f4:	854a                	mv	a0,s2
 1f6:	60e2                	ld	ra,24(sp)
 1f8:	6442                	ld	s0,16(sp)
 1fa:	6902                	ld	s2,0(sp)
 1fc:	6105                	addi	sp,sp,32
 1fe:	8082                	ret
    return -1;
 200:	597d                	li	s2,-1
 202:	bfcd                	j	1f4 <stat+0x36>

0000000000000204 <atoi>:

int
atoi(const char *s)
{
 204:	1141                	addi	sp,sp,-16
 206:	e422                	sd	s0,8(sp)
 208:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 20a:	00054683          	lbu	a3,0(a0)
 20e:	fd06879b          	addiw	a5,a3,-48
 212:	0ff7f793          	zext.b	a5,a5
 216:	4625                	li	a2,9
 218:	02f66863          	bltu	a2,a5,248 <atoi+0x44>
 21c:	872a                	mv	a4,a0
  n = 0;
 21e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 220:	0705                	addi	a4,a4,1
 222:	0025179b          	slliw	a5,a0,0x2
 226:	9fa9                	addw	a5,a5,a0
 228:	0017979b          	slliw	a5,a5,0x1
 22c:	9fb5                	addw	a5,a5,a3
 22e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 232:	00074683          	lbu	a3,0(a4)
 236:	fd06879b          	addiw	a5,a3,-48
 23a:	0ff7f793          	zext.b	a5,a5
 23e:	fef671e3          	bgeu	a2,a5,220 <atoi+0x1c>
  return n;
}
 242:	6422                	ld	s0,8(sp)
 244:	0141                	addi	sp,sp,16
 246:	8082                	ret
  n = 0;
 248:	4501                	li	a0,0
 24a:	bfe5                	j	242 <atoi+0x3e>

000000000000024c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 24c:	1141                	addi	sp,sp,-16
 24e:	e422                	sd	s0,8(sp)
 250:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 252:	02b57463          	bgeu	a0,a1,27a <memmove+0x2e>
    while(n-- > 0)
 256:	00c05f63          	blez	a2,274 <memmove+0x28>
 25a:	1602                	slli	a2,a2,0x20
 25c:	9201                	srli	a2,a2,0x20
 25e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 262:	872a                	mv	a4,a0
      *dst++ = *src++;
 264:	0585                	addi	a1,a1,1
 266:	0705                	addi	a4,a4,1
 268:	fff5c683          	lbu	a3,-1(a1)
 26c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 270:	fef71ae3          	bne	a4,a5,264 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 274:	6422                	ld	s0,8(sp)
 276:	0141                	addi	sp,sp,16
 278:	8082                	ret
    dst += n;
 27a:	00c50733          	add	a4,a0,a2
    src += n;
 27e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 280:	fec05ae3          	blez	a2,274 <memmove+0x28>
 284:	fff6079b          	addiw	a5,a2,-1
 288:	1782                	slli	a5,a5,0x20
 28a:	9381                	srli	a5,a5,0x20
 28c:	fff7c793          	not	a5,a5
 290:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 292:	15fd                	addi	a1,a1,-1
 294:	177d                	addi	a4,a4,-1
 296:	0005c683          	lbu	a3,0(a1)
 29a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 29e:	fee79ae3          	bne	a5,a4,292 <memmove+0x46>
 2a2:	bfc9                	j	274 <memmove+0x28>

00000000000002a4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2a4:	1141                	addi	sp,sp,-16
 2a6:	e422                	sd	s0,8(sp)
 2a8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2aa:	ca05                	beqz	a2,2da <memcmp+0x36>
 2ac:	fff6069b          	addiw	a3,a2,-1
 2b0:	1682                	slli	a3,a3,0x20
 2b2:	9281                	srli	a3,a3,0x20
 2b4:	0685                	addi	a3,a3,1
 2b6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2b8:	00054783          	lbu	a5,0(a0)
 2bc:	0005c703          	lbu	a4,0(a1)
 2c0:	00e79863          	bne	a5,a4,2d0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2c4:	0505                	addi	a0,a0,1
    p2++;
 2c6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2c8:	fed518e3          	bne	a0,a3,2b8 <memcmp+0x14>
  }
  return 0;
 2cc:	4501                	li	a0,0
 2ce:	a019                	j	2d4 <memcmp+0x30>
      return *p1 - *p2;
 2d0:	40e7853b          	subw	a0,a5,a4
}
 2d4:	6422                	ld	s0,8(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret
  return 0;
 2da:	4501                	li	a0,0
 2dc:	bfe5                	j	2d4 <memcmp+0x30>

00000000000002de <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2de:	1141                	addi	sp,sp,-16
 2e0:	e406                	sd	ra,8(sp)
 2e2:	e022                	sd	s0,0(sp)
 2e4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2e6:	00000097          	auipc	ra,0x0
 2ea:	f66080e7          	jalr	-154(ra) # 24c <memmove>
}
 2ee:	60a2                	ld	ra,8(sp)
 2f0:	6402                	ld	s0,0(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret

00000000000002f6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2f6:	4885                	li	a7,1
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <exit>:
.global exit
exit:
 li a7, SYS_exit
 2fe:	4889                	li	a7,2
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <wait>:
.global wait
wait:
 li a7, SYS_wait
 306:	488d                	li	a7,3
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 30e:	4891                	li	a7,4
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <read>:
.global read
read:
 li a7, SYS_read
 316:	4895                	li	a7,5
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <write>:
.global write
write:
 li a7, SYS_write
 31e:	48c1                	li	a7,16
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <close>:
.global close
close:
 li a7, SYS_close
 326:	48d5                	li	a7,21
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <kill>:
.global kill
kill:
 li a7, SYS_kill
 32e:	4899                	li	a7,6
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <exec>:
.global exec
exec:
 li a7, SYS_exec
 336:	489d                	li	a7,7
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <open>:
.global open
open:
 li a7, SYS_open
 33e:	48bd                	li	a7,15
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 346:	48c5                	li	a7,17
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 34e:	48c9                	li	a7,18
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 356:	48a1                	li	a7,8
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <link>:
.global link
link:
 li a7, SYS_link
 35e:	48cd                	li	a7,19
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 366:	48d1                	li	a7,20
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 36e:	48a5                	li	a7,9
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <dup>:
.global dup
dup:
 li a7, SYS_dup
 376:	48a9                	li	a7,10
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 37e:	48ad                	li	a7,11
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 386:	48b1                	li	a7,12
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 38e:	48b5                	li	a7,13
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 396:	48b9                	li	a7,14
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <yield>:
.global yield
yield:
 li a7, SYS_yield
 39e:	48d9                	li	a7,22
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <lock>:
.global lock
lock:
 li a7, SYS_lock
 3a6:	48dd                	li	a7,23
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <unlock>:
.global unlock
unlock:
 li a7, SYS_unlock
 3ae:	48e1                	li	a7,24
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3b6:	1101                	addi	sp,sp,-32
 3b8:	ec06                	sd	ra,24(sp)
 3ba:	e822                	sd	s0,16(sp)
 3bc:	1000                	addi	s0,sp,32
 3be:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3c2:	4605                	li	a2,1
 3c4:	fef40593          	addi	a1,s0,-17
 3c8:	00000097          	auipc	ra,0x0
 3cc:	f56080e7          	jalr	-170(ra) # 31e <write>
}
 3d0:	60e2                	ld	ra,24(sp)
 3d2:	6442                	ld	s0,16(sp)
 3d4:	6105                	addi	sp,sp,32
 3d6:	8082                	ret

00000000000003d8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3d8:	7139                	addi	sp,sp,-64
 3da:	fc06                	sd	ra,56(sp)
 3dc:	f822                	sd	s0,48(sp)
 3de:	f426                	sd	s1,40(sp)
 3e0:	0080                	addi	s0,sp,64
 3e2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3e4:	c299                	beqz	a3,3ea <printint+0x12>
 3e6:	0805cb63          	bltz	a1,47c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3ea:	2581                	sext.w	a1,a1
  neg = 0;
 3ec:	4881                	li	a7,0
 3ee:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3f2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3f4:	2601                	sext.w	a2,a2
 3f6:	00000517          	auipc	a0,0x0
 3fa:	67a50513          	addi	a0,a0,1658 # a70 <digits>
 3fe:	883a                	mv	a6,a4
 400:	2705                	addiw	a4,a4,1
 402:	02c5f7bb          	remuw	a5,a1,a2
 406:	1782                	slli	a5,a5,0x20
 408:	9381                	srli	a5,a5,0x20
 40a:	97aa                	add	a5,a5,a0
 40c:	0007c783          	lbu	a5,0(a5)
 410:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 414:	0005879b          	sext.w	a5,a1
 418:	02c5d5bb          	divuw	a1,a1,a2
 41c:	0685                	addi	a3,a3,1
 41e:	fec7f0e3          	bgeu	a5,a2,3fe <printint+0x26>
  if(neg)
 422:	00088c63          	beqz	a7,43a <printint+0x62>
    buf[i++] = '-';
 426:	fd070793          	addi	a5,a4,-48
 42a:	00878733          	add	a4,a5,s0
 42e:	02d00793          	li	a5,45
 432:	fef70823          	sb	a5,-16(a4)
 436:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 43a:	02e05c63          	blez	a4,472 <printint+0x9a>
 43e:	f04a                	sd	s2,32(sp)
 440:	ec4e                	sd	s3,24(sp)
 442:	fc040793          	addi	a5,s0,-64
 446:	00e78933          	add	s2,a5,a4
 44a:	fff78993          	addi	s3,a5,-1
 44e:	99ba                	add	s3,s3,a4
 450:	377d                	addiw	a4,a4,-1
 452:	1702                	slli	a4,a4,0x20
 454:	9301                	srli	a4,a4,0x20
 456:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 45a:	fff94583          	lbu	a1,-1(s2)
 45e:	8526                	mv	a0,s1
 460:	00000097          	auipc	ra,0x0
 464:	f56080e7          	jalr	-170(ra) # 3b6 <putc>
  while(--i >= 0)
 468:	197d                	addi	s2,s2,-1
 46a:	ff3918e3          	bne	s2,s3,45a <printint+0x82>
 46e:	7902                	ld	s2,32(sp)
 470:	69e2                	ld	s3,24(sp)
}
 472:	70e2                	ld	ra,56(sp)
 474:	7442                	ld	s0,48(sp)
 476:	74a2                	ld	s1,40(sp)
 478:	6121                	addi	sp,sp,64
 47a:	8082                	ret
    x = -xx;
 47c:	40b005bb          	negw	a1,a1
    neg = 1;
 480:	4885                	li	a7,1
    x = -xx;
 482:	b7b5                	j	3ee <printint+0x16>

0000000000000484 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 484:	715d                	addi	sp,sp,-80
 486:	e486                	sd	ra,72(sp)
 488:	e0a2                	sd	s0,64(sp)
 48a:	f84a                	sd	s2,48(sp)
 48c:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 48e:	0005c903          	lbu	s2,0(a1)
 492:	1a090a63          	beqz	s2,646 <vprintf+0x1c2>
 496:	fc26                	sd	s1,56(sp)
 498:	f44e                	sd	s3,40(sp)
 49a:	f052                	sd	s4,32(sp)
 49c:	ec56                	sd	s5,24(sp)
 49e:	e85a                	sd	s6,16(sp)
 4a0:	e45e                	sd	s7,8(sp)
 4a2:	8aaa                	mv	s5,a0
 4a4:	8bb2                	mv	s7,a2
 4a6:	00158493          	addi	s1,a1,1
  state = 0;
 4aa:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4ac:	02500a13          	li	s4,37
 4b0:	4b55                	li	s6,21
 4b2:	a839                	j	4d0 <vprintf+0x4c>
        putc(fd, c);
 4b4:	85ca                	mv	a1,s2
 4b6:	8556                	mv	a0,s5
 4b8:	00000097          	auipc	ra,0x0
 4bc:	efe080e7          	jalr	-258(ra) # 3b6 <putc>
 4c0:	a019                	j	4c6 <vprintf+0x42>
    } else if(state == '%'){
 4c2:	01498d63          	beq	s3,s4,4dc <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 4c6:	0485                	addi	s1,s1,1
 4c8:	fff4c903          	lbu	s2,-1(s1)
 4cc:	16090763          	beqz	s2,63a <vprintf+0x1b6>
    if(state == 0){
 4d0:	fe0999e3          	bnez	s3,4c2 <vprintf+0x3e>
      if(c == '%'){
 4d4:	ff4910e3          	bne	s2,s4,4b4 <vprintf+0x30>
        state = '%';
 4d8:	89d2                	mv	s3,s4
 4da:	b7f5                	j	4c6 <vprintf+0x42>
      if(c == 'd'){
 4dc:	13490463          	beq	s2,s4,604 <vprintf+0x180>
 4e0:	f9d9079b          	addiw	a5,s2,-99
 4e4:	0ff7f793          	zext.b	a5,a5
 4e8:	12fb6763          	bltu	s6,a5,616 <vprintf+0x192>
 4ec:	f9d9079b          	addiw	a5,s2,-99
 4f0:	0ff7f713          	zext.b	a4,a5
 4f4:	12eb6163          	bltu	s6,a4,616 <vprintf+0x192>
 4f8:	00271793          	slli	a5,a4,0x2
 4fc:	00000717          	auipc	a4,0x0
 500:	51c70713          	addi	a4,a4,1308 # a18 <malloc+0x1ac>
 504:	97ba                	add	a5,a5,a4
 506:	439c                	lw	a5,0(a5)
 508:	97ba                	add	a5,a5,a4
 50a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 50c:	008b8913          	addi	s2,s7,8
 510:	4685                	li	a3,1
 512:	4629                	li	a2,10
 514:	000ba583          	lw	a1,0(s7)
 518:	8556                	mv	a0,s5
 51a:	00000097          	auipc	ra,0x0
 51e:	ebe080e7          	jalr	-322(ra) # 3d8 <printint>
 522:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 524:	4981                	li	s3,0
 526:	b745                	j	4c6 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 528:	008b8913          	addi	s2,s7,8
 52c:	4681                	li	a3,0
 52e:	4629                	li	a2,10
 530:	000ba583          	lw	a1,0(s7)
 534:	8556                	mv	a0,s5
 536:	00000097          	auipc	ra,0x0
 53a:	ea2080e7          	jalr	-350(ra) # 3d8 <printint>
 53e:	8bca                	mv	s7,s2
      state = 0;
 540:	4981                	li	s3,0
 542:	b751                	j	4c6 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 544:	008b8913          	addi	s2,s7,8
 548:	4681                	li	a3,0
 54a:	4641                	li	a2,16
 54c:	000ba583          	lw	a1,0(s7)
 550:	8556                	mv	a0,s5
 552:	00000097          	auipc	ra,0x0
 556:	e86080e7          	jalr	-378(ra) # 3d8 <printint>
 55a:	8bca                	mv	s7,s2
      state = 0;
 55c:	4981                	li	s3,0
 55e:	b7a5                	j	4c6 <vprintf+0x42>
 560:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 562:	008b8c13          	addi	s8,s7,8
 566:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 56a:	03000593          	li	a1,48
 56e:	8556                	mv	a0,s5
 570:	00000097          	auipc	ra,0x0
 574:	e46080e7          	jalr	-442(ra) # 3b6 <putc>
  putc(fd, 'x');
 578:	07800593          	li	a1,120
 57c:	8556                	mv	a0,s5
 57e:	00000097          	auipc	ra,0x0
 582:	e38080e7          	jalr	-456(ra) # 3b6 <putc>
 586:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 588:	00000b97          	auipc	s7,0x0
 58c:	4e8b8b93          	addi	s7,s7,1256 # a70 <digits>
 590:	03c9d793          	srli	a5,s3,0x3c
 594:	97de                	add	a5,a5,s7
 596:	0007c583          	lbu	a1,0(a5)
 59a:	8556                	mv	a0,s5
 59c:	00000097          	auipc	ra,0x0
 5a0:	e1a080e7          	jalr	-486(ra) # 3b6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5a4:	0992                	slli	s3,s3,0x4
 5a6:	397d                	addiw	s2,s2,-1
 5a8:	fe0914e3          	bnez	s2,590 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 5ac:	8be2                	mv	s7,s8
      state = 0;
 5ae:	4981                	li	s3,0
 5b0:	6c02                	ld	s8,0(sp)
 5b2:	bf11                	j	4c6 <vprintf+0x42>
        s = va_arg(ap, char*);
 5b4:	008b8993          	addi	s3,s7,8
 5b8:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5bc:	02090163          	beqz	s2,5de <vprintf+0x15a>
        while(*s != 0){
 5c0:	00094583          	lbu	a1,0(s2)
 5c4:	c9a5                	beqz	a1,634 <vprintf+0x1b0>
          putc(fd, *s);
 5c6:	8556                	mv	a0,s5
 5c8:	00000097          	auipc	ra,0x0
 5cc:	dee080e7          	jalr	-530(ra) # 3b6 <putc>
          s++;
 5d0:	0905                	addi	s2,s2,1
        while(*s != 0){
 5d2:	00094583          	lbu	a1,0(s2)
 5d6:	f9e5                	bnez	a1,5c6 <vprintf+0x142>
        s = va_arg(ap, char*);
 5d8:	8bce                	mv	s7,s3
      state = 0;
 5da:	4981                	li	s3,0
 5dc:	b5ed                	j	4c6 <vprintf+0x42>
          s = "(null)";
 5de:	00000917          	auipc	s2,0x0
 5e2:	43290913          	addi	s2,s2,1074 # a10 <malloc+0x1a4>
        while(*s != 0){
 5e6:	02800593          	li	a1,40
 5ea:	bff1                	j	5c6 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 5ec:	008b8913          	addi	s2,s7,8
 5f0:	000bc583          	lbu	a1,0(s7)
 5f4:	8556                	mv	a0,s5
 5f6:	00000097          	auipc	ra,0x0
 5fa:	dc0080e7          	jalr	-576(ra) # 3b6 <putc>
 5fe:	8bca                	mv	s7,s2
      state = 0;
 600:	4981                	li	s3,0
 602:	b5d1                	j	4c6 <vprintf+0x42>
        putc(fd, c);
 604:	02500593          	li	a1,37
 608:	8556                	mv	a0,s5
 60a:	00000097          	auipc	ra,0x0
 60e:	dac080e7          	jalr	-596(ra) # 3b6 <putc>
      state = 0;
 612:	4981                	li	s3,0
 614:	bd4d                	j	4c6 <vprintf+0x42>
        putc(fd, '%');
 616:	02500593          	li	a1,37
 61a:	8556                	mv	a0,s5
 61c:	00000097          	auipc	ra,0x0
 620:	d9a080e7          	jalr	-614(ra) # 3b6 <putc>
        putc(fd, c);
 624:	85ca                	mv	a1,s2
 626:	8556                	mv	a0,s5
 628:	00000097          	auipc	ra,0x0
 62c:	d8e080e7          	jalr	-626(ra) # 3b6 <putc>
      state = 0;
 630:	4981                	li	s3,0
 632:	bd51                	j	4c6 <vprintf+0x42>
        s = va_arg(ap, char*);
 634:	8bce                	mv	s7,s3
      state = 0;
 636:	4981                	li	s3,0
 638:	b579                	j	4c6 <vprintf+0x42>
 63a:	74e2                	ld	s1,56(sp)
 63c:	79a2                	ld	s3,40(sp)
 63e:	7a02                	ld	s4,32(sp)
 640:	6ae2                	ld	s5,24(sp)
 642:	6b42                	ld	s6,16(sp)
 644:	6ba2                	ld	s7,8(sp)
    }
  }
}
 646:	60a6                	ld	ra,72(sp)
 648:	6406                	ld	s0,64(sp)
 64a:	7942                	ld	s2,48(sp)
 64c:	6161                	addi	sp,sp,80
 64e:	8082                	ret

0000000000000650 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 650:	715d                	addi	sp,sp,-80
 652:	ec06                	sd	ra,24(sp)
 654:	e822                	sd	s0,16(sp)
 656:	1000                	addi	s0,sp,32
 658:	e010                	sd	a2,0(s0)
 65a:	e414                	sd	a3,8(s0)
 65c:	e818                	sd	a4,16(s0)
 65e:	ec1c                	sd	a5,24(s0)
 660:	03043023          	sd	a6,32(s0)
 664:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 668:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 66c:	8622                	mv	a2,s0
 66e:	00000097          	auipc	ra,0x0
 672:	e16080e7          	jalr	-490(ra) # 484 <vprintf>
}
 676:	60e2                	ld	ra,24(sp)
 678:	6442                	ld	s0,16(sp)
 67a:	6161                	addi	sp,sp,80
 67c:	8082                	ret

000000000000067e <printf>:

void
printf(const char *fmt, ...)
{
 67e:	7159                	addi	sp,sp,-112
 680:	f406                	sd	ra,40(sp)
 682:	f022                	sd	s0,32(sp)
 684:	ec26                	sd	s1,24(sp)
 686:	1800                	addi	s0,sp,48
 688:	84aa                	mv	s1,a0
 68a:	e40c                	sd	a1,8(s0)
 68c:	e810                	sd	a2,16(s0)
 68e:	ec14                	sd	a3,24(s0)
 690:	f018                	sd	a4,32(s0)
 692:	f41c                	sd	a5,40(s0)
 694:	03043823          	sd	a6,48(s0)
 698:	03143c23          	sd	a7,56(s0)
  va_list ap;

  lock();
 69c:	00000097          	auipc	ra,0x0
 6a0:	d0a080e7          	jalr	-758(ra) # 3a6 <lock>
  va_start(ap, fmt);
 6a4:	00840613          	addi	a2,s0,8
 6a8:	fcc43c23          	sd	a2,-40(s0)
  vprintf(1, fmt, ap);
 6ac:	85a6                	mv	a1,s1
 6ae:	4505                	li	a0,1
 6b0:	00000097          	auipc	ra,0x0
 6b4:	dd4080e7          	jalr	-556(ra) # 484 <vprintf>
  unlock();
 6b8:	00000097          	auipc	ra,0x0
 6bc:	cf6080e7          	jalr	-778(ra) # 3ae <unlock>
}
 6c0:	70a2                	ld	ra,40(sp)
 6c2:	7402                	ld	s0,32(sp)
 6c4:	64e2                	ld	s1,24(sp)
 6c6:	6165                	addi	sp,sp,112
 6c8:	8082                	ret

00000000000006ca <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ca:	7179                	addi	sp,sp,-48
 6cc:	f422                	sd	s0,40(sp)
 6ce:	1800                	addi	s0,sp,48
 6d0:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6d4:	fd843783          	ld	a5,-40(s0)
 6d8:	17c1                	addi	a5,a5,-16
 6da:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6de:	00001797          	auipc	a5,0x1
 6e2:	d0278793          	addi	a5,a5,-766 # 13e0 <freep>
 6e6:	639c                	ld	a5,0(a5)
 6e8:	fef43423          	sd	a5,-24(s0)
 6ec:	a815                	j	720 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ee:	fe843783          	ld	a5,-24(s0)
 6f2:	639c                	ld	a5,0(a5)
 6f4:	fe843703          	ld	a4,-24(s0)
 6f8:	00f76f63          	bltu	a4,a5,716 <free+0x4c>
 6fc:	fe043703          	ld	a4,-32(s0)
 700:	fe843783          	ld	a5,-24(s0)
 704:	02e7eb63          	bltu	a5,a4,73a <free+0x70>
 708:	fe843783          	ld	a5,-24(s0)
 70c:	639c                	ld	a5,0(a5)
 70e:	fe043703          	ld	a4,-32(s0)
 712:	02f76463          	bltu	a4,a5,73a <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 716:	fe843783          	ld	a5,-24(s0)
 71a:	639c                	ld	a5,0(a5)
 71c:	fef43423          	sd	a5,-24(s0)
 720:	fe043703          	ld	a4,-32(s0)
 724:	fe843783          	ld	a5,-24(s0)
 728:	fce7f3e3          	bgeu	a5,a4,6ee <free+0x24>
 72c:	fe843783          	ld	a5,-24(s0)
 730:	639c                	ld	a5,0(a5)
 732:	fe043703          	ld	a4,-32(s0)
 736:	faf77ce3          	bgeu	a4,a5,6ee <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 73a:	fe043783          	ld	a5,-32(s0)
 73e:	479c                	lw	a5,8(a5)
 740:	1782                	slli	a5,a5,0x20
 742:	9381                	srli	a5,a5,0x20
 744:	0792                	slli	a5,a5,0x4
 746:	fe043703          	ld	a4,-32(s0)
 74a:	973e                	add	a4,a4,a5
 74c:	fe843783          	ld	a5,-24(s0)
 750:	639c                	ld	a5,0(a5)
 752:	02f71763          	bne	a4,a5,780 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 756:	fe043783          	ld	a5,-32(s0)
 75a:	4798                	lw	a4,8(a5)
 75c:	fe843783          	ld	a5,-24(s0)
 760:	639c                	ld	a5,0(a5)
 762:	479c                	lw	a5,8(a5)
 764:	9fb9                	addw	a5,a5,a4
 766:	0007871b          	sext.w	a4,a5
 76a:	fe043783          	ld	a5,-32(s0)
 76e:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 770:	fe843783          	ld	a5,-24(s0)
 774:	639c                	ld	a5,0(a5)
 776:	6398                	ld	a4,0(a5)
 778:	fe043783          	ld	a5,-32(s0)
 77c:	e398                	sd	a4,0(a5)
 77e:	a039                	j	78c <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 780:	fe843783          	ld	a5,-24(s0)
 784:	6398                	ld	a4,0(a5)
 786:	fe043783          	ld	a5,-32(s0)
 78a:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 78c:	fe843783          	ld	a5,-24(s0)
 790:	479c                	lw	a5,8(a5)
 792:	1782                	slli	a5,a5,0x20
 794:	9381                	srli	a5,a5,0x20
 796:	0792                	slli	a5,a5,0x4
 798:	fe843703          	ld	a4,-24(s0)
 79c:	97ba                	add	a5,a5,a4
 79e:	fe043703          	ld	a4,-32(s0)
 7a2:	02f71563          	bne	a4,a5,7cc <free+0x102>
    p->s.size += bp->s.size;
 7a6:	fe843783          	ld	a5,-24(s0)
 7aa:	4798                	lw	a4,8(a5)
 7ac:	fe043783          	ld	a5,-32(s0)
 7b0:	479c                	lw	a5,8(a5)
 7b2:	9fb9                	addw	a5,a5,a4
 7b4:	0007871b          	sext.w	a4,a5
 7b8:	fe843783          	ld	a5,-24(s0)
 7bc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7be:	fe043783          	ld	a5,-32(s0)
 7c2:	6398                	ld	a4,0(a5)
 7c4:	fe843783          	ld	a5,-24(s0)
 7c8:	e398                	sd	a4,0(a5)
 7ca:	a031                	j	7d6 <free+0x10c>
  } else
    p->s.ptr = bp;
 7cc:	fe843783          	ld	a5,-24(s0)
 7d0:	fe043703          	ld	a4,-32(s0)
 7d4:	e398                	sd	a4,0(a5)
  freep = p;
 7d6:	00001797          	auipc	a5,0x1
 7da:	c0a78793          	addi	a5,a5,-1014 # 13e0 <freep>
 7de:	fe843703          	ld	a4,-24(s0)
 7e2:	e398                	sd	a4,0(a5)
}
 7e4:	0001                	nop
 7e6:	7422                	ld	s0,40(sp)
 7e8:	6145                	addi	sp,sp,48
 7ea:	8082                	ret

00000000000007ec <morecore>:

static Header*
morecore(uint nu)
{
 7ec:	7179                	addi	sp,sp,-48
 7ee:	f406                	sd	ra,40(sp)
 7f0:	f022                	sd	s0,32(sp)
 7f2:	1800                	addi	s0,sp,48
 7f4:	87aa                	mv	a5,a0
 7f6:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 7fa:	fdc42783          	lw	a5,-36(s0)
 7fe:	0007871b          	sext.w	a4,a5
 802:	6785                	lui	a5,0x1
 804:	00f77563          	bgeu	a4,a5,80e <morecore+0x22>
    nu = 4096;
 808:	6785                	lui	a5,0x1
 80a:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 80e:	fdc42783          	lw	a5,-36(s0)
 812:	0047979b          	slliw	a5,a5,0x4
 816:	2781                	sext.w	a5,a5
 818:	2781                	sext.w	a5,a5
 81a:	853e                	mv	a0,a5
 81c:	00000097          	auipc	ra,0x0
 820:	b6a080e7          	jalr	-1174(ra) # 386 <sbrk>
 824:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 828:	fe843703          	ld	a4,-24(s0)
 82c:	57fd                	li	a5,-1
 82e:	00f71463          	bne	a4,a5,836 <morecore+0x4a>
    return 0;
 832:	4781                	li	a5,0
 834:	a03d                	j	862 <morecore+0x76>
  hp = (Header*)p;
 836:	fe843783          	ld	a5,-24(s0)
 83a:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 83e:	fe043783          	ld	a5,-32(s0)
 842:	fdc42703          	lw	a4,-36(s0)
 846:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 848:	fe043783          	ld	a5,-32(s0)
 84c:	07c1                	addi	a5,a5,16 # 1010 <digits+0x5a0>
 84e:	853e                	mv	a0,a5
 850:	00000097          	auipc	ra,0x0
 854:	e7a080e7          	jalr	-390(ra) # 6ca <free>
  return freep;
 858:	00001797          	auipc	a5,0x1
 85c:	b8878793          	addi	a5,a5,-1144 # 13e0 <freep>
 860:	639c                	ld	a5,0(a5)
}
 862:	853e                	mv	a0,a5
 864:	70a2                	ld	ra,40(sp)
 866:	7402                	ld	s0,32(sp)
 868:	6145                	addi	sp,sp,48
 86a:	8082                	ret

000000000000086c <malloc>:

void*
malloc(uint nbytes)
{
 86c:	7139                	addi	sp,sp,-64
 86e:	fc06                	sd	ra,56(sp)
 870:	f822                	sd	s0,48(sp)
 872:	0080                	addi	s0,sp,64
 874:	87aa                	mv	a5,a0
 876:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 87a:	fcc46783          	lwu	a5,-52(s0)
 87e:	07bd                	addi	a5,a5,15
 880:	8391                	srli	a5,a5,0x4
 882:	2781                	sext.w	a5,a5
 884:	2785                	addiw	a5,a5,1
 886:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 88a:	00001797          	auipc	a5,0x1
 88e:	b5678793          	addi	a5,a5,-1194 # 13e0 <freep>
 892:	639c                	ld	a5,0(a5)
 894:	fef43023          	sd	a5,-32(s0)
 898:	fe043783          	ld	a5,-32(s0)
 89c:	ef95                	bnez	a5,8d8 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 89e:	00001797          	auipc	a5,0x1
 8a2:	b3278793          	addi	a5,a5,-1230 # 13d0 <base>
 8a6:	fef43023          	sd	a5,-32(s0)
 8aa:	00001797          	auipc	a5,0x1
 8ae:	b3678793          	addi	a5,a5,-1226 # 13e0 <freep>
 8b2:	fe043703          	ld	a4,-32(s0)
 8b6:	e398                	sd	a4,0(a5)
 8b8:	00001797          	auipc	a5,0x1
 8bc:	b2878793          	addi	a5,a5,-1240 # 13e0 <freep>
 8c0:	6398                	ld	a4,0(a5)
 8c2:	00001797          	auipc	a5,0x1
 8c6:	b0e78793          	addi	a5,a5,-1266 # 13d0 <base>
 8ca:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 8cc:	00001797          	auipc	a5,0x1
 8d0:	b0478793          	addi	a5,a5,-1276 # 13d0 <base>
 8d4:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d8:	fe043783          	ld	a5,-32(s0)
 8dc:	639c                	ld	a5,0(a5)
 8de:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 8e2:	fe843783          	ld	a5,-24(s0)
 8e6:	4798                	lw	a4,8(a5)
 8e8:	fdc42783          	lw	a5,-36(s0)
 8ec:	2781                	sext.w	a5,a5
 8ee:	06f76763          	bltu	a4,a5,95c <malloc+0xf0>
      if(p->s.size == nunits)
 8f2:	fe843783          	ld	a5,-24(s0)
 8f6:	4798                	lw	a4,8(a5)
 8f8:	fdc42783          	lw	a5,-36(s0)
 8fc:	2781                	sext.w	a5,a5
 8fe:	00e79963          	bne	a5,a4,910 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 902:	fe843783          	ld	a5,-24(s0)
 906:	6398                	ld	a4,0(a5)
 908:	fe043783          	ld	a5,-32(s0)
 90c:	e398                	sd	a4,0(a5)
 90e:	a825                	j	946 <malloc+0xda>
      else {
        p->s.size -= nunits;
 910:	fe843783          	ld	a5,-24(s0)
 914:	479c                	lw	a5,8(a5)
 916:	fdc42703          	lw	a4,-36(s0)
 91a:	9f99                	subw	a5,a5,a4
 91c:	0007871b          	sext.w	a4,a5
 920:	fe843783          	ld	a5,-24(s0)
 924:	c798                	sw	a4,8(a5)
        p += p->s.size;
 926:	fe843783          	ld	a5,-24(s0)
 92a:	479c                	lw	a5,8(a5)
 92c:	1782                	slli	a5,a5,0x20
 92e:	9381                	srli	a5,a5,0x20
 930:	0792                	slli	a5,a5,0x4
 932:	fe843703          	ld	a4,-24(s0)
 936:	97ba                	add	a5,a5,a4
 938:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 93c:	fe843783          	ld	a5,-24(s0)
 940:	fdc42703          	lw	a4,-36(s0)
 944:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 946:	00001797          	auipc	a5,0x1
 94a:	a9a78793          	addi	a5,a5,-1382 # 13e0 <freep>
 94e:	fe043703          	ld	a4,-32(s0)
 952:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 954:	fe843783          	ld	a5,-24(s0)
 958:	07c1                	addi	a5,a5,16
 95a:	a091                	j	99e <malloc+0x132>
    }
    if(p == freep)
 95c:	00001797          	auipc	a5,0x1
 960:	a8478793          	addi	a5,a5,-1404 # 13e0 <freep>
 964:	639c                	ld	a5,0(a5)
 966:	fe843703          	ld	a4,-24(s0)
 96a:	02f71063          	bne	a4,a5,98a <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 96e:	fdc42783          	lw	a5,-36(s0)
 972:	853e                	mv	a0,a5
 974:	00000097          	auipc	ra,0x0
 978:	e78080e7          	jalr	-392(ra) # 7ec <morecore>
 97c:	fea43423          	sd	a0,-24(s0)
 980:	fe843783          	ld	a5,-24(s0)
 984:	e399                	bnez	a5,98a <malloc+0x11e>
        return 0;
 986:	4781                	li	a5,0
 988:	a819                	j	99e <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 98a:	fe843783          	ld	a5,-24(s0)
 98e:	fef43023          	sd	a5,-32(s0)
 992:	fe843783          	ld	a5,-24(s0)
 996:	639c                	ld	a5,0(a5)
 998:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 99c:	b799                	j	8e2 <malloc+0x76>
  }
}
 99e:	853e                	mv	a0,a5
 9a0:	70e2                	ld	ra,56(sp)
 9a2:	7442                	ld	s0,48(sp)
 9a4:	6121                	addi	sp,sp,64
 9a6:	8082                	ret
