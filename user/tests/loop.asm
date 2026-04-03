
user/tests/_loop:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user/user.h"

int counter = 1;

void main(int argc, char *argv[])
{
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
  while(1)
   6:	a001                	j	6 <main+0x6>

0000000000000008 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
   8:	1141                	addi	sp,sp,-16
   a:	e406                	sd	ra,8(sp)
   c:	e022                	sd	s0,0(sp)
   e:	0800                	addi	s0,sp,16
  extern int main();
  main();
  10:	00000097          	auipc	ra,0x0
  14:	ff0080e7          	jalr	-16(ra) # 0 <main>
  exit(0);
  18:	4501                	li	a0,0
  1a:	00000097          	auipc	ra,0x0
  1e:	274080e7          	jalr	628(ra) # 28e <exit>

0000000000000022 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  22:	1141                	addi	sp,sp,-16
  24:	e422                	sd	s0,8(sp)
  26:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  28:	87aa                	mv	a5,a0
  2a:	0585                	addi	a1,a1,1
  2c:	0785                	addi	a5,a5,1
  2e:	fff5c703          	lbu	a4,-1(a1)
  32:	fee78fa3          	sb	a4,-1(a5)
  36:	fb75                	bnez	a4,2a <strcpy+0x8>
    ;
  return os;
}
  38:	6422                	ld	s0,8(sp)
  3a:	0141                	addi	sp,sp,16
  3c:	8082                	ret

000000000000003e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  3e:	1141                	addi	sp,sp,-16
  40:	e422                	sd	s0,8(sp)
  42:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  44:	00054783          	lbu	a5,0(a0)
  48:	cb91                	beqz	a5,5c <strcmp+0x1e>
  4a:	0005c703          	lbu	a4,0(a1)
  4e:	00f71763          	bne	a4,a5,5c <strcmp+0x1e>
    p++, q++;
  52:	0505                	addi	a0,a0,1
  54:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  56:	00054783          	lbu	a5,0(a0)
  5a:	fbe5                	bnez	a5,4a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  5c:	0005c503          	lbu	a0,0(a1)
}
  60:	40a7853b          	subw	a0,a5,a0
  64:	6422                	ld	s0,8(sp)
  66:	0141                	addi	sp,sp,16
  68:	8082                	ret

000000000000006a <strlen>:

uint
strlen(const char *s)
{
  6a:	1141                	addi	sp,sp,-16
  6c:	e422                	sd	s0,8(sp)
  6e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  70:	00054783          	lbu	a5,0(a0)
  74:	cf91                	beqz	a5,90 <strlen+0x26>
  76:	0505                	addi	a0,a0,1
  78:	87aa                	mv	a5,a0
  7a:	86be                	mv	a3,a5
  7c:	0785                	addi	a5,a5,1
  7e:	fff7c703          	lbu	a4,-1(a5)
  82:	ff65                	bnez	a4,7a <strlen+0x10>
  84:	40a6853b          	subw	a0,a3,a0
  88:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  8a:	6422                	ld	s0,8(sp)
  8c:	0141                	addi	sp,sp,16
  8e:	8082                	ret
  for(n = 0; s[n]; n++)
  90:	4501                	li	a0,0
  92:	bfe5                	j	8a <strlen+0x20>

0000000000000094 <memset>:

void*
memset(void *dst, int c, uint n)
{
  94:	1141                	addi	sp,sp,-16
  96:	e422                	sd	s0,8(sp)
  98:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  9a:	ca19                	beqz	a2,b0 <memset+0x1c>
  9c:	87aa                	mv	a5,a0
  9e:	1602                	slli	a2,a2,0x20
  a0:	9201                	srli	a2,a2,0x20
  a2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  a6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  aa:	0785                	addi	a5,a5,1
  ac:	fee79de3          	bne	a5,a4,a6 <memset+0x12>
  }
  return dst;
}
  b0:	6422                	ld	s0,8(sp)
  b2:	0141                	addi	sp,sp,16
  b4:	8082                	ret

00000000000000b6 <strchr>:

char*
strchr(const char *s, char c)
{
  b6:	1141                	addi	sp,sp,-16
  b8:	e422                	sd	s0,8(sp)
  ba:	0800                	addi	s0,sp,16
  for(; *s; s++)
  bc:	00054783          	lbu	a5,0(a0)
  c0:	cb99                	beqz	a5,d6 <strchr+0x20>
    if(*s == c)
  c2:	00f58763          	beq	a1,a5,d0 <strchr+0x1a>
  for(; *s; s++)
  c6:	0505                	addi	a0,a0,1
  c8:	00054783          	lbu	a5,0(a0)
  cc:	fbfd                	bnez	a5,c2 <strchr+0xc>
      return (char*)s;
  return 0;
  ce:	4501                	li	a0,0
}
  d0:	6422                	ld	s0,8(sp)
  d2:	0141                	addi	sp,sp,16
  d4:	8082                	ret
  return 0;
  d6:	4501                	li	a0,0
  d8:	bfe5                	j	d0 <strchr+0x1a>

00000000000000da <gets>:

char*
gets(char *buf, int max)
{
  da:	711d                	addi	sp,sp,-96
  dc:	ec86                	sd	ra,88(sp)
  de:	e8a2                	sd	s0,80(sp)
  e0:	e4a6                	sd	s1,72(sp)
  e2:	e0ca                	sd	s2,64(sp)
  e4:	fc4e                	sd	s3,56(sp)
  e6:	f852                	sd	s4,48(sp)
  e8:	f456                	sd	s5,40(sp)
  ea:	f05a                	sd	s6,32(sp)
  ec:	ec5e                	sd	s7,24(sp)
  ee:	1080                	addi	s0,sp,96
  f0:	8baa                	mv	s7,a0
  f2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  f4:	892a                	mv	s2,a0
  f6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
  f8:	4aa9                	li	s5,10
  fa:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
  fc:	89a6                	mv	s3,s1
  fe:	2485                	addiw	s1,s1,1
 100:	0344d863          	bge	s1,s4,130 <gets+0x56>
    cc = read(0, &c, 1);
 104:	4605                	li	a2,1
 106:	faf40593          	addi	a1,s0,-81
 10a:	4501                	li	a0,0
 10c:	00000097          	auipc	ra,0x0
 110:	19a080e7          	jalr	410(ra) # 2a6 <read>
    if(cc < 1)
 114:	00a05e63          	blez	a0,130 <gets+0x56>
    buf[i++] = c;
 118:	faf44783          	lbu	a5,-81(s0)
 11c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 120:	01578763          	beq	a5,s5,12e <gets+0x54>
 124:	0905                	addi	s2,s2,1
 126:	fd679be3          	bne	a5,s6,fc <gets+0x22>
    buf[i++] = c;
 12a:	89a6                	mv	s3,s1
 12c:	a011                	j	130 <gets+0x56>
 12e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 130:	99de                	add	s3,s3,s7
 132:	00098023          	sb	zero,0(s3)
  return buf;
}
 136:	855e                	mv	a0,s7
 138:	60e6                	ld	ra,88(sp)
 13a:	6446                	ld	s0,80(sp)
 13c:	64a6                	ld	s1,72(sp)
 13e:	6906                	ld	s2,64(sp)
 140:	79e2                	ld	s3,56(sp)
 142:	7a42                	ld	s4,48(sp)
 144:	7aa2                	ld	s5,40(sp)
 146:	7b02                	ld	s6,32(sp)
 148:	6be2                	ld	s7,24(sp)
 14a:	6125                	addi	sp,sp,96
 14c:	8082                	ret

000000000000014e <stat>:

int
stat(const char *n, struct stat *st)
{
 14e:	1101                	addi	sp,sp,-32
 150:	ec06                	sd	ra,24(sp)
 152:	e822                	sd	s0,16(sp)
 154:	e04a                	sd	s2,0(sp)
 156:	1000                	addi	s0,sp,32
 158:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 15a:	4581                	li	a1,0
 15c:	00000097          	auipc	ra,0x0
 160:	172080e7          	jalr	370(ra) # 2ce <open>
  if(fd < 0)
 164:	02054663          	bltz	a0,190 <stat+0x42>
 168:	e426                	sd	s1,8(sp)
 16a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 16c:	85ca                	mv	a1,s2
 16e:	00000097          	auipc	ra,0x0
 172:	178080e7          	jalr	376(ra) # 2e6 <fstat>
 176:	892a                	mv	s2,a0
  close(fd);
 178:	8526                	mv	a0,s1
 17a:	00000097          	auipc	ra,0x0
 17e:	13c080e7          	jalr	316(ra) # 2b6 <close>
  return r;
 182:	64a2                	ld	s1,8(sp)
}
 184:	854a                	mv	a0,s2
 186:	60e2                	ld	ra,24(sp)
 188:	6442                	ld	s0,16(sp)
 18a:	6902                	ld	s2,0(sp)
 18c:	6105                	addi	sp,sp,32
 18e:	8082                	ret
    return -1;
 190:	597d                	li	s2,-1
 192:	bfcd                	j	184 <stat+0x36>

0000000000000194 <atoi>:

int
atoi(const char *s)
{
 194:	1141                	addi	sp,sp,-16
 196:	e422                	sd	s0,8(sp)
 198:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 19a:	00054683          	lbu	a3,0(a0)
 19e:	fd06879b          	addiw	a5,a3,-48
 1a2:	0ff7f793          	zext.b	a5,a5
 1a6:	4625                	li	a2,9
 1a8:	02f66863          	bltu	a2,a5,1d8 <atoi+0x44>
 1ac:	872a                	mv	a4,a0
  n = 0;
 1ae:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1b0:	0705                	addi	a4,a4,1
 1b2:	0025179b          	slliw	a5,a0,0x2
 1b6:	9fa9                	addw	a5,a5,a0
 1b8:	0017979b          	slliw	a5,a5,0x1
 1bc:	9fb5                	addw	a5,a5,a3
 1be:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1c2:	00074683          	lbu	a3,0(a4)
 1c6:	fd06879b          	addiw	a5,a3,-48
 1ca:	0ff7f793          	zext.b	a5,a5
 1ce:	fef671e3          	bgeu	a2,a5,1b0 <atoi+0x1c>
  return n;
}
 1d2:	6422                	ld	s0,8(sp)
 1d4:	0141                	addi	sp,sp,16
 1d6:	8082                	ret
  n = 0;
 1d8:	4501                	li	a0,0
 1da:	bfe5                	j	1d2 <atoi+0x3e>

00000000000001dc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1dc:	1141                	addi	sp,sp,-16
 1de:	e422                	sd	s0,8(sp)
 1e0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1e2:	02b57463          	bgeu	a0,a1,20a <memmove+0x2e>
    while(n-- > 0)
 1e6:	00c05f63          	blez	a2,204 <memmove+0x28>
 1ea:	1602                	slli	a2,a2,0x20
 1ec:	9201                	srli	a2,a2,0x20
 1ee:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1f2:	872a                	mv	a4,a0
      *dst++ = *src++;
 1f4:	0585                	addi	a1,a1,1
 1f6:	0705                	addi	a4,a4,1
 1f8:	fff5c683          	lbu	a3,-1(a1)
 1fc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 200:	fef71ae3          	bne	a4,a5,1f4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 204:	6422                	ld	s0,8(sp)
 206:	0141                	addi	sp,sp,16
 208:	8082                	ret
    dst += n;
 20a:	00c50733          	add	a4,a0,a2
    src += n;
 20e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 210:	fec05ae3          	blez	a2,204 <memmove+0x28>
 214:	fff6079b          	addiw	a5,a2,-1
 218:	1782                	slli	a5,a5,0x20
 21a:	9381                	srli	a5,a5,0x20
 21c:	fff7c793          	not	a5,a5
 220:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 222:	15fd                	addi	a1,a1,-1
 224:	177d                	addi	a4,a4,-1
 226:	0005c683          	lbu	a3,0(a1)
 22a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 22e:	fee79ae3          	bne	a5,a4,222 <memmove+0x46>
 232:	bfc9                	j	204 <memmove+0x28>

0000000000000234 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 234:	1141                	addi	sp,sp,-16
 236:	e422                	sd	s0,8(sp)
 238:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 23a:	ca05                	beqz	a2,26a <memcmp+0x36>
 23c:	fff6069b          	addiw	a3,a2,-1
 240:	1682                	slli	a3,a3,0x20
 242:	9281                	srli	a3,a3,0x20
 244:	0685                	addi	a3,a3,1
 246:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 248:	00054783          	lbu	a5,0(a0)
 24c:	0005c703          	lbu	a4,0(a1)
 250:	00e79863          	bne	a5,a4,260 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 254:	0505                	addi	a0,a0,1
    p2++;
 256:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 258:	fed518e3          	bne	a0,a3,248 <memcmp+0x14>
  }
  return 0;
 25c:	4501                	li	a0,0
 25e:	a019                	j	264 <memcmp+0x30>
      return *p1 - *p2;
 260:	40e7853b          	subw	a0,a5,a4
}
 264:	6422                	ld	s0,8(sp)
 266:	0141                	addi	sp,sp,16
 268:	8082                	ret
  return 0;
 26a:	4501                	li	a0,0
 26c:	bfe5                	j	264 <memcmp+0x30>

000000000000026e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 26e:	1141                	addi	sp,sp,-16
 270:	e406                	sd	ra,8(sp)
 272:	e022                	sd	s0,0(sp)
 274:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 276:	00000097          	auipc	ra,0x0
 27a:	f66080e7          	jalr	-154(ra) # 1dc <memmove>
}
 27e:	60a2                	ld	ra,8(sp)
 280:	6402                	ld	s0,0(sp)
 282:	0141                	addi	sp,sp,16
 284:	8082                	ret

0000000000000286 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 286:	4885                	li	a7,1
 ecall
 288:	00000073          	ecall
 ret
 28c:	8082                	ret

000000000000028e <exit>:
.global exit
exit:
 li a7, SYS_exit
 28e:	4889                	li	a7,2
 ecall
 290:	00000073          	ecall
 ret
 294:	8082                	ret

0000000000000296 <wait>:
.global wait
wait:
 li a7, SYS_wait
 296:	488d                	li	a7,3
 ecall
 298:	00000073          	ecall
 ret
 29c:	8082                	ret

000000000000029e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 29e:	4891                	li	a7,4
 ecall
 2a0:	00000073          	ecall
 ret
 2a4:	8082                	ret

00000000000002a6 <read>:
.global read
read:
 li a7, SYS_read
 2a6:	4895                	li	a7,5
 ecall
 2a8:	00000073          	ecall
 ret
 2ac:	8082                	ret

00000000000002ae <write>:
.global write
write:
 li a7, SYS_write
 2ae:	48c1                	li	a7,16
 ecall
 2b0:	00000073          	ecall
 ret
 2b4:	8082                	ret

00000000000002b6 <close>:
.global close
close:
 li a7, SYS_close
 2b6:	48d5                	li	a7,21
 ecall
 2b8:	00000073          	ecall
 ret
 2bc:	8082                	ret

00000000000002be <kill>:
.global kill
kill:
 li a7, SYS_kill
 2be:	4899                	li	a7,6
 ecall
 2c0:	00000073          	ecall
 ret
 2c4:	8082                	ret

00000000000002c6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2c6:	489d                	li	a7,7
 ecall
 2c8:	00000073          	ecall
 ret
 2cc:	8082                	ret

00000000000002ce <open>:
.global open
open:
 li a7, SYS_open
 2ce:	48bd                	li	a7,15
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2d6:	48c5                	li	a7,17
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2de:	48c9                	li	a7,18
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2e6:	48a1                	li	a7,8
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <link>:
.global link
link:
 li a7, SYS_link
 2ee:	48cd                	li	a7,19
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2f6:	48d1                	li	a7,20
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 2fe:	48a5                	li	a7,9
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <dup>:
.global dup
dup:
 li a7, SYS_dup
 306:	48a9                	li	a7,10
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 30e:	48ad                	li	a7,11
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 316:	48b1                	li	a7,12
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 31e:	48b5                	li	a7,13
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 326:	48b9                	li	a7,14
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <yield>:
.global yield
yield:
 li a7, SYS_yield
 32e:	48d9                	li	a7,22
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <lock>:
.global lock
lock:
 li a7, SYS_lock
 336:	48dd                	li	a7,23
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <unlock>:
.global unlock
unlock:
 li a7, SYS_unlock
 33e:	48e1                	li	a7,24
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 346:	1101                	addi	sp,sp,-32
 348:	ec06                	sd	ra,24(sp)
 34a:	e822                	sd	s0,16(sp)
 34c:	1000                	addi	s0,sp,32
 34e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 352:	4605                	li	a2,1
 354:	fef40593          	addi	a1,s0,-17
 358:	00000097          	auipc	ra,0x0
 35c:	f56080e7          	jalr	-170(ra) # 2ae <write>
}
 360:	60e2                	ld	ra,24(sp)
 362:	6442                	ld	s0,16(sp)
 364:	6105                	addi	sp,sp,32
 366:	8082                	ret

0000000000000368 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 368:	7139                	addi	sp,sp,-64
 36a:	fc06                	sd	ra,56(sp)
 36c:	f822                	sd	s0,48(sp)
 36e:	f426                	sd	s1,40(sp)
 370:	0080                	addi	s0,sp,64
 372:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 374:	c299                	beqz	a3,37a <printint+0x12>
 376:	0805cb63          	bltz	a1,40c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 37a:	2581                	sext.w	a1,a1
  neg = 0;
 37c:	4881                	li	a7,0
 37e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 382:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 384:	2601                	sext.w	a2,a2
 386:	00000517          	auipc	a0,0x0
 38a:	61a50513          	addi	a0,a0,1562 # 9a0 <digits>
 38e:	883a                	mv	a6,a4
 390:	2705                	addiw	a4,a4,1
 392:	02c5f7bb          	remuw	a5,a1,a2
 396:	1782                	slli	a5,a5,0x20
 398:	9381                	srli	a5,a5,0x20
 39a:	97aa                	add	a5,a5,a0
 39c:	0007c783          	lbu	a5,0(a5)
 3a0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3a4:	0005879b          	sext.w	a5,a1
 3a8:	02c5d5bb          	divuw	a1,a1,a2
 3ac:	0685                	addi	a3,a3,1
 3ae:	fec7f0e3          	bgeu	a5,a2,38e <printint+0x26>
  if(neg)
 3b2:	00088c63          	beqz	a7,3ca <printint+0x62>
    buf[i++] = '-';
 3b6:	fd070793          	addi	a5,a4,-48
 3ba:	00878733          	add	a4,a5,s0
 3be:	02d00793          	li	a5,45
 3c2:	fef70823          	sb	a5,-16(a4)
 3c6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3ca:	02e05c63          	blez	a4,402 <printint+0x9a>
 3ce:	f04a                	sd	s2,32(sp)
 3d0:	ec4e                	sd	s3,24(sp)
 3d2:	fc040793          	addi	a5,s0,-64
 3d6:	00e78933          	add	s2,a5,a4
 3da:	fff78993          	addi	s3,a5,-1
 3de:	99ba                	add	s3,s3,a4
 3e0:	377d                	addiw	a4,a4,-1
 3e2:	1702                	slli	a4,a4,0x20
 3e4:	9301                	srli	a4,a4,0x20
 3e6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3ea:	fff94583          	lbu	a1,-1(s2)
 3ee:	8526                	mv	a0,s1
 3f0:	00000097          	auipc	ra,0x0
 3f4:	f56080e7          	jalr	-170(ra) # 346 <putc>
  while(--i >= 0)
 3f8:	197d                	addi	s2,s2,-1
 3fa:	ff3918e3          	bne	s2,s3,3ea <printint+0x82>
 3fe:	7902                	ld	s2,32(sp)
 400:	69e2                	ld	s3,24(sp)
}
 402:	70e2                	ld	ra,56(sp)
 404:	7442                	ld	s0,48(sp)
 406:	74a2                	ld	s1,40(sp)
 408:	6121                	addi	sp,sp,64
 40a:	8082                	ret
    x = -xx;
 40c:	40b005bb          	negw	a1,a1
    neg = 1;
 410:	4885                	li	a7,1
    x = -xx;
 412:	b7b5                	j	37e <printint+0x16>

0000000000000414 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 414:	715d                	addi	sp,sp,-80
 416:	e486                	sd	ra,72(sp)
 418:	e0a2                	sd	s0,64(sp)
 41a:	f84a                	sd	s2,48(sp)
 41c:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 41e:	0005c903          	lbu	s2,0(a1)
 422:	1a090a63          	beqz	s2,5d6 <vprintf+0x1c2>
 426:	fc26                	sd	s1,56(sp)
 428:	f44e                	sd	s3,40(sp)
 42a:	f052                	sd	s4,32(sp)
 42c:	ec56                	sd	s5,24(sp)
 42e:	e85a                	sd	s6,16(sp)
 430:	e45e                	sd	s7,8(sp)
 432:	8aaa                	mv	s5,a0
 434:	8bb2                	mv	s7,a2
 436:	00158493          	addi	s1,a1,1
  state = 0;
 43a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 43c:	02500a13          	li	s4,37
 440:	4b55                	li	s6,21
 442:	a839                	j	460 <vprintf+0x4c>
        putc(fd, c);
 444:	85ca                	mv	a1,s2
 446:	8556                	mv	a0,s5
 448:	00000097          	auipc	ra,0x0
 44c:	efe080e7          	jalr	-258(ra) # 346 <putc>
 450:	a019                	j	456 <vprintf+0x42>
    } else if(state == '%'){
 452:	01498d63          	beq	s3,s4,46c <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 456:	0485                	addi	s1,s1,1
 458:	fff4c903          	lbu	s2,-1(s1)
 45c:	16090763          	beqz	s2,5ca <vprintf+0x1b6>
    if(state == 0){
 460:	fe0999e3          	bnez	s3,452 <vprintf+0x3e>
      if(c == '%'){
 464:	ff4910e3          	bne	s2,s4,444 <vprintf+0x30>
        state = '%';
 468:	89d2                	mv	s3,s4
 46a:	b7f5                	j	456 <vprintf+0x42>
      if(c == 'd'){
 46c:	13490463          	beq	s2,s4,594 <vprintf+0x180>
 470:	f9d9079b          	addiw	a5,s2,-99
 474:	0ff7f793          	zext.b	a5,a5
 478:	12fb6763          	bltu	s6,a5,5a6 <vprintf+0x192>
 47c:	f9d9079b          	addiw	a5,s2,-99
 480:	0ff7f713          	zext.b	a4,a5
 484:	12eb6163          	bltu	s6,a4,5a6 <vprintf+0x192>
 488:	00271793          	slli	a5,a4,0x2
 48c:	00000717          	auipc	a4,0x0
 490:	4bc70713          	addi	a4,a4,1212 # 948 <malloc+0x14c>
 494:	97ba                	add	a5,a5,a4
 496:	439c                	lw	a5,0(a5)
 498:	97ba                	add	a5,a5,a4
 49a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 49c:	008b8913          	addi	s2,s7,8
 4a0:	4685                	li	a3,1
 4a2:	4629                	li	a2,10
 4a4:	000ba583          	lw	a1,0(s7)
 4a8:	8556                	mv	a0,s5
 4aa:	00000097          	auipc	ra,0x0
 4ae:	ebe080e7          	jalr	-322(ra) # 368 <printint>
 4b2:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4b4:	4981                	li	s3,0
 4b6:	b745                	j	456 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4b8:	008b8913          	addi	s2,s7,8
 4bc:	4681                	li	a3,0
 4be:	4629                	li	a2,10
 4c0:	000ba583          	lw	a1,0(s7)
 4c4:	8556                	mv	a0,s5
 4c6:	00000097          	auipc	ra,0x0
 4ca:	ea2080e7          	jalr	-350(ra) # 368 <printint>
 4ce:	8bca                	mv	s7,s2
      state = 0;
 4d0:	4981                	li	s3,0
 4d2:	b751                	j	456 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 4d4:	008b8913          	addi	s2,s7,8
 4d8:	4681                	li	a3,0
 4da:	4641                	li	a2,16
 4dc:	000ba583          	lw	a1,0(s7)
 4e0:	8556                	mv	a0,s5
 4e2:	00000097          	auipc	ra,0x0
 4e6:	e86080e7          	jalr	-378(ra) # 368 <printint>
 4ea:	8bca                	mv	s7,s2
      state = 0;
 4ec:	4981                	li	s3,0
 4ee:	b7a5                	j	456 <vprintf+0x42>
 4f0:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 4f2:	008b8c13          	addi	s8,s7,8
 4f6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 4fa:	03000593          	li	a1,48
 4fe:	8556                	mv	a0,s5
 500:	00000097          	auipc	ra,0x0
 504:	e46080e7          	jalr	-442(ra) # 346 <putc>
  putc(fd, 'x');
 508:	07800593          	li	a1,120
 50c:	8556                	mv	a0,s5
 50e:	00000097          	auipc	ra,0x0
 512:	e38080e7          	jalr	-456(ra) # 346 <putc>
 516:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 518:	00000b97          	auipc	s7,0x0
 51c:	488b8b93          	addi	s7,s7,1160 # 9a0 <digits>
 520:	03c9d793          	srli	a5,s3,0x3c
 524:	97de                	add	a5,a5,s7
 526:	0007c583          	lbu	a1,0(a5)
 52a:	8556                	mv	a0,s5
 52c:	00000097          	auipc	ra,0x0
 530:	e1a080e7          	jalr	-486(ra) # 346 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 534:	0992                	slli	s3,s3,0x4
 536:	397d                	addiw	s2,s2,-1
 538:	fe0914e3          	bnez	s2,520 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 53c:	8be2                	mv	s7,s8
      state = 0;
 53e:	4981                	li	s3,0
 540:	6c02                	ld	s8,0(sp)
 542:	bf11                	j	456 <vprintf+0x42>
        s = va_arg(ap, char*);
 544:	008b8993          	addi	s3,s7,8
 548:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 54c:	02090163          	beqz	s2,56e <vprintf+0x15a>
        while(*s != 0){
 550:	00094583          	lbu	a1,0(s2)
 554:	c9a5                	beqz	a1,5c4 <vprintf+0x1b0>
          putc(fd, *s);
 556:	8556                	mv	a0,s5
 558:	00000097          	auipc	ra,0x0
 55c:	dee080e7          	jalr	-530(ra) # 346 <putc>
          s++;
 560:	0905                	addi	s2,s2,1
        while(*s != 0){
 562:	00094583          	lbu	a1,0(s2)
 566:	f9e5                	bnez	a1,556 <vprintf+0x142>
        s = va_arg(ap, char*);
 568:	8bce                	mv	s7,s3
      state = 0;
 56a:	4981                	li	s3,0
 56c:	b5ed                	j	456 <vprintf+0x42>
          s = "(null)";
 56e:	00000917          	auipc	s2,0x0
 572:	3d290913          	addi	s2,s2,978 # 940 <malloc+0x144>
        while(*s != 0){
 576:	02800593          	li	a1,40
 57a:	bff1                	j	556 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 57c:	008b8913          	addi	s2,s7,8
 580:	000bc583          	lbu	a1,0(s7)
 584:	8556                	mv	a0,s5
 586:	00000097          	auipc	ra,0x0
 58a:	dc0080e7          	jalr	-576(ra) # 346 <putc>
 58e:	8bca                	mv	s7,s2
      state = 0;
 590:	4981                	li	s3,0
 592:	b5d1                	j	456 <vprintf+0x42>
        putc(fd, c);
 594:	02500593          	li	a1,37
 598:	8556                	mv	a0,s5
 59a:	00000097          	auipc	ra,0x0
 59e:	dac080e7          	jalr	-596(ra) # 346 <putc>
      state = 0;
 5a2:	4981                	li	s3,0
 5a4:	bd4d                	j	456 <vprintf+0x42>
        putc(fd, '%');
 5a6:	02500593          	li	a1,37
 5aa:	8556                	mv	a0,s5
 5ac:	00000097          	auipc	ra,0x0
 5b0:	d9a080e7          	jalr	-614(ra) # 346 <putc>
        putc(fd, c);
 5b4:	85ca                	mv	a1,s2
 5b6:	8556                	mv	a0,s5
 5b8:	00000097          	auipc	ra,0x0
 5bc:	d8e080e7          	jalr	-626(ra) # 346 <putc>
      state = 0;
 5c0:	4981                	li	s3,0
 5c2:	bd51                	j	456 <vprintf+0x42>
        s = va_arg(ap, char*);
 5c4:	8bce                	mv	s7,s3
      state = 0;
 5c6:	4981                	li	s3,0
 5c8:	b579                	j	456 <vprintf+0x42>
 5ca:	74e2                	ld	s1,56(sp)
 5cc:	79a2                	ld	s3,40(sp)
 5ce:	7a02                	ld	s4,32(sp)
 5d0:	6ae2                	ld	s5,24(sp)
 5d2:	6b42                	ld	s6,16(sp)
 5d4:	6ba2                	ld	s7,8(sp)
    }
  }
}
 5d6:	60a6                	ld	ra,72(sp)
 5d8:	6406                	ld	s0,64(sp)
 5da:	7942                	ld	s2,48(sp)
 5dc:	6161                	addi	sp,sp,80
 5de:	8082                	ret

00000000000005e0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5e0:	715d                	addi	sp,sp,-80
 5e2:	ec06                	sd	ra,24(sp)
 5e4:	e822                	sd	s0,16(sp)
 5e6:	1000                	addi	s0,sp,32
 5e8:	e010                	sd	a2,0(s0)
 5ea:	e414                	sd	a3,8(s0)
 5ec:	e818                	sd	a4,16(s0)
 5ee:	ec1c                	sd	a5,24(s0)
 5f0:	03043023          	sd	a6,32(s0)
 5f4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 5f8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 5fc:	8622                	mv	a2,s0
 5fe:	00000097          	auipc	ra,0x0
 602:	e16080e7          	jalr	-490(ra) # 414 <vprintf>
}
 606:	60e2                	ld	ra,24(sp)
 608:	6442                	ld	s0,16(sp)
 60a:	6161                	addi	sp,sp,80
 60c:	8082                	ret

000000000000060e <printf>:

void
printf(const char *fmt, ...)
{
 60e:	7159                	addi	sp,sp,-112
 610:	f406                	sd	ra,40(sp)
 612:	f022                	sd	s0,32(sp)
 614:	ec26                	sd	s1,24(sp)
 616:	1800                	addi	s0,sp,48
 618:	84aa                	mv	s1,a0
 61a:	e40c                	sd	a1,8(s0)
 61c:	e810                	sd	a2,16(s0)
 61e:	ec14                	sd	a3,24(s0)
 620:	f018                	sd	a4,32(s0)
 622:	f41c                	sd	a5,40(s0)
 624:	03043823          	sd	a6,48(s0)
 628:	03143c23          	sd	a7,56(s0)
  va_list ap;

  lock();
 62c:	00000097          	auipc	ra,0x0
 630:	d0a080e7          	jalr	-758(ra) # 336 <lock>
  va_start(ap, fmt);
 634:	00840613          	addi	a2,s0,8
 638:	fcc43c23          	sd	a2,-40(s0)
  vprintf(1, fmt, ap);
 63c:	85a6                	mv	a1,s1
 63e:	4505                	li	a0,1
 640:	00000097          	auipc	ra,0x0
 644:	dd4080e7          	jalr	-556(ra) # 414 <vprintf>
  unlock();
 648:	00000097          	auipc	ra,0x0
 64c:	cf6080e7          	jalr	-778(ra) # 33e <unlock>
}
 650:	70a2                	ld	ra,40(sp)
 652:	7402                	ld	s0,32(sp)
 654:	64e2                	ld	s1,24(sp)
 656:	6165                	addi	sp,sp,112
 658:	8082                	ret

000000000000065a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 65a:	7179                	addi	sp,sp,-48
 65c:	f422                	sd	s0,40(sp)
 65e:	1800                	addi	s0,sp,48
 660:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 664:	fd843783          	ld	a5,-40(s0)
 668:	17c1                	addi	a5,a5,-16
 66a:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 66e:	00001797          	auipc	a5,0x1
 672:	d6278793          	addi	a5,a5,-670 # 13d0 <freep>
 676:	639c                	ld	a5,0(a5)
 678:	fef43423          	sd	a5,-24(s0)
 67c:	a815                	j	6b0 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 67e:	fe843783          	ld	a5,-24(s0)
 682:	639c                	ld	a5,0(a5)
 684:	fe843703          	ld	a4,-24(s0)
 688:	00f76f63          	bltu	a4,a5,6a6 <free+0x4c>
 68c:	fe043703          	ld	a4,-32(s0)
 690:	fe843783          	ld	a5,-24(s0)
 694:	02e7eb63          	bltu	a5,a4,6ca <free+0x70>
 698:	fe843783          	ld	a5,-24(s0)
 69c:	639c                	ld	a5,0(a5)
 69e:	fe043703          	ld	a4,-32(s0)
 6a2:	02f76463          	bltu	a4,a5,6ca <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a6:	fe843783          	ld	a5,-24(s0)
 6aa:	639c                	ld	a5,0(a5)
 6ac:	fef43423          	sd	a5,-24(s0)
 6b0:	fe043703          	ld	a4,-32(s0)
 6b4:	fe843783          	ld	a5,-24(s0)
 6b8:	fce7f3e3          	bgeu	a5,a4,67e <free+0x24>
 6bc:	fe843783          	ld	a5,-24(s0)
 6c0:	639c                	ld	a5,0(a5)
 6c2:	fe043703          	ld	a4,-32(s0)
 6c6:	faf77ce3          	bgeu	a4,a5,67e <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6ca:	fe043783          	ld	a5,-32(s0)
 6ce:	479c                	lw	a5,8(a5)
 6d0:	1782                	slli	a5,a5,0x20
 6d2:	9381                	srli	a5,a5,0x20
 6d4:	0792                	slli	a5,a5,0x4
 6d6:	fe043703          	ld	a4,-32(s0)
 6da:	973e                	add	a4,a4,a5
 6dc:	fe843783          	ld	a5,-24(s0)
 6e0:	639c                	ld	a5,0(a5)
 6e2:	02f71763          	bne	a4,a5,710 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 6e6:	fe043783          	ld	a5,-32(s0)
 6ea:	4798                	lw	a4,8(a5)
 6ec:	fe843783          	ld	a5,-24(s0)
 6f0:	639c                	ld	a5,0(a5)
 6f2:	479c                	lw	a5,8(a5)
 6f4:	9fb9                	addw	a5,a5,a4
 6f6:	0007871b          	sext.w	a4,a5
 6fa:	fe043783          	ld	a5,-32(s0)
 6fe:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 700:	fe843783          	ld	a5,-24(s0)
 704:	639c                	ld	a5,0(a5)
 706:	6398                	ld	a4,0(a5)
 708:	fe043783          	ld	a5,-32(s0)
 70c:	e398                	sd	a4,0(a5)
 70e:	a039                	j	71c <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 710:	fe843783          	ld	a5,-24(s0)
 714:	6398                	ld	a4,0(a5)
 716:	fe043783          	ld	a5,-32(s0)
 71a:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 71c:	fe843783          	ld	a5,-24(s0)
 720:	479c                	lw	a5,8(a5)
 722:	1782                	slli	a5,a5,0x20
 724:	9381                	srli	a5,a5,0x20
 726:	0792                	slli	a5,a5,0x4
 728:	fe843703          	ld	a4,-24(s0)
 72c:	97ba                	add	a5,a5,a4
 72e:	fe043703          	ld	a4,-32(s0)
 732:	02f71563          	bne	a4,a5,75c <free+0x102>
    p->s.size += bp->s.size;
 736:	fe843783          	ld	a5,-24(s0)
 73a:	4798                	lw	a4,8(a5)
 73c:	fe043783          	ld	a5,-32(s0)
 740:	479c                	lw	a5,8(a5)
 742:	9fb9                	addw	a5,a5,a4
 744:	0007871b          	sext.w	a4,a5
 748:	fe843783          	ld	a5,-24(s0)
 74c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 74e:	fe043783          	ld	a5,-32(s0)
 752:	6398                	ld	a4,0(a5)
 754:	fe843783          	ld	a5,-24(s0)
 758:	e398                	sd	a4,0(a5)
 75a:	a031                	j	766 <free+0x10c>
  } else
    p->s.ptr = bp;
 75c:	fe843783          	ld	a5,-24(s0)
 760:	fe043703          	ld	a4,-32(s0)
 764:	e398                	sd	a4,0(a5)
  freep = p;
 766:	00001797          	auipc	a5,0x1
 76a:	c6a78793          	addi	a5,a5,-918 # 13d0 <freep>
 76e:	fe843703          	ld	a4,-24(s0)
 772:	e398                	sd	a4,0(a5)
}
 774:	0001                	nop
 776:	7422                	ld	s0,40(sp)
 778:	6145                	addi	sp,sp,48
 77a:	8082                	ret

000000000000077c <morecore>:

static Header*
morecore(uint nu)
{
 77c:	7179                	addi	sp,sp,-48
 77e:	f406                	sd	ra,40(sp)
 780:	f022                	sd	s0,32(sp)
 782:	1800                	addi	s0,sp,48
 784:	87aa                	mv	a5,a0
 786:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 78a:	fdc42783          	lw	a5,-36(s0)
 78e:	0007871b          	sext.w	a4,a5
 792:	6785                	lui	a5,0x1
 794:	00f77563          	bgeu	a4,a5,79e <morecore+0x22>
    nu = 4096;
 798:	6785                	lui	a5,0x1
 79a:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 79e:	fdc42783          	lw	a5,-36(s0)
 7a2:	0047979b          	slliw	a5,a5,0x4
 7a6:	2781                	sext.w	a5,a5
 7a8:	2781                	sext.w	a5,a5
 7aa:	853e                	mv	a0,a5
 7ac:	00000097          	auipc	ra,0x0
 7b0:	b6a080e7          	jalr	-1174(ra) # 316 <sbrk>
 7b4:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 7b8:	fe843703          	ld	a4,-24(s0)
 7bc:	57fd                	li	a5,-1
 7be:	00f71463          	bne	a4,a5,7c6 <morecore+0x4a>
    return 0;
 7c2:	4781                	li	a5,0
 7c4:	a03d                	j	7f2 <morecore+0x76>
  hp = (Header*)p;
 7c6:	fe843783          	ld	a5,-24(s0)
 7ca:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 7ce:	fe043783          	ld	a5,-32(s0)
 7d2:	fdc42703          	lw	a4,-36(s0)
 7d6:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 7d8:	fe043783          	ld	a5,-32(s0)
 7dc:	07c1                	addi	a5,a5,16 # 1010 <digits+0x670>
 7de:	853e                	mv	a0,a5
 7e0:	00000097          	auipc	ra,0x0
 7e4:	e7a080e7          	jalr	-390(ra) # 65a <free>
  return freep;
 7e8:	00001797          	auipc	a5,0x1
 7ec:	be878793          	addi	a5,a5,-1048 # 13d0 <freep>
 7f0:	639c                	ld	a5,0(a5)
}
 7f2:	853e                	mv	a0,a5
 7f4:	70a2                	ld	ra,40(sp)
 7f6:	7402                	ld	s0,32(sp)
 7f8:	6145                	addi	sp,sp,48
 7fa:	8082                	ret

00000000000007fc <malloc>:

void*
malloc(uint nbytes)
{
 7fc:	7139                	addi	sp,sp,-64
 7fe:	fc06                	sd	ra,56(sp)
 800:	f822                	sd	s0,48(sp)
 802:	0080                	addi	s0,sp,64
 804:	87aa                	mv	a5,a0
 806:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 80a:	fcc46783          	lwu	a5,-52(s0)
 80e:	07bd                	addi	a5,a5,15
 810:	8391                	srli	a5,a5,0x4
 812:	2781                	sext.w	a5,a5
 814:	2785                	addiw	a5,a5,1
 816:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 81a:	00001797          	auipc	a5,0x1
 81e:	bb678793          	addi	a5,a5,-1098 # 13d0 <freep>
 822:	639c                	ld	a5,0(a5)
 824:	fef43023          	sd	a5,-32(s0)
 828:	fe043783          	ld	a5,-32(s0)
 82c:	ef95                	bnez	a5,868 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 82e:	00001797          	auipc	a5,0x1
 832:	b9278793          	addi	a5,a5,-1134 # 13c0 <base>
 836:	fef43023          	sd	a5,-32(s0)
 83a:	00001797          	auipc	a5,0x1
 83e:	b9678793          	addi	a5,a5,-1130 # 13d0 <freep>
 842:	fe043703          	ld	a4,-32(s0)
 846:	e398                	sd	a4,0(a5)
 848:	00001797          	auipc	a5,0x1
 84c:	b8878793          	addi	a5,a5,-1144 # 13d0 <freep>
 850:	6398                	ld	a4,0(a5)
 852:	00001797          	auipc	a5,0x1
 856:	b6e78793          	addi	a5,a5,-1170 # 13c0 <base>
 85a:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 85c:	00001797          	auipc	a5,0x1
 860:	b6478793          	addi	a5,a5,-1180 # 13c0 <base>
 864:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 868:	fe043783          	ld	a5,-32(s0)
 86c:	639c                	ld	a5,0(a5)
 86e:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 872:	fe843783          	ld	a5,-24(s0)
 876:	4798                	lw	a4,8(a5)
 878:	fdc42783          	lw	a5,-36(s0)
 87c:	2781                	sext.w	a5,a5
 87e:	06f76763          	bltu	a4,a5,8ec <malloc+0xf0>
      if(p->s.size == nunits)
 882:	fe843783          	ld	a5,-24(s0)
 886:	4798                	lw	a4,8(a5)
 888:	fdc42783          	lw	a5,-36(s0)
 88c:	2781                	sext.w	a5,a5
 88e:	00e79963          	bne	a5,a4,8a0 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 892:	fe843783          	ld	a5,-24(s0)
 896:	6398                	ld	a4,0(a5)
 898:	fe043783          	ld	a5,-32(s0)
 89c:	e398                	sd	a4,0(a5)
 89e:	a825                	j	8d6 <malloc+0xda>
      else {
        p->s.size -= nunits;
 8a0:	fe843783          	ld	a5,-24(s0)
 8a4:	479c                	lw	a5,8(a5)
 8a6:	fdc42703          	lw	a4,-36(s0)
 8aa:	9f99                	subw	a5,a5,a4
 8ac:	0007871b          	sext.w	a4,a5
 8b0:	fe843783          	ld	a5,-24(s0)
 8b4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8b6:	fe843783          	ld	a5,-24(s0)
 8ba:	479c                	lw	a5,8(a5)
 8bc:	1782                	slli	a5,a5,0x20
 8be:	9381                	srli	a5,a5,0x20
 8c0:	0792                	slli	a5,a5,0x4
 8c2:	fe843703          	ld	a4,-24(s0)
 8c6:	97ba                	add	a5,a5,a4
 8c8:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 8cc:	fe843783          	ld	a5,-24(s0)
 8d0:	fdc42703          	lw	a4,-36(s0)
 8d4:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 8d6:	00001797          	auipc	a5,0x1
 8da:	afa78793          	addi	a5,a5,-1286 # 13d0 <freep>
 8de:	fe043703          	ld	a4,-32(s0)
 8e2:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 8e4:	fe843783          	ld	a5,-24(s0)
 8e8:	07c1                	addi	a5,a5,16
 8ea:	a091                	j	92e <malloc+0x132>
    }
    if(p == freep)
 8ec:	00001797          	auipc	a5,0x1
 8f0:	ae478793          	addi	a5,a5,-1308 # 13d0 <freep>
 8f4:	639c                	ld	a5,0(a5)
 8f6:	fe843703          	ld	a4,-24(s0)
 8fa:	02f71063          	bne	a4,a5,91a <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 8fe:	fdc42783          	lw	a5,-36(s0)
 902:	853e                	mv	a0,a5
 904:	00000097          	auipc	ra,0x0
 908:	e78080e7          	jalr	-392(ra) # 77c <morecore>
 90c:	fea43423          	sd	a0,-24(s0)
 910:	fe843783          	ld	a5,-24(s0)
 914:	e399                	bnez	a5,91a <malloc+0x11e>
        return 0;
 916:	4781                	li	a5,0
 918:	a819                	j	92e <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 91a:	fe843783          	ld	a5,-24(s0)
 91e:	fef43023          	sd	a5,-32(s0)
 922:	fe843783          	ld	a5,-24(s0)
 926:	639c                	ld	a5,0(a5)
 928:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 92c:	b799                	j	872 <malloc+0x76>
  }
}
 92e:	853e                	mv	a0,a5
 930:	70e2                	ld	ra,56(sp)
 932:	7442                	ld	s0,48(sp)
 934:	6121                	addi	sp,sp,64
 936:	8082                	ret
