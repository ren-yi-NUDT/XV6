
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	00000097          	auipc	ra,0x0
   c:	2a0080e7          	jalr	672(ra) # 2a8 <fork>
  10:	00a04763          	bgtz	a0,1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  exit(0);
  14:	4501                	li	a0,0
  16:	00000097          	auipc	ra,0x0
  1a:	29a080e7          	jalr	666(ra) # 2b0 <exit>
    sleep(5);  // Let child exit before parent.
  1e:	4515                	li	a0,5
  20:	00000097          	auipc	ra,0x0
  24:	320080e7          	jalr	800(ra) # 340 <sleep>
  28:	b7f5                	j	14 <main+0x14>

000000000000002a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  2a:	1141                	addi	sp,sp,-16
  2c:	e406                	sd	ra,8(sp)
  2e:	e022                	sd	s0,0(sp)
  30:	0800                	addi	s0,sp,16
  extern int main();
  main();
  32:	00000097          	auipc	ra,0x0
  36:	fce080e7          	jalr	-50(ra) # 0 <main>
  exit(0);
  3a:	4501                	li	a0,0
  3c:	00000097          	auipc	ra,0x0
  40:	274080e7          	jalr	628(ra) # 2b0 <exit>

0000000000000044 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  44:	1141                	addi	sp,sp,-16
  46:	e422                	sd	s0,8(sp)
  48:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  4a:	87aa                	mv	a5,a0
  4c:	0585                	addi	a1,a1,1
  4e:	0785                	addi	a5,a5,1
  50:	fff5c703          	lbu	a4,-1(a1)
  54:	fee78fa3          	sb	a4,-1(a5)
  58:	fb75                	bnez	a4,4c <strcpy+0x8>
    ;
  return os;
}
  5a:	6422                	ld	s0,8(sp)
  5c:	0141                	addi	sp,sp,16
  5e:	8082                	ret

0000000000000060 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  60:	1141                	addi	sp,sp,-16
  62:	e422                	sd	s0,8(sp)
  64:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  66:	00054783          	lbu	a5,0(a0)
  6a:	cb91                	beqz	a5,7e <strcmp+0x1e>
  6c:	0005c703          	lbu	a4,0(a1)
  70:	00f71763          	bne	a4,a5,7e <strcmp+0x1e>
    p++, q++;
  74:	0505                	addi	a0,a0,1
  76:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  78:	00054783          	lbu	a5,0(a0)
  7c:	fbe5                	bnez	a5,6c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  7e:	0005c503          	lbu	a0,0(a1)
}
  82:	40a7853b          	subw	a0,a5,a0
  86:	6422                	ld	s0,8(sp)
  88:	0141                	addi	sp,sp,16
  8a:	8082                	ret

000000000000008c <strlen>:

uint
strlen(const char *s)
{
  8c:	1141                	addi	sp,sp,-16
  8e:	e422                	sd	s0,8(sp)
  90:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  92:	00054783          	lbu	a5,0(a0)
  96:	cf91                	beqz	a5,b2 <strlen+0x26>
  98:	0505                	addi	a0,a0,1
  9a:	87aa                	mv	a5,a0
  9c:	86be                	mv	a3,a5
  9e:	0785                	addi	a5,a5,1
  a0:	fff7c703          	lbu	a4,-1(a5)
  a4:	ff65                	bnez	a4,9c <strlen+0x10>
  a6:	40a6853b          	subw	a0,a3,a0
  aa:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  ac:	6422                	ld	s0,8(sp)
  ae:	0141                	addi	sp,sp,16
  b0:	8082                	ret
  for(n = 0; s[n]; n++)
  b2:	4501                	li	a0,0
  b4:	bfe5                	j	ac <strlen+0x20>

00000000000000b6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b6:	1141                	addi	sp,sp,-16
  b8:	e422                	sd	s0,8(sp)
  ba:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  bc:	ca19                	beqz	a2,d2 <memset+0x1c>
  be:	87aa                	mv	a5,a0
  c0:	1602                	slli	a2,a2,0x20
  c2:	9201                	srli	a2,a2,0x20
  c4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  c8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  cc:	0785                	addi	a5,a5,1
  ce:	fee79de3          	bne	a5,a4,c8 <memset+0x12>
  }
  return dst;
}
  d2:	6422                	ld	s0,8(sp)
  d4:	0141                	addi	sp,sp,16
  d6:	8082                	ret

00000000000000d8 <strchr>:

char*
strchr(const char *s, char c)
{
  d8:	1141                	addi	sp,sp,-16
  da:	e422                	sd	s0,8(sp)
  dc:	0800                	addi	s0,sp,16
  for(; *s; s++)
  de:	00054783          	lbu	a5,0(a0)
  e2:	cb99                	beqz	a5,f8 <strchr+0x20>
    if(*s == c)
  e4:	00f58763          	beq	a1,a5,f2 <strchr+0x1a>
  for(; *s; s++)
  e8:	0505                	addi	a0,a0,1
  ea:	00054783          	lbu	a5,0(a0)
  ee:	fbfd                	bnez	a5,e4 <strchr+0xc>
      return (char*)s;
  return 0;
  f0:	4501                	li	a0,0
}
  f2:	6422                	ld	s0,8(sp)
  f4:	0141                	addi	sp,sp,16
  f6:	8082                	ret
  return 0;
  f8:	4501                	li	a0,0
  fa:	bfe5                	j	f2 <strchr+0x1a>

00000000000000fc <gets>:

char*
gets(char *buf, int max)
{
  fc:	711d                	addi	sp,sp,-96
  fe:	ec86                	sd	ra,88(sp)
 100:	e8a2                	sd	s0,80(sp)
 102:	e4a6                	sd	s1,72(sp)
 104:	e0ca                	sd	s2,64(sp)
 106:	fc4e                	sd	s3,56(sp)
 108:	f852                	sd	s4,48(sp)
 10a:	f456                	sd	s5,40(sp)
 10c:	f05a                	sd	s6,32(sp)
 10e:	ec5e                	sd	s7,24(sp)
 110:	1080                	addi	s0,sp,96
 112:	8baa                	mv	s7,a0
 114:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 116:	892a                	mv	s2,a0
 118:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 11a:	4aa9                	li	s5,10
 11c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 11e:	89a6                	mv	s3,s1
 120:	2485                	addiw	s1,s1,1
 122:	0344d863          	bge	s1,s4,152 <gets+0x56>
    cc = read(0, &c, 1);
 126:	4605                	li	a2,1
 128:	faf40593          	addi	a1,s0,-81
 12c:	4501                	li	a0,0
 12e:	00000097          	auipc	ra,0x0
 132:	19a080e7          	jalr	410(ra) # 2c8 <read>
    if(cc < 1)
 136:	00a05e63          	blez	a0,152 <gets+0x56>
    buf[i++] = c;
 13a:	faf44783          	lbu	a5,-81(s0)
 13e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 142:	01578763          	beq	a5,s5,150 <gets+0x54>
 146:	0905                	addi	s2,s2,1
 148:	fd679be3          	bne	a5,s6,11e <gets+0x22>
    buf[i++] = c;
 14c:	89a6                	mv	s3,s1
 14e:	a011                	j	152 <gets+0x56>
 150:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 152:	99de                	add	s3,s3,s7
 154:	00098023          	sb	zero,0(s3)
  return buf;
}
 158:	855e                	mv	a0,s7
 15a:	60e6                	ld	ra,88(sp)
 15c:	6446                	ld	s0,80(sp)
 15e:	64a6                	ld	s1,72(sp)
 160:	6906                	ld	s2,64(sp)
 162:	79e2                	ld	s3,56(sp)
 164:	7a42                	ld	s4,48(sp)
 166:	7aa2                	ld	s5,40(sp)
 168:	7b02                	ld	s6,32(sp)
 16a:	6be2                	ld	s7,24(sp)
 16c:	6125                	addi	sp,sp,96
 16e:	8082                	ret

0000000000000170 <stat>:

int
stat(const char *n, struct stat *st)
{
 170:	1101                	addi	sp,sp,-32
 172:	ec06                	sd	ra,24(sp)
 174:	e822                	sd	s0,16(sp)
 176:	e04a                	sd	s2,0(sp)
 178:	1000                	addi	s0,sp,32
 17a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 17c:	4581                	li	a1,0
 17e:	00000097          	auipc	ra,0x0
 182:	172080e7          	jalr	370(ra) # 2f0 <open>
  if(fd < 0)
 186:	02054663          	bltz	a0,1b2 <stat+0x42>
 18a:	e426                	sd	s1,8(sp)
 18c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 18e:	85ca                	mv	a1,s2
 190:	00000097          	auipc	ra,0x0
 194:	178080e7          	jalr	376(ra) # 308 <fstat>
 198:	892a                	mv	s2,a0
  close(fd);
 19a:	8526                	mv	a0,s1
 19c:	00000097          	auipc	ra,0x0
 1a0:	13c080e7          	jalr	316(ra) # 2d8 <close>
  return r;
 1a4:	64a2                	ld	s1,8(sp)
}
 1a6:	854a                	mv	a0,s2
 1a8:	60e2                	ld	ra,24(sp)
 1aa:	6442                	ld	s0,16(sp)
 1ac:	6902                	ld	s2,0(sp)
 1ae:	6105                	addi	sp,sp,32
 1b0:	8082                	ret
    return -1;
 1b2:	597d                	li	s2,-1
 1b4:	bfcd                	j	1a6 <stat+0x36>

00000000000001b6 <atoi>:

int
atoi(const char *s)
{
 1b6:	1141                	addi	sp,sp,-16
 1b8:	e422                	sd	s0,8(sp)
 1ba:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1bc:	00054683          	lbu	a3,0(a0)
 1c0:	fd06879b          	addiw	a5,a3,-48
 1c4:	0ff7f793          	zext.b	a5,a5
 1c8:	4625                	li	a2,9
 1ca:	02f66863          	bltu	a2,a5,1fa <atoi+0x44>
 1ce:	872a                	mv	a4,a0
  n = 0;
 1d0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1d2:	0705                	addi	a4,a4,1
 1d4:	0025179b          	slliw	a5,a0,0x2
 1d8:	9fa9                	addw	a5,a5,a0
 1da:	0017979b          	slliw	a5,a5,0x1
 1de:	9fb5                	addw	a5,a5,a3
 1e0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1e4:	00074683          	lbu	a3,0(a4)
 1e8:	fd06879b          	addiw	a5,a3,-48
 1ec:	0ff7f793          	zext.b	a5,a5
 1f0:	fef671e3          	bgeu	a2,a5,1d2 <atoi+0x1c>
  return n;
}
 1f4:	6422                	ld	s0,8(sp)
 1f6:	0141                	addi	sp,sp,16
 1f8:	8082                	ret
  n = 0;
 1fa:	4501                	li	a0,0
 1fc:	bfe5                	j	1f4 <atoi+0x3e>

00000000000001fe <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1fe:	1141                	addi	sp,sp,-16
 200:	e422                	sd	s0,8(sp)
 202:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 204:	02b57463          	bgeu	a0,a1,22c <memmove+0x2e>
    while(n-- > 0)
 208:	00c05f63          	blez	a2,226 <memmove+0x28>
 20c:	1602                	slli	a2,a2,0x20
 20e:	9201                	srli	a2,a2,0x20
 210:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 214:	872a                	mv	a4,a0
      *dst++ = *src++;
 216:	0585                	addi	a1,a1,1
 218:	0705                	addi	a4,a4,1
 21a:	fff5c683          	lbu	a3,-1(a1)
 21e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 222:	fef71ae3          	bne	a4,a5,216 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 226:	6422                	ld	s0,8(sp)
 228:	0141                	addi	sp,sp,16
 22a:	8082                	ret
    dst += n;
 22c:	00c50733          	add	a4,a0,a2
    src += n;
 230:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 232:	fec05ae3          	blez	a2,226 <memmove+0x28>
 236:	fff6079b          	addiw	a5,a2,-1
 23a:	1782                	slli	a5,a5,0x20
 23c:	9381                	srli	a5,a5,0x20
 23e:	fff7c793          	not	a5,a5
 242:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 244:	15fd                	addi	a1,a1,-1
 246:	177d                	addi	a4,a4,-1
 248:	0005c683          	lbu	a3,0(a1)
 24c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 250:	fee79ae3          	bne	a5,a4,244 <memmove+0x46>
 254:	bfc9                	j	226 <memmove+0x28>

0000000000000256 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 256:	1141                	addi	sp,sp,-16
 258:	e422                	sd	s0,8(sp)
 25a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 25c:	ca05                	beqz	a2,28c <memcmp+0x36>
 25e:	fff6069b          	addiw	a3,a2,-1
 262:	1682                	slli	a3,a3,0x20
 264:	9281                	srli	a3,a3,0x20
 266:	0685                	addi	a3,a3,1
 268:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 26a:	00054783          	lbu	a5,0(a0)
 26e:	0005c703          	lbu	a4,0(a1)
 272:	00e79863          	bne	a5,a4,282 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 276:	0505                	addi	a0,a0,1
    p2++;
 278:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 27a:	fed518e3          	bne	a0,a3,26a <memcmp+0x14>
  }
  return 0;
 27e:	4501                	li	a0,0
 280:	a019                	j	286 <memcmp+0x30>
      return *p1 - *p2;
 282:	40e7853b          	subw	a0,a5,a4
}
 286:	6422                	ld	s0,8(sp)
 288:	0141                	addi	sp,sp,16
 28a:	8082                	ret
  return 0;
 28c:	4501                	li	a0,0
 28e:	bfe5                	j	286 <memcmp+0x30>

0000000000000290 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 290:	1141                	addi	sp,sp,-16
 292:	e406                	sd	ra,8(sp)
 294:	e022                	sd	s0,0(sp)
 296:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 298:	00000097          	auipc	ra,0x0
 29c:	f66080e7          	jalr	-154(ra) # 1fe <memmove>
}
 2a0:	60a2                	ld	ra,8(sp)
 2a2:	6402                	ld	s0,0(sp)
 2a4:	0141                	addi	sp,sp,16
 2a6:	8082                	ret

00000000000002a8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2a8:	4885                	li	a7,1
 ecall
 2aa:	00000073          	ecall
 ret
 2ae:	8082                	ret

00000000000002b0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2b0:	4889                	li	a7,2
 ecall
 2b2:	00000073          	ecall
 ret
 2b6:	8082                	ret

00000000000002b8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2b8:	488d                	li	a7,3
 ecall
 2ba:	00000073          	ecall
 ret
 2be:	8082                	ret

00000000000002c0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2c0:	4891                	li	a7,4
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <read>:
.global read
read:
 li a7, SYS_read
 2c8:	4895                	li	a7,5
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <write>:
.global write
write:
 li a7, SYS_write
 2d0:	48c1                	li	a7,16
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <close>:
.global close
close:
 li a7, SYS_close
 2d8:	48d5                	li	a7,21
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2e0:	4899                	li	a7,6
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2e8:	489d                	li	a7,7
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <open>:
.global open
open:
 li a7, SYS_open
 2f0:	48bd                	li	a7,15
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2f8:	48c5                	li	a7,17
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 300:	48c9                	li	a7,18
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 308:	48a1                	li	a7,8
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <link>:
.global link
link:
 li a7, SYS_link
 310:	48cd                	li	a7,19
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 318:	48d1                	li	a7,20
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 320:	48a5                	li	a7,9
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <dup>:
.global dup
dup:
 li a7, SYS_dup
 328:	48a9                	li	a7,10
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 330:	48ad                	li	a7,11
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 338:	48b1                	li	a7,12
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 340:	48b5                	li	a7,13
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 348:	48b9                	li	a7,14
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <yield>:
.global yield
yield:
 li a7, SYS_yield
 350:	48d9                	li	a7,22
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <lock>:
.global lock
lock:
 li a7, SYS_lock
 358:	48dd                	li	a7,23
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <unlock>:
.global unlock
unlock:
 li a7, SYS_unlock
 360:	48e1                	li	a7,24
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 368:	1101                	addi	sp,sp,-32
 36a:	ec06                	sd	ra,24(sp)
 36c:	e822                	sd	s0,16(sp)
 36e:	1000                	addi	s0,sp,32
 370:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 374:	4605                	li	a2,1
 376:	fef40593          	addi	a1,s0,-17
 37a:	00000097          	auipc	ra,0x0
 37e:	f56080e7          	jalr	-170(ra) # 2d0 <write>
}
 382:	60e2                	ld	ra,24(sp)
 384:	6442                	ld	s0,16(sp)
 386:	6105                	addi	sp,sp,32
 388:	8082                	ret

000000000000038a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 38a:	7139                	addi	sp,sp,-64
 38c:	fc06                	sd	ra,56(sp)
 38e:	f822                	sd	s0,48(sp)
 390:	f426                	sd	s1,40(sp)
 392:	0080                	addi	s0,sp,64
 394:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 396:	c299                	beqz	a3,39c <printint+0x12>
 398:	0805cb63          	bltz	a1,42e <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 39c:	2581                	sext.w	a1,a1
  neg = 0;
 39e:	4881                	li	a7,0
 3a0:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3a4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3a6:	2601                	sext.w	a2,a2
 3a8:	00000517          	auipc	a0,0x0
 3ac:	61850513          	addi	a0,a0,1560 # 9c0 <digits>
 3b0:	883a                	mv	a6,a4
 3b2:	2705                	addiw	a4,a4,1
 3b4:	02c5f7bb          	remuw	a5,a1,a2
 3b8:	1782                	slli	a5,a5,0x20
 3ba:	9381                	srli	a5,a5,0x20
 3bc:	97aa                	add	a5,a5,a0
 3be:	0007c783          	lbu	a5,0(a5)
 3c2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3c6:	0005879b          	sext.w	a5,a1
 3ca:	02c5d5bb          	divuw	a1,a1,a2
 3ce:	0685                	addi	a3,a3,1
 3d0:	fec7f0e3          	bgeu	a5,a2,3b0 <printint+0x26>
  if(neg)
 3d4:	00088c63          	beqz	a7,3ec <printint+0x62>
    buf[i++] = '-';
 3d8:	fd070793          	addi	a5,a4,-48
 3dc:	00878733          	add	a4,a5,s0
 3e0:	02d00793          	li	a5,45
 3e4:	fef70823          	sb	a5,-16(a4)
 3e8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3ec:	02e05c63          	blez	a4,424 <printint+0x9a>
 3f0:	f04a                	sd	s2,32(sp)
 3f2:	ec4e                	sd	s3,24(sp)
 3f4:	fc040793          	addi	a5,s0,-64
 3f8:	00e78933          	add	s2,a5,a4
 3fc:	fff78993          	addi	s3,a5,-1
 400:	99ba                	add	s3,s3,a4
 402:	377d                	addiw	a4,a4,-1
 404:	1702                	slli	a4,a4,0x20
 406:	9301                	srli	a4,a4,0x20
 408:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 40c:	fff94583          	lbu	a1,-1(s2)
 410:	8526                	mv	a0,s1
 412:	00000097          	auipc	ra,0x0
 416:	f56080e7          	jalr	-170(ra) # 368 <putc>
  while(--i >= 0)
 41a:	197d                	addi	s2,s2,-1
 41c:	ff3918e3          	bne	s2,s3,40c <printint+0x82>
 420:	7902                	ld	s2,32(sp)
 422:	69e2                	ld	s3,24(sp)
}
 424:	70e2                	ld	ra,56(sp)
 426:	7442                	ld	s0,48(sp)
 428:	74a2                	ld	s1,40(sp)
 42a:	6121                	addi	sp,sp,64
 42c:	8082                	ret
    x = -xx;
 42e:	40b005bb          	negw	a1,a1
    neg = 1;
 432:	4885                	li	a7,1
    x = -xx;
 434:	b7b5                	j	3a0 <printint+0x16>

0000000000000436 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 436:	715d                	addi	sp,sp,-80
 438:	e486                	sd	ra,72(sp)
 43a:	e0a2                	sd	s0,64(sp)
 43c:	f84a                	sd	s2,48(sp)
 43e:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 440:	0005c903          	lbu	s2,0(a1)
 444:	1a090a63          	beqz	s2,5f8 <vprintf+0x1c2>
 448:	fc26                	sd	s1,56(sp)
 44a:	f44e                	sd	s3,40(sp)
 44c:	f052                	sd	s4,32(sp)
 44e:	ec56                	sd	s5,24(sp)
 450:	e85a                	sd	s6,16(sp)
 452:	e45e                	sd	s7,8(sp)
 454:	8aaa                	mv	s5,a0
 456:	8bb2                	mv	s7,a2
 458:	00158493          	addi	s1,a1,1
  state = 0;
 45c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 45e:	02500a13          	li	s4,37
 462:	4b55                	li	s6,21
 464:	a839                	j	482 <vprintf+0x4c>
        putc(fd, c);
 466:	85ca                	mv	a1,s2
 468:	8556                	mv	a0,s5
 46a:	00000097          	auipc	ra,0x0
 46e:	efe080e7          	jalr	-258(ra) # 368 <putc>
 472:	a019                	j	478 <vprintf+0x42>
    } else if(state == '%'){
 474:	01498d63          	beq	s3,s4,48e <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 478:	0485                	addi	s1,s1,1
 47a:	fff4c903          	lbu	s2,-1(s1)
 47e:	16090763          	beqz	s2,5ec <vprintf+0x1b6>
    if(state == 0){
 482:	fe0999e3          	bnez	s3,474 <vprintf+0x3e>
      if(c == '%'){
 486:	ff4910e3          	bne	s2,s4,466 <vprintf+0x30>
        state = '%';
 48a:	89d2                	mv	s3,s4
 48c:	b7f5                	j	478 <vprintf+0x42>
      if(c == 'd'){
 48e:	13490463          	beq	s2,s4,5b6 <vprintf+0x180>
 492:	f9d9079b          	addiw	a5,s2,-99
 496:	0ff7f793          	zext.b	a5,a5
 49a:	12fb6763          	bltu	s6,a5,5c8 <vprintf+0x192>
 49e:	f9d9079b          	addiw	a5,s2,-99
 4a2:	0ff7f713          	zext.b	a4,a5
 4a6:	12eb6163          	bltu	s6,a4,5c8 <vprintf+0x192>
 4aa:	00271793          	slli	a5,a4,0x2
 4ae:	00000717          	auipc	a4,0x0
 4b2:	4ba70713          	addi	a4,a4,1210 # 968 <malloc+0x14a>
 4b6:	97ba                	add	a5,a5,a4
 4b8:	439c                	lw	a5,0(a5)
 4ba:	97ba                	add	a5,a5,a4
 4bc:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4be:	008b8913          	addi	s2,s7,8
 4c2:	4685                	li	a3,1
 4c4:	4629                	li	a2,10
 4c6:	000ba583          	lw	a1,0(s7)
 4ca:	8556                	mv	a0,s5
 4cc:	00000097          	auipc	ra,0x0
 4d0:	ebe080e7          	jalr	-322(ra) # 38a <printint>
 4d4:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4d6:	4981                	li	s3,0
 4d8:	b745                	j	478 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4da:	008b8913          	addi	s2,s7,8
 4de:	4681                	li	a3,0
 4e0:	4629                	li	a2,10
 4e2:	000ba583          	lw	a1,0(s7)
 4e6:	8556                	mv	a0,s5
 4e8:	00000097          	auipc	ra,0x0
 4ec:	ea2080e7          	jalr	-350(ra) # 38a <printint>
 4f0:	8bca                	mv	s7,s2
      state = 0;
 4f2:	4981                	li	s3,0
 4f4:	b751                	j	478 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 4f6:	008b8913          	addi	s2,s7,8
 4fa:	4681                	li	a3,0
 4fc:	4641                	li	a2,16
 4fe:	000ba583          	lw	a1,0(s7)
 502:	8556                	mv	a0,s5
 504:	00000097          	auipc	ra,0x0
 508:	e86080e7          	jalr	-378(ra) # 38a <printint>
 50c:	8bca                	mv	s7,s2
      state = 0;
 50e:	4981                	li	s3,0
 510:	b7a5                	j	478 <vprintf+0x42>
 512:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 514:	008b8c13          	addi	s8,s7,8
 518:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 51c:	03000593          	li	a1,48
 520:	8556                	mv	a0,s5
 522:	00000097          	auipc	ra,0x0
 526:	e46080e7          	jalr	-442(ra) # 368 <putc>
  putc(fd, 'x');
 52a:	07800593          	li	a1,120
 52e:	8556                	mv	a0,s5
 530:	00000097          	auipc	ra,0x0
 534:	e38080e7          	jalr	-456(ra) # 368 <putc>
 538:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 53a:	00000b97          	auipc	s7,0x0
 53e:	486b8b93          	addi	s7,s7,1158 # 9c0 <digits>
 542:	03c9d793          	srli	a5,s3,0x3c
 546:	97de                	add	a5,a5,s7
 548:	0007c583          	lbu	a1,0(a5)
 54c:	8556                	mv	a0,s5
 54e:	00000097          	auipc	ra,0x0
 552:	e1a080e7          	jalr	-486(ra) # 368 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 556:	0992                	slli	s3,s3,0x4
 558:	397d                	addiw	s2,s2,-1
 55a:	fe0914e3          	bnez	s2,542 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 55e:	8be2                	mv	s7,s8
      state = 0;
 560:	4981                	li	s3,0
 562:	6c02                	ld	s8,0(sp)
 564:	bf11                	j	478 <vprintf+0x42>
        s = va_arg(ap, char*);
 566:	008b8993          	addi	s3,s7,8
 56a:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 56e:	02090163          	beqz	s2,590 <vprintf+0x15a>
        while(*s != 0){
 572:	00094583          	lbu	a1,0(s2)
 576:	c9a5                	beqz	a1,5e6 <vprintf+0x1b0>
          putc(fd, *s);
 578:	8556                	mv	a0,s5
 57a:	00000097          	auipc	ra,0x0
 57e:	dee080e7          	jalr	-530(ra) # 368 <putc>
          s++;
 582:	0905                	addi	s2,s2,1
        while(*s != 0){
 584:	00094583          	lbu	a1,0(s2)
 588:	f9e5                	bnez	a1,578 <vprintf+0x142>
        s = va_arg(ap, char*);
 58a:	8bce                	mv	s7,s3
      state = 0;
 58c:	4981                	li	s3,0
 58e:	b5ed                	j	478 <vprintf+0x42>
          s = "(null)";
 590:	00000917          	auipc	s2,0x0
 594:	3d090913          	addi	s2,s2,976 # 960 <malloc+0x142>
        while(*s != 0){
 598:	02800593          	li	a1,40
 59c:	bff1                	j	578 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 59e:	008b8913          	addi	s2,s7,8
 5a2:	000bc583          	lbu	a1,0(s7)
 5a6:	8556                	mv	a0,s5
 5a8:	00000097          	auipc	ra,0x0
 5ac:	dc0080e7          	jalr	-576(ra) # 368 <putc>
 5b0:	8bca                	mv	s7,s2
      state = 0;
 5b2:	4981                	li	s3,0
 5b4:	b5d1                	j	478 <vprintf+0x42>
        putc(fd, c);
 5b6:	02500593          	li	a1,37
 5ba:	8556                	mv	a0,s5
 5bc:	00000097          	auipc	ra,0x0
 5c0:	dac080e7          	jalr	-596(ra) # 368 <putc>
      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	bd4d                	j	478 <vprintf+0x42>
        putc(fd, '%');
 5c8:	02500593          	li	a1,37
 5cc:	8556                	mv	a0,s5
 5ce:	00000097          	auipc	ra,0x0
 5d2:	d9a080e7          	jalr	-614(ra) # 368 <putc>
        putc(fd, c);
 5d6:	85ca                	mv	a1,s2
 5d8:	8556                	mv	a0,s5
 5da:	00000097          	auipc	ra,0x0
 5de:	d8e080e7          	jalr	-626(ra) # 368 <putc>
      state = 0;
 5e2:	4981                	li	s3,0
 5e4:	bd51                	j	478 <vprintf+0x42>
        s = va_arg(ap, char*);
 5e6:	8bce                	mv	s7,s3
      state = 0;
 5e8:	4981                	li	s3,0
 5ea:	b579                	j	478 <vprintf+0x42>
 5ec:	74e2                	ld	s1,56(sp)
 5ee:	79a2                	ld	s3,40(sp)
 5f0:	7a02                	ld	s4,32(sp)
 5f2:	6ae2                	ld	s5,24(sp)
 5f4:	6b42                	ld	s6,16(sp)
 5f6:	6ba2                	ld	s7,8(sp)
    }
  }
}
 5f8:	60a6                	ld	ra,72(sp)
 5fa:	6406                	ld	s0,64(sp)
 5fc:	7942                	ld	s2,48(sp)
 5fe:	6161                	addi	sp,sp,80
 600:	8082                	ret

0000000000000602 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 602:	715d                	addi	sp,sp,-80
 604:	ec06                	sd	ra,24(sp)
 606:	e822                	sd	s0,16(sp)
 608:	1000                	addi	s0,sp,32
 60a:	e010                	sd	a2,0(s0)
 60c:	e414                	sd	a3,8(s0)
 60e:	e818                	sd	a4,16(s0)
 610:	ec1c                	sd	a5,24(s0)
 612:	03043023          	sd	a6,32(s0)
 616:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 61a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 61e:	8622                	mv	a2,s0
 620:	00000097          	auipc	ra,0x0
 624:	e16080e7          	jalr	-490(ra) # 436 <vprintf>
}
 628:	60e2                	ld	ra,24(sp)
 62a:	6442                	ld	s0,16(sp)
 62c:	6161                	addi	sp,sp,80
 62e:	8082                	ret

0000000000000630 <printf>:

void
printf(const char *fmt, ...)
{
 630:	7159                	addi	sp,sp,-112
 632:	f406                	sd	ra,40(sp)
 634:	f022                	sd	s0,32(sp)
 636:	ec26                	sd	s1,24(sp)
 638:	1800                	addi	s0,sp,48
 63a:	84aa                	mv	s1,a0
 63c:	e40c                	sd	a1,8(s0)
 63e:	e810                	sd	a2,16(s0)
 640:	ec14                	sd	a3,24(s0)
 642:	f018                	sd	a4,32(s0)
 644:	f41c                	sd	a5,40(s0)
 646:	03043823          	sd	a6,48(s0)
 64a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  lock();
 64e:	00000097          	auipc	ra,0x0
 652:	d0a080e7          	jalr	-758(ra) # 358 <lock>
  va_start(ap, fmt);
 656:	00840613          	addi	a2,s0,8
 65a:	fcc43c23          	sd	a2,-40(s0)
  vprintf(1, fmt, ap);
 65e:	85a6                	mv	a1,s1
 660:	4505                	li	a0,1
 662:	00000097          	auipc	ra,0x0
 666:	dd4080e7          	jalr	-556(ra) # 436 <vprintf>
  unlock();
 66a:	00000097          	auipc	ra,0x0
 66e:	cf6080e7          	jalr	-778(ra) # 360 <unlock>
}
 672:	70a2                	ld	ra,40(sp)
 674:	7402                	ld	s0,32(sp)
 676:	64e2                	ld	s1,24(sp)
 678:	6165                	addi	sp,sp,112
 67a:	8082                	ret

000000000000067c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 67c:	7179                	addi	sp,sp,-48
 67e:	f422                	sd	s0,40(sp)
 680:	1800                	addi	s0,sp,48
 682:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 686:	fd843783          	ld	a5,-40(s0)
 68a:	17c1                	addi	a5,a5,-16
 68c:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 690:	00001797          	auipc	a5,0x1
 694:	d3078793          	addi	a5,a5,-720 # 13c0 <freep>
 698:	639c                	ld	a5,0(a5)
 69a:	fef43423          	sd	a5,-24(s0)
 69e:	a815                	j	6d2 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a0:	fe843783          	ld	a5,-24(s0)
 6a4:	639c                	ld	a5,0(a5)
 6a6:	fe843703          	ld	a4,-24(s0)
 6aa:	00f76f63          	bltu	a4,a5,6c8 <free+0x4c>
 6ae:	fe043703          	ld	a4,-32(s0)
 6b2:	fe843783          	ld	a5,-24(s0)
 6b6:	02e7eb63          	bltu	a5,a4,6ec <free+0x70>
 6ba:	fe843783          	ld	a5,-24(s0)
 6be:	639c                	ld	a5,0(a5)
 6c0:	fe043703          	ld	a4,-32(s0)
 6c4:	02f76463          	bltu	a4,a5,6ec <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c8:	fe843783          	ld	a5,-24(s0)
 6cc:	639c                	ld	a5,0(a5)
 6ce:	fef43423          	sd	a5,-24(s0)
 6d2:	fe043703          	ld	a4,-32(s0)
 6d6:	fe843783          	ld	a5,-24(s0)
 6da:	fce7f3e3          	bgeu	a5,a4,6a0 <free+0x24>
 6de:	fe843783          	ld	a5,-24(s0)
 6e2:	639c                	ld	a5,0(a5)
 6e4:	fe043703          	ld	a4,-32(s0)
 6e8:	faf77ce3          	bgeu	a4,a5,6a0 <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6ec:	fe043783          	ld	a5,-32(s0)
 6f0:	479c                	lw	a5,8(a5)
 6f2:	1782                	slli	a5,a5,0x20
 6f4:	9381                	srli	a5,a5,0x20
 6f6:	0792                	slli	a5,a5,0x4
 6f8:	fe043703          	ld	a4,-32(s0)
 6fc:	973e                	add	a4,a4,a5
 6fe:	fe843783          	ld	a5,-24(s0)
 702:	639c                	ld	a5,0(a5)
 704:	02f71763          	bne	a4,a5,732 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 708:	fe043783          	ld	a5,-32(s0)
 70c:	4798                	lw	a4,8(a5)
 70e:	fe843783          	ld	a5,-24(s0)
 712:	639c                	ld	a5,0(a5)
 714:	479c                	lw	a5,8(a5)
 716:	9fb9                	addw	a5,a5,a4
 718:	0007871b          	sext.w	a4,a5
 71c:	fe043783          	ld	a5,-32(s0)
 720:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 722:	fe843783          	ld	a5,-24(s0)
 726:	639c                	ld	a5,0(a5)
 728:	6398                	ld	a4,0(a5)
 72a:	fe043783          	ld	a5,-32(s0)
 72e:	e398                	sd	a4,0(a5)
 730:	a039                	j	73e <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 732:	fe843783          	ld	a5,-24(s0)
 736:	6398                	ld	a4,0(a5)
 738:	fe043783          	ld	a5,-32(s0)
 73c:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 73e:	fe843783          	ld	a5,-24(s0)
 742:	479c                	lw	a5,8(a5)
 744:	1782                	slli	a5,a5,0x20
 746:	9381                	srli	a5,a5,0x20
 748:	0792                	slli	a5,a5,0x4
 74a:	fe843703          	ld	a4,-24(s0)
 74e:	97ba                	add	a5,a5,a4
 750:	fe043703          	ld	a4,-32(s0)
 754:	02f71563          	bne	a4,a5,77e <free+0x102>
    p->s.size += bp->s.size;
 758:	fe843783          	ld	a5,-24(s0)
 75c:	4798                	lw	a4,8(a5)
 75e:	fe043783          	ld	a5,-32(s0)
 762:	479c                	lw	a5,8(a5)
 764:	9fb9                	addw	a5,a5,a4
 766:	0007871b          	sext.w	a4,a5
 76a:	fe843783          	ld	a5,-24(s0)
 76e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 770:	fe043783          	ld	a5,-32(s0)
 774:	6398                	ld	a4,0(a5)
 776:	fe843783          	ld	a5,-24(s0)
 77a:	e398                	sd	a4,0(a5)
 77c:	a031                	j	788 <free+0x10c>
  } else
    p->s.ptr = bp;
 77e:	fe843783          	ld	a5,-24(s0)
 782:	fe043703          	ld	a4,-32(s0)
 786:	e398                	sd	a4,0(a5)
  freep = p;
 788:	00001797          	auipc	a5,0x1
 78c:	c3878793          	addi	a5,a5,-968 # 13c0 <freep>
 790:	fe843703          	ld	a4,-24(s0)
 794:	e398                	sd	a4,0(a5)
}
 796:	0001                	nop
 798:	7422                	ld	s0,40(sp)
 79a:	6145                	addi	sp,sp,48
 79c:	8082                	ret

000000000000079e <morecore>:

static Header*
morecore(uint nu)
{
 79e:	7179                	addi	sp,sp,-48
 7a0:	f406                	sd	ra,40(sp)
 7a2:	f022                	sd	s0,32(sp)
 7a4:	1800                	addi	s0,sp,48
 7a6:	87aa                	mv	a5,a0
 7a8:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 7ac:	fdc42783          	lw	a5,-36(s0)
 7b0:	0007871b          	sext.w	a4,a5
 7b4:	6785                	lui	a5,0x1
 7b6:	00f77563          	bgeu	a4,a5,7c0 <morecore+0x22>
    nu = 4096;
 7ba:	6785                	lui	a5,0x1
 7bc:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 7c0:	fdc42783          	lw	a5,-36(s0)
 7c4:	0047979b          	slliw	a5,a5,0x4
 7c8:	2781                	sext.w	a5,a5
 7ca:	2781                	sext.w	a5,a5
 7cc:	853e                	mv	a0,a5
 7ce:	00000097          	auipc	ra,0x0
 7d2:	b6a080e7          	jalr	-1174(ra) # 338 <sbrk>
 7d6:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 7da:	fe843703          	ld	a4,-24(s0)
 7de:	57fd                	li	a5,-1
 7e0:	00f71463          	bne	a4,a5,7e8 <morecore+0x4a>
    return 0;
 7e4:	4781                	li	a5,0
 7e6:	a03d                	j	814 <morecore+0x76>
  hp = (Header*)p;
 7e8:	fe843783          	ld	a5,-24(s0)
 7ec:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 7f0:	fe043783          	ld	a5,-32(s0)
 7f4:	fdc42703          	lw	a4,-36(s0)
 7f8:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 7fa:	fe043783          	ld	a5,-32(s0)
 7fe:	07c1                	addi	a5,a5,16 # 1010 <digits+0x650>
 800:	853e                	mv	a0,a5
 802:	00000097          	auipc	ra,0x0
 806:	e7a080e7          	jalr	-390(ra) # 67c <free>
  return freep;
 80a:	00001797          	auipc	a5,0x1
 80e:	bb678793          	addi	a5,a5,-1098 # 13c0 <freep>
 812:	639c                	ld	a5,0(a5)
}
 814:	853e                	mv	a0,a5
 816:	70a2                	ld	ra,40(sp)
 818:	7402                	ld	s0,32(sp)
 81a:	6145                	addi	sp,sp,48
 81c:	8082                	ret

000000000000081e <malloc>:

void*
malloc(uint nbytes)
{
 81e:	7139                	addi	sp,sp,-64
 820:	fc06                	sd	ra,56(sp)
 822:	f822                	sd	s0,48(sp)
 824:	0080                	addi	s0,sp,64
 826:	87aa                	mv	a5,a0
 828:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 82c:	fcc46783          	lwu	a5,-52(s0)
 830:	07bd                	addi	a5,a5,15
 832:	8391                	srli	a5,a5,0x4
 834:	2781                	sext.w	a5,a5
 836:	2785                	addiw	a5,a5,1
 838:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 83c:	00001797          	auipc	a5,0x1
 840:	b8478793          	addi	a5,a5,-1148 # 13c0 <freep>
 844:	639c                	ld	a5,0(a5)
 846:	fef43023          	sd	a5,-32(s0)
 84a:	fe043783          	ld	a5,-32(s0)
 84e:	ef95                	bnez	a5,88a <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 850:	00001797          	auipc	a5,0x1
 854:	b6078793          	addi	a5,a5,-1184 # 13b0 <base>
 858:	fef43023          	sd	a5,-32(s0)
 85c:	00001797          	auipc	a5,0x1
 860:	b6478793          	addi	a5,a5,-1180 # 13c0 <freep>
 864:	fe043703          	ld	a4,-32(s0)
 868:	e398                	sd	a4,0(a5)
 86a:	00001797          	auipc	a5,0x1
 86e:	b5678793          	addi	a5,a5,-1194 # 13c0 <freep>
 872:	6398                	ld	a4,0(a5)
 874:	00001797          	auipc	a5,0x1
 878:	b3c78793          	addi	a5,a5,-1220 # 13b0 <base>
 87c:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 87e:	00001797          	auipc	a5,0x1
 882:	b3278793          	addi	a5,a5,-1230 # 13b0 <base>
 886:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 88a:	fe043783          	ld	a5,-32(s0)
 88e:	639c                	ld	a5,0(a5)
 890:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 894:	fe843783          	ld	a5,-24(s0)
 898:	4798                	lw	a4,8(a5)
 89a:	fdc42783          	lw	a5,-36(s0)
 89e:	2781                	sext.w	a5,a5
 8a0:	06f76763          	bltu	a4,a5,90e <malloc+0xf0>
      if(p->s.size == nunits)
 8a4:	fe843783          	ld	a5,-24(s0)
 8a8:	4798                	lw	a4,8(a5)
 8aa:	fdc42783          	lw	a5,-36(s0)
 8ae:	2781                	sext.w	a5,a5
 8b0:	00e79963          	bne	a5,a4,8c2 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 8b4:	fe843783          	ld	a5,-24(s0)
 8b8:	6398                	ld	a4,0(a5)
 8ba:	fe043783          	ld	a5,-32(s0)
 8be:	e398                	sd	a4,0(a5)
 8c0:	a825                	j	8f8 <malloc+0xda>
      else {
        p->s.size -= nunits;
 8c2:	fe843783          	ld	a5,-24(s0)
 8c6:	479c                	lw	a5,8(a5)
 8c8:	fdc42703          	lw	a4,-36(s0)
 8cc:	9f99                	subw	a5,a5,a4
 8ce:	0007871b          	sext.w	a4,a5
 8d2:	fe843783          	ld	a5,-24(s0)
 8d6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8d8:	fe843783          	ld	a5,-24(s0)
 8dc:	479c                	lw	a5,8(a5)
 8de:	1782                	slli	a5,a5,0x20
 8e0:	9381                	srli	a5,a5,0x20
 8e2:	0792                	slli	a5,a5,0x4
 8e4:	fe843703          	ld	a4,-24(s0)
 8e8:	97ba                	add	a5,a5,a4
 8ea:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 8ee:	fe843783          	ld	a5,-24(s0)
 8f2:	fdc42703          	lw	a4,-36(s0)
 8f6:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 8f8:	00001797          	auipc	a5,0x1
 8fc:	ac878793          	addi	a5,a5,-1336 # 13c0 <freep>
 900:	fe043703          	ld	a4,-32(s0)
 904:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 906:	fe843783          	ld	a5,-24(s0)
 90a:	07c1                	addi	a5,a5,16
 90c:	a091                	j	950 <malloc+0x132>
    }
    if(p == freep)
 90e:	00001797          	auipc	a5,0x1
 912:	ab278793          	addi	a5,a5,-1358 # 13c0 <freep>
 916:	639c                	ld	a5,0(a5)
 918:	fe843703          	ld	a4,-24(s0)
 91c:	02f71063          	bne	a4,a5,93c <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 920:	fdc42783          	lw	a5,-36(s0)
 924:	853e                	mv	a0,a5
 926:	00000097          	auipc	ra,0x0
 92a:	e78080e7          	jalr	-392(ra) # 79e <morecore>
 92e:	fea43423          	sd	a0,-24(s0)
 932:	fe843783          	ld	a5,-24(s0)
 936:	e399                	bnez	a5,93c <malloc+0x11e>
        return 0;
 938:	4781                	li	a5,0
 93a:	a819                	j	950 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 93c:	fe843783          	ld	a5,-24(s0)
 940:	fef43023          	sd	a5,-32(s0)
 944:	fe843783          	ld	a5,-24(s0)
 948:	639c                	ld	a5,0(a5)
 94a:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 94e:	b799                	j	894 <malloc+0x76>
  }
}
 950:	853e                	mv	a0,a5
 952:	70e2                	ld	ra,56(sp)
 954:	7442                	ld	s0,48(sp)
 956:	6121                	addi	sp,sp,64
 958:	8082                	ret
