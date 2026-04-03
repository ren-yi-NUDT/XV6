
user/tests/_loop_yield:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	0c800493          	li	s1,200
    for(int i=0; i<200; i++)
        yield();
   e:	00000097          	auipc	ra,0x0
  12:	33c080e7          	jalr	828(ra) # 34a <yield>
    for(int i=0; i<200; i++)
  16:	34fd                	addiw	s1,s1,-1
  18:	f8fd                	bnez	s1,e <main+0xe>
}
  1a:	60e2                	ld	ra,24(sp)
  1c:	6442                	ld	s0,16(sp)
  1e:	64a2                	ld	s1,8(sp)
  20:	6105                	addi	sp,sp,32
  22:	8082                	ret

0000000000000024 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  24:	1141                	addi	sp,sp,-16
  26:	e406                	sd	ra,8(sp)
  28:	e022                	sd	s0,0(sp)
  2a:	0800                	addi	s0,sp,16
  extern int main();
  main();
  2c:	00000097          	auipc	ra,0x0
  30:	fd4080e7          	jalr	-44(ra) # 0 <main>
  exit(0);
  34:	4501                	li	a0,0
  36:	00000097          	auipc	ra,0x0
  3a:	274080e7          	jalr	628(ra) # 2aa <exit>

000000000000003e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  3e:	1141                	addi	sp,sp,-16
  40:	e422                	sd	s0,8(sp)
  42:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  44:	87aa                	mv	a5,a0
  46:	0585                	addi	a1,a1,1
  48:	0785                	addi	a5,a5,1
  4a:	fff5c703          	lbu	a4,-1(a1)
  4e:	fee78fa3          	sb	a4,-1(a5)
  52:	fb75                	bnez	a4,46 <strcpy+0x8>
    ;
  return os;
}
  54:	6422                	ld	s0,8(sp)
  56:	0141                	addi	sp,sp,16
  58:	8082                	ret

000000000000005a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  5a:	1141                	addi	sp,sp,-16
  5c:	e422                	sd	s0,8(sp)
  5e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  60:	00054783          	lbu	a5,0(a0)
  64:	cb91                	beqz	a5,78 <strcmp+0x1e>
  66:	0005c703          	lbu	a4,0(a1)
  6a:	00f71763          	bne	a4,a5,78 <strcmp+0x1e>
    p++, q++;
  6e:	0505                	addi	a0,a0,1
  70:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  72:	00054783          	lbu	a5,0(a0)
  76:	fbe5                	bnez	a5,66 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  78:	0005c503          	lbu	a0,0(a1)
}
  7c:	40a7853b          	subw	a0,a5,a0
  80:	6422                	ld	s0,8(sp)
  82:	0141                	addi	sp,sp,16
  84:	8082                	ret

0000000000000086 <strlen>:

uint
strlen(const char *s)
{
  86:	1141                	addi	sp,sp,-16
  88:	e422                	sd	s0,8(sp)
  8a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  8c:	00054783          	lbu	a5,0(a0)
  90:	cf91                	beqz	a5,ac <strlen+0x26>
  92:	0505                	addi	a0,a0,1
  94:	87aa                	mv	a5,a0
  96:	86be                	mv	a3,a5
  98:	0785                	addi	a5,a5,1
  9a:	fff7c703          	lbu	a4,-1(a5)
  9e:	ff65                	bnez	a4,96 <strlen+0x10>
  a0:	40a6853b          	subw	a0,a3,a0
  a4:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  a6:	6422                	ld	s0,8(sp)
  a8:	0141                	addi	sp,sp,16
  aa:	8082                	ret
  for(n = 0; s[n]; n++)
  ac:	4501                	li	a0,0
  ae:	bfe5                	j	a6 <strlen+0x20>

00000000000000b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b0:	1141                	addi	sp,sp,-16
  b2:	e422                	sd	s0,8(sp)
  b4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  b6:	ca19                	beqz	a2,cc <memset+0x1c>
  b8:	87aa                	mv	a5,a0
  ba:	1602                	slli	a2,a2,0x20
  bc:	9201                	srli	a2,a2,0x20
  be:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  c2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  c6:	0785                	addi	a5,a5,1
  c8:	fee79de3          	bne	a5,a4,c2 <memset+0x12>
  }
  return dst;
}
  cc:	6422                	ld	s0,8(sp)
  ce:	0141                	addi	sp,sp,16
  d0:	8082                	ret

00000000000000d2 <strchr>:

char*
strchr(const char *s, char c)
{
  d2:	1141                	addi	sp,sp,-16
  d4:	e422                	sd	s0,8(sp)
  d6:	0800                	addi	s0,sp,16
  for(; *s; s++)
  d8:	00054783          	lbu	a5,0(a0)
  dc:	cb99                	beqz	a5,f2 <strchr+0x20>
    if(*s == c)
  de:	00f58763          	beq	a1,a5,ec <strchr+0x1a>
  for(; *s; s++)
  e2:	0505                	addi	a0,a0,1
  e4:	00054783          	lbu	a5,0(a0)
  e8:	fbfd                	bnez	a5,de <strchr+0xc>
      return (char*)s;
  return 0;
  ea:	4501                	li	a0,0
}
  ec:	6422                	ld	s0,8(sp)
  ee:	0141                	addi	sp,sp,16
  f0:	8082                	ret
  return 0;
  f2:	4501                	li	a0,0
  f4:	bfe5                	j	ec <strchr+0x1a>

00000000000000f6 <gets>:

char*
gets(char *buf, int max)
{
  f6:	711d                	addi	sp,sp,-96
  f8:	ec86                	sd	ra,88(sp)
  fa:	e8a2                	sd	s0,80(sp)
  fc:	e4a6                	sd	s1,72(sp)
  fe:	e0ca                	sd	s2,64(sp)
 100:	fc4e                	sd	s3,56(sp)
 102:	f852                	sd	s4,48(sp)
 104:	f456                	sd	s5,40(sp)
 106:	f05a                	sd	s6,32(sp)
 108:	ec5e                	sd	s7,24(sp)
 10a:	1080                	addi	s0,sp,96
 10c:	8baa                	mv	s7,a0
 10e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 110:	892a                	mv	s2,a0
 112:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 114:	4aa9                	li	s5,10
 116:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 118:	89a6                	mv	s3,s1
 11a:	2485                	addiw	s1,s1,1
 11c:	0344d863          	bge	s1,s4,14c <gets+0x56>
    cc = read(0, &c, 1);
 120:	4605                	li	a2,1
 122:	faf40593          	addi	a1,s0,-81
 126:	4501                	li	a0,0
 128:	00000097          	auipc	ra,0x0
 12c:	19a080e7          	jalr	410(ra) # 2c2 <read>
    if(cc < 1)
 130:	00a05e63          	blez	a0,14c <gets+0x56>
    buf[i++] = c;
 134:	faf44783          	lbu	a5,-81(s0)
 138:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 13c:	01578763          	beq	a5,s5,14a <gets+0x54>
 140:	0905                	addi	s2,s2,1
 142:	fd679be3          	bne	a5,s6,118 <gets+0x22>
    buf[i++] = c;
 146:	89a6                	mv	s3,s1
 148:	a011                	j	14c <gets+0x56>
 14a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 14c:	99de                	add	s3,s3,s7
 14e:	00098023          	sb	zero,0(s3)
  return buf;
}
 152:	855e                	mv	a0,s7
 154:	60e6                	ld	ra,88(sp)
 156:	6446                	ld	s0,80(sp)
 158:	64a6                	ld	s1,72(sp)
 15a:	6906                	ld	s2,64(sp)
 15c:	79e2                	ld	s3,56(sp)
 15e:	7a42                	ld	s4,48(sp)
 160:	7aa2                	ld	s5,40(sp)
 162:	7b02                	ld	s6,32(sp)
 164:	6be2                	ld	s7,24(sp)
 166:	6125                	addi	sp,sp,96
 168:	8082                	ret

000000000000016a <stat>:

int
stat(const char *n, struct stat *st)
{
 16a:	1101                	addi	sp,sp,-32
 16c:	ec06                	sd	ra,24(sp)
 16e:	e822                	sd	s0,16(sp)
 170:	e04a                	sd	s2,0(sp)
 172:	1000                	addi	s0,sp,32
 174:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 176:	4581                	li	a1,0
 178:	00000097          	auipc	ra,0x0
 17c:	172080e7          	jalr	370(ra) # 2ea <open>
  if(fd < 0)
 180:	02054663          	bltz	a0,1ac <stat+0x42>
 184:	e426                	sd	s1,8(sp)
 186:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 188:	85ca                	mv	a1,s2
 18a:	00000097          	auipc	ra,0x0
 18e:	178080e7          	jalr	376(ra) # 302 <fstat>
 192:	892a                	mv	s2,a0
  close(fd);
 194:	8526                	mv	a0,s1
 196:	00000097          	auipc	ra,0x0
 19a:	13c080e7          	jalr	316(ra) # 2d2 <close>
  return r;
 19e:	64a2                	ld	s1,8(sp)
}
 1a0:	854a                	mv	a0,s2
 1a2:	60e2                	ld	ra,24(sp)
 1a4:	6442                	ld	s0,16(sp)
 1a6:	6902                	ld	s2,0(sp)
 1a8:	6105                	addi	sp,sp,32
 1aa:	8082                	ret
    return -1;
 1ac:	597d                	li	s2,-1
 1ae:	bfcd                	j	1a0 <stat+0x36>

00000000000001b0 <atoi>:

int
atoi(const char *s)
{
 1b0:	1141                	addi	sp,sp,-16
 1b2:	e422                	sd	s0,8(sp)
 1b4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1b6:	00054683          	lbu	a3,0(a0)
 1ba:	fd06879b          	addiw	a5,a3,-48
 1be:	0ff7f793          	zext.b	a5,a5
 1c2:	4625                	li	a2,9
 1c4:	02f66863          	bltu	a2,a5,1f4 <atoi+0x44>
 1c8:	872a                	mv	a4,a0
  n = 0;
 1ca:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1cc:	0705                	addi	a4,a4,1
 1ce:	0025179b          	slliw	a5,a0,0x2
 1d2:	9fa9                	addw	a5,a5,a0
 1d4:	0017979b          	slliw	a5,a5,0x1
 1d8:	9fb5                	addw	a5,a5,a3
 1da:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1de:	00074683          	lbu	a3,0(a4)
 1e2:	fd06879b          	addiw	a5,a3,-48
 1e6:	0ff7f793          	zext.b	a5,a5
 1ea:	fef671e3          	bgeu	a2,a5,1cc <atoi+0x1c>
  return n;
}
 1ee:	6422                	ld	s0,8(sp)
 1f0:	0141                	addi	sp,sp,16
 1f2:	8082                	ret
  n = 0;
 1f4:	4501                	li	a0,0
 1f6:	bfe5                	j	1ee <atoi+0x3e>

00000000000001f8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1f8:	1141                	addi	sp,sp,-16
 1fa:	e422                	sd	s0,8(sp)
 1fc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1fe:	02b57463          	bgeu	a0,a1,226 <memmove+0x2e>
    while(n-- > 0)
 202:	00c05f63          	blez	a2,220 <memmove+0x28>
 206:	1602                	slli	a2,a2,0x20
 208:	9201                	srli	a2,a2,0x20
 20a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 20e:	872a                	mv	a4,a0
      *dst++ = *src++;
 210:	0585                	addi	a1,a1,1
 212:	0705                	addi	a4,a4,1
 214:	fff5c683          	lbu	a3,-1(a1)
 218:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 21c:	fef71ae3          	bne	a4,a5,210 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 220:	6422                	ld	s0,8(sp)
 222:	0141                	addi	sp,sp,16
 224:	8082                	ret
    dst += n;
 226:	00c50733          	add	a4,a0,a2
    src += n;
 22a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 22c:	fec05ae3          	blez	a2,220 <memmove+0x28>
 230:	fff6079b          	addiw	a5,a2,-1
 234:	1782                	slli	a5,a5,0x20
 236:	9381                	srli	a5,a5,0x20
 238:	fff7c793          	not	a5,a5
 23c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 23e:	15fd                	addi	a1,a1,-1
 240:	177d                	addi	a4,a4,-1
 242:	0005c683          	lbu	a3,0(a1)
 246:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 24a:	fee79ae3          	bne	a5,a4,23e <memmove+0x46>
 24e:	bfc9                	j	220 <memmove+0x28>

0000000000000250 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 250:	1141                	addi	sp,sp,-16
 252:	e422                	sd	s0,8(sp)
 254:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 256:	ca05                	beqz	a2,286 <memcmp+0x36>
 258:	fff6069b          	addiw	a3,a2,-1
 25c:	1682                	slli	a3,a3,0x20
 25e:	9281                	srli	a3,a3,0x20
 260:	0685                	addi	a3,a3,1
 262:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 264:	00054783          	lbu	a5,0(a0)
 268:	0005c703          	lbu	a4,0(a1)
 26c:	00e79863          	bne	a5,a4,27c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 270:	0505                	addi	a0,a0,1
    p2++;
 272:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 274:	fed518e3          	bne	a0,a3,264 <memcmp+0x14>
  }
  return 0;
 278:	4501                	li	a0,0
 27a:	a019                	j	280 <memcmp+0x30>
      return *p1 - *p2;
 27c:	40e7853b          	subw	a0,a5,a4
}
 280:	6422                	ld	s0,8(sp)
 282:	0141                	addi	sp,sp,16
 284:	8082                	ret
  return 0;
 286:	4501                	li	a0,0
 288:	bfe5                	j	280 <memcmp+0x30>

000000000000028a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 28a:	1141                	addi	sp,sp,-16
 28c:	e406                	sd	ra,8(sp)
 28e:	e022                	sd	s0,0(sp)
 290:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 292:	00000097          	auipc	ra,0x0
 296:	f66080e7          	jalr	-154(ra) # 1f8 <memmove>
}
 29a:	60a2                	ld	ra,8(sp)
 29c:	6402                	ld	s0,0(sp)
 29e:	0141                	addi	sp,sp,16
 2a0:	8082                	ret

00000000000002a2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2a2:	4885                	li	a7,1
 ecall
 2a4:	00000073          	ecall
 ret
 2a8:	8082                	ret

00000000000002aa <exit>:
.global exit
exit:
 li a7, SYS_exit
 2aa:	4889                	li	a7,2
 ecall
 2ac:	00000073          	ecall
 ret
 2b0:	8082                	ret

00000000000002b2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2b2:	488d                	li	a7,3
 ecall
 2b4:	00000073          	ecall
 ret
 2b8:	8082                	ret

00000000000002ba <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2ba:	4891                	li	a7,4
 ecall
 2bc:	00000073          	ecall
 ret
 2c0:	8082                	ret

00000000000002c2 <read>:
.global read
read:
 li a7, SYS_read
 2c2:	4895                	li	a7,5
 ecall
 2c4:	00000073          	ecall
 ret
 2c8:	8082                	ret

00000000000002ca <write>:
.global write
write:
 li a7, SYS_write
 2ca:	48c1                	li	a7,16
 ecall
 2cc:	00000073          	ecall
 ret
 2d0:	8082                	ret

00000000000002d2 <close>:
.global close
close:
 li a7, SYS_close
 2d2:	48d5                	li	a7,21
 ecall
 2d4:	00000073          	ecall
 ret
 2d8:	8082                	ret

00000000000002da <kill>:
.global kill
kill:
 li a7, SYS_kill
 2da:	4899                	li	a7,6
 ecall
 2dc:	00000073          	ecall
 ret
 2e0:	8082                	ret

00000000000002e2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2e2:	489d                	li	a7,7
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <open>:
.global open
open:
 li a7, SYS_open
 2ea:	48bd                	li	a7,15
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2f2:	48c5                	li	a7,17
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2fa:	48c9                	li	a7,18
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 302:	48a1                	li	a7,8
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <link>:
.global link
link:
 li a7, SYS_link
 30a:	48cd                	li	a7,19
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 312:	48d1                	li	a7,20
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 31a:	48a5                	li	a7,9
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <dup>:
.global dup
dup:
 li a7, SYS_dup
 322:	48a9                	li	a7,10
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 32a:	48ad                	li	a7,11
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 332:	48b1                	li	a7,12
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 33a:	48b5                	li	a7,13
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 342:	48b9                	li	a7,14
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <yield>:
.global yield
yield:
 li a7, SYS_yield
 34a:	48d9                	li	a7,22
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <lock>:
.global lock
lock:
 li a7, SYS_lock
 352:	48dd                	li	a7,23
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <unlock>:
.global unlock
unlock:
 li a7, SYS_unlock
 35a:	48e1                	li	a7,24
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 362:	1101                	addi	sp,sp,-32
 364:	ec06                	sd	ra,24(sp)
 366:	e822                	sd	s0,16(sp)
 368:	1000                	addi	s0,sp,32
 36a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 36e:	4605                	li	a2,1
 370:	fef40593          	addi	a1,s0,-17
 374:	00000097          	auipc	ra,0x0
 378:	f56080e7          	jalr	-170(ra) # 2ca <write>
}
 37c:	60e2                	ld	ra,24(sp)
 37e:	6442                	ld	s0,16(sp)
 380:	6105                	addi	sp,sp,32
 382:	8082                	ret

0000000000000384 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 384:	7139                	addi	sp,sp,-64
 386:	fc06                	sd	ra,56(sp)
 388:	f822                	sd	s0,48(sp)
 38a:	f426                	sd	s1,40(sp)
 38c:	0080                	addi	s0,sp,64
 38e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 390:	c299                	beqz	a3,396 <printint+0x12>
 392:	0805cb63          	bltz	a1,428 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 396:	2581                	sext.w	a1,a1
  neg = 0;
 398:	4881                	li	a7,0
 39a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 39e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3a0:	2601                	sext.w	a2,a2
 3a2:	00000517          	auipc	a0,0x0
 3a6:	61e50513          	addi	a0,a0,1566 # 9c0 <digits>
 3aa:	883a                	mv	a6,a4
 3ac:	2705                	addiw	a4,a4,1
 3ae:	02c5f7bb          	remuw	a5,a1,a2
 3b2:	1782                	slli	a5,a5,0x20
 3b4:	9381                	srli	a5,a5,0x20
 3b6:	97aa                	add	a5,a5,a0
 3b8:	0007c783          	lbu	a5,0(a5)
 3bc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3c0:	0005879b          	sext.w	a5,a1
 3c4:	02c5d5bb          	divuw	a1,a1,a2
 3c8:	0685                	addi	a3,a3,1
 3ca:	fec7f0e3          	bgeu	a5,a2,3aa <printint+0x26>
  if(neg)
 3ce:	00088c63          	beqz	a7,3e6 <printint+0x62>
    buf[i++] = '-';
 3d2:	fd070793          	addi	a5,a4,-48
 3d6:	00878733          	add	a4,a5,s0
 3da:	02d00793          	li	a5,45
 3de:	fef70823          	sb	a5,-16(a4)
 3e2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3e6:	02e05c63          	blez	a4,41e <printint+0x9a>
 3ea:	f04a                	sd	s2,32(sp)
 3ec:	ec4e                	sd	s3,24(sp)
 3ee:	fc040793          	addi	a5,s0,-64
 3f2:	00e78933          	add	s2,a5,a4
 3f6:	fff78993          	addi	s3,a5,-1
 3fa:	99ba                	add	s3,s3,a4
 3fc:	377d                	addiw	a4,a4,-1
 3fe:	1702                	slli	a4,a4,0x20
 400:	9301                	srli	a4,a4,0x20
 402:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 406:	fff94583          	lbu	a1,-1(s2)
 40a:	8526                	mv	a0,s1
 40c:	00000097          	auipc	ra,0x0
 410:	f56080e7          	jalr	-170(ra) # 362 <putc>
  while(--i >= 0)
 414:	197d                	addi	s2,s2,-1
 416:	ff3918e3          	bne	s2,s3,406 <printint+0x82>
 41a:	7902                	ld	s2,32(sp)
 41c:	69e2                	ld	s3,24(sp)
}
 41e:	70e2                	ld	ra,56(sp)
 420:	7442                	ld	s0,48(sp)
 422:	74a2                	ld	s1,40(sp)
 424:	6121                	addi	sp,sp,64
 426:	8082                	ret
    x = -xx;
 428:	40b005bb          	negw	a1,a1
    neg = 1;
 42c:	4885                	li	a7,1
    x = -xx;
 42e:	b7b5                	j	39a <printint+0x16>

0000000000000430 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 430:	715d                	addi	sp,sp,-80
 432:	e486                	sd	ra,72(sp)
 434:	e0a2                	sd	s0,64(sp)
 436:	f84a                	sd	s2,48(sp)
 438:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 43a:	0005c903          	lbu	s2,0(a1)
 43e:	1a090a63          	beqz	s2,5f2 <vprintf+0x1c2>
 442:	fc26                	sd	s1,56(sp)
 444:	f44e                	sd	s3,40(sp)
 446:	f052                	sd	s4,32(sp)
 448:	ec56                	sd	s5,24(sp)
 44a:	e85a                	sd	s6,16(sp)
 44c:	e45e                	sd	s7,8(sp)
 44e:	8aaa                	mv	s5,a0
 450:	8bb2                	mv	s7,a2
 452:	00158493          	addi	s1,a1,1
  state = 0;
 456:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 458:	02500a13          	li	s4,37
 45c:	4b55                	li	s6,21
 45e:	a839                	j	47c <vprintf+0x4c>
        putc(fd, c);
 460:	85ca                	mv	a1,s2
 462:	8556                	mv	a0,s5
 464:	00000097          	auipc	ra,0x0
 468:	efe080e7          	jalr	-258(ra) # 362 <putc>
 46c:	a019                	j	472 <vprintf+0x42>
    } else if(state == '%'){
 46e:	01498d63          	beq	s3,s4,488 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 472:	0485                	addi	s1,s1,1
 474:	fff4c903          	lbu	s2,-1(s1)
 478:	16090763          	beqz	s2,5e6 <vprintf+0x1b6>
    if(state == 0){
 47c:	fe0999e3          	bnez	s3,46e <vprintf+0x3e>
      if(c == '%'){
 480:	ff4910e3          	bne	s2,s4,460 <vprintf+0x30>
        state = '%';
 484:	89d2                	mv	s3,s4
 486:	b7f5                	j	472 <vprintf+0x42>
      if(c == 'd'){
 488:	13490463          	beq	s2,s4,5b0 <vprintf+0x180>
 48c:	f9d9079b          	addiw	a5,s2,-99
 490:	0ff7f793          	zext.b	a5,a5
 494:	12fb6763          	bltu	s6,a5,5c2 <vprintf+0x192>
 498:	f9d9079b          	addiw	a5,s2,-99
 49c:	0ff7f713          	zext.b	a4,a5
 4a0:	12eb6163          	bltu	s6,a4,5c2 <vprintf+0x192>
 4a4:	00271793          	slli	a5,a4,0x2
 4a8:	00000717          	auipc	a4,0x0
 4ac:	4c070713          	addi	a4,a4,1216 # 968 <malloc+0x150>
 4b0:	97ba                	add	a5,a5,a4
 4b2:	439c                	lw	a5,0(a5)
 4b4:	97ba                	add	a5,a5,a4
 4b6:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4b8:	008b8913          	addi	s2,s7,8
 4bc:	4685                	li	a3,1
 4be:	4629                	li	a2,10
 4c0:	000ba583          	lw	a1,0(s7)
 4c4:	8556                	mv	a0,s5
 4c6:	00000097          	auipc	ra,0x0
 4ca:	ebe080e7          	jalr	-322(ra) # 384 <printint>
 4ce:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4d0:	4981                	li	s3,0
 4d2:	b745                	j	472 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4d4:	008b8913          	addi	s2,s7,8
 4d8:	4681                	li	a3,0
 4da:	4629                	li	a2,10
 4dc:	000ba583          	lw	a1,0(s7)
 4e0:	8556                	mv	a0,s5
 4e2:	00000097          	auipc	ra,0x0
 4e6:	ea2080e7          	jalr	-350(ra) # 384 <printint>
 4ea:	8bca                	mv	s7,s2
      state = 0;
 4ec:	4981                	li	s3,0
 4ee:	b751                	j	472 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 4f0:	008b8913          	addi	s2,s7,8
 4f4:	4681                	li	a3,0
 4f6:	4641                	li	a2,16
 4f8:	000ba583          	lw	a1,0(s7)
 4fc:	8556                	mv	a0,s5
 4fe:	00000097          	auipc	ra,0x0
 502:	e86080e7          	jalr	-378(ra) # 384 <printint>
 506:	8bca                	mv	s7,s2
      state = 0;
 508:	4981                	li	s3,0
 50a:	b7a5                	j	472 <vprintf+0x42>
 50c:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 50e:	008b8c13          	addi	s8,s7,8
 512:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 516:	03000593          	li	a1,48
 51a:	8556                	mv	a0,s5
 51c:	00000097          	auipc	ra,0x0
 520:	e46080e7          	jalr	-442(ra) # 362 <putc>
  putc(fd, 'x');
 524:	07800593          	li	a1,120
 528:	8556                	mv	a0,s5
 52a:	00000097          	auipc	ra,0x0
 52e:	e38080e7          	jalr	-456(ra) # 362 <putc>
 532:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 534:	00000b97          	auipc	s7,0x0
 538:	48cb8b93          	addi	s7,s7,1164 # 9c0 <digits>
 53c:	03c9d793          	srli	a5,s3,0x3c
 540:	97de                	add	a5,a5,s7
 542:	0007c583          	lbu	a1,0(a5)
 546:	8556                	mv	a0,s5
 548:	00000097          	auipc	ra,0x0
 54c:	e1a080e7          	jalr	-486(ra) # 362 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 550:	0992                	slli	s3,s3,0x4
 552:	397d                	addiw	s2,s2,-1
 554:	fe0914e3          	bnez	s2,53c <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 558:	8be2                	mv	s7,s8
      state = 0;
 55a:	4981                	li	s3,0
 55c:	6c02                	ld	s8,0(sp)
 55e:	bf11                	j	472 <vprintf+0x42>
        s = va_arg(ap, char*);
 560:	008b8993          	addi	s3,s7,8
 564:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 568:	02090163          	beqz	s2,58a <vprintf+0x15a>
        while(*s != 0){
 56c:	00094583          	lbu	a1,0(s2)
 570:	c9a5                	beqz	a1,5e0 <vprintf+0x1b0>
          putc(fd, *s);
 572:	8556                	mv	a0,s5
 574:	00000097          	auipc	ra,0x0
 578:	dee080e7          	jalr	-530(ra) # 362 <putc>
          s++;
 57c:	0905                	addi	s2,s2,1
        while(*s != 0){
 57e:	00094583          	lbu	a1,0(s2)
 582:	f9e5                	bnez	a1,572 <vprintf+0x142>
        s = va_arg(ap, char*);
 584:	8bce                	mv	s7,s3
      state = 0;
 586:	4981                	li	s3,0
 588:	b5ed                	j	472 <vprintf+0x42>
          s = "(null)";
 58a:	00000917          	auipc	s2,0x0
 58e:	3d690913          	addi	s2,s2,982 # 960 <malloc+0x148>
        while(*s != 0){
 592:	02800593          	li	a1,40
 596:	bff1                	j	572 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 598:	008b8913          	addi	s2,s7,8
 59c:	000bc583          	lbu	a1,0(s7)
 5a0:	8556                	mv	a0,s5
 5a2:	00000097          	auipc	ra,0x0
 5a6:	dc0080e7          	jalr	-576(ra) # 362 <putc>
 5aa:	8bca                	mv	s7,s2
      state = 0;
 5ac:	4981                	li	s3,0
 5ae:	b5d1                	j	472 <vprintf+0x42>
        putc(fd, c);
 5b0:	02500593          	li	a1,37
 5b4:	8556                	mv	a0,s5
 5b6:	00000097          	auipc	ra,0x0
 5ba:	dac080e7          	jalr	-596(ra) # 362 <putc>
      state = 0;
 5be:	4981                	li	s3,0
 5c0:	bd4d                	j	472 <vprintf+0x42>
        putc(fd, '%');
 5c2:	02500593          	li	a1,37
 5c6:	8556                	mv	a0,s5
 5c8:	00000097          	auipc	ra,0x0
 5cc:	d9a080e7          	jalr	-614(ra) # 362 <putc>
        putc(fd, c);
 5d0:	85ca                	mv	a1,s2
 5d2:	8556                	mv	a0,s5
 5d4:	00000097          	auipc	ra,0x0
 5d8:	d8e080e7          	jalr	-626(ra) # 362 <putc>
      state = 0;
 5dc:	4981                	li	s3,0
 5de:	bd51                	j	472 <vprintf+0x42>
        s = va_arg(ap, char*);
 5e0:	8bce                	mv	s7,s3
      state = 0;
 5e2:	4981                	li	s3,0
 5e4:	b579                	j	472 <vprintf+0x42>
 5e6:	74e2                	ld	s1,56(sp)
 5e8:	79a2                	ld	s3,40(sp)
 5ea:	7a02                	ld	s4,32(sp)
 5ec:	6ae2                	ld	s5,24(sp)
 5ee:	6b42                	ld	s6,16(sp)
 5f0:	6ba2                	ld	s7,8(sp)
    }
  }
}
 5f2:	60a6                	ld	ra,72(sp)
 5f4:	6406                	ld	s0,64(sp)
 5f6:	7942                	ld	s2,48(sp)
 5f8:	6161                	addi	sp,sp,80
 5fa:	8082                	ret

00000000000005fc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5fc:	715d                	addi	sp,sp,-80
 5fe:	ec06                	sd	ra,24(sp)
 600:	e822                	sd	s0,16(sp)
 602:	1000                	addi	s0,sp,32
 604:	e010                	sd	a2,0(s0)
 606:	e414                	sd	a3,8(s0)
 608:	e818                	sd	a4,16(s0)
 60a:	ec1c                	sd	a5,24(s0)
 60c:	03043023          	sd	a6,32(s0)
 610:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 614:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 618:	8622                	mv	a2,s0
 61a:	00000097          	auipc	ra,0x0
 61e:	e16080e7          	jalr	-490(ra) # 430 <vprintf>
}
 622:	60e2                	ld	ra,24(sp)
 624:	6442                	ld	s0,16(sp)
 626:	6161                	addi	sp,sp,80
 628:	8082                	ret

000000000000062a <printf>:

void
printf(const char *fmt, ...)
{
 62a:	7159                	addi	sp,sp,-112
 62c:	f406                	sd	ra,40(sp)
 62e:	f022                	sd	s0,32(sp)
 630:	ec26                	sd	s1,24(sp)
 632:	1800                	addi	s0,sp,48
 634:	84aa                	mv	s1,a0
 636:	e40c                	sd	a1,8(s0)
 638:	e810                	sd	a2,16(s0)
 63a:	ec14                	sd	a3,24(s0)
 63c:	f018                	sd	a4,32(s0)
 63e:	f41c                	sd	a5,40(s0)
 640:	03043823          	sd	a6,48(s0)
 644:	03143c23          	sd	a7,56(s0)
  va_list ap;

  lock();
 648:	00000097          	auipc	ra,0x0
 64c:	d0a080e7          	jalr	-758(ra) # 352 <lock>
  va_start(ap, fmt);
 650:	00840613          	addi	a2,s0,8
 654:	fcc43c23          	sd	a2,-40(s0)
  vprintf(1, fmt, ap);
 658:	85a6                	mv	a1,s1
 65a:	4505                	li	a0,1
 65c:	00000097          	auipc	ra,0x0
 660:	dd4080e7          	jalr	-556(ra) # 430 <vprintf>
  unlock();
 664:	00000097          	auipc	ra,0x0
 668:	cf6080e7          	jalr	-778(ra) # 35a <unlock>
}
 66c:	70a2                	ld	ra,40(sp)
 66e:	7402                	ld	s0,32(sp)
 670:	64e2                	ld	s1,24(sp)
 672:	6165                	addi	sp,sp,112
 674:	8082                	ret

0000000000000676 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 676:	7179                	addi	sp,sp,-48
 678:	f422                	sd	s0,40(sp)
 67a:	1800                	addi	s0,sp,48
 67c:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 680:	fd843783          	ld	a5,-40(s0)
 684:	17c1                	addi	a5,a5,-16
 686:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 68a:	00001797          	auipc	a5,0x1
 68e:	d4678793          	addi	a5,a5,-698 # 13d0 <freep>
 692:	639c                	ld	a5,0(a5)
 694:	fef43423          	sd	a5,-24(s0)
 698:	a815                	j	6cc <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 69a:	fe843783          	ld	a5,-24(s0)
 69e:	639c                	ld	a5,0(a5)
 6a0:	fe843703          	ld	a4,-24(s0)
 6a4:	00f76f63          	bltu	a4,a5,6c2 <free+0x4c>
 6a8:	fe043703          	ld	a4,-32(s0)
 6ac:	fe843783          	ld	a5,-24(s0)
 6b0:	02e7eb63          	bltu	a5,a4,6e6 <free+0x70>
 6b4:	fe843783          	ld	a5,-24(s0)
 6b8:	639c                	ld	a5,0(a5)
 6ba:	fe043703          	ld	a4,-32(s0)
 6be:	02f76463          	bltu	a4,a5,6e6 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c2:	fe843783          	ld	a5,-24(s0)
 6c6:	639c                	ld	a5,0(a5)
 6c8:	fef43423          	sd	a5,-24(s0)
 6cc:	fe043703          	ld	a4,-32(s0)
 6d0:	fe843783          	ld	a5,-24(s0)
 6d4:	fce7f3e3          	bgeu	a5,a4,69a <free+0x24>
 6d8:	fe843783          	ld	a5,-24(s0)
 6dc:	639c                	ld	a5,0(a5)
 6de:	fe043703          	ld	a4,-32(s0)
 6e2:	faf77ce3          	bgeu	a4,a5,69a <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6e6:	fe043783          	ld	a5,-32(s0)
 6ea:	479c                	lw	a5,8(a5)
 6ec:	1782                	slli	a5,a5,0x20
 6ee:	9381                	srli	a5,a5,0x20
 6f0:	0792                	slli	a5,a5,0x4
 6f2:	fe043703          	ld	a4,-32(s0)
 6f6:	973e                	add	a4,a4,a5
 6f8:	fe843783          	ld	a5,-24(s0)
 6fc:	639c                	ld	a5,0(a5)
 6fe:	02f71763          	bne	a4,a5,72c <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 702:	fe043783          	ld	a5,-32(s0)
 706:	4798                	lw	a4,8(a5)
 708:	fe843783          	ld	a5,-24(s0)
 70c:	639c                	ld	a5,0(a5)
 70e:	479c                	lw	a5,8(a5)
 710:	9fb9                	addw	a5,a5,a4
 712:	0007871b          	sext.w	a4,a5
 716:	fe043783          	ld	a5,-32(s0)
 71a:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 71c:	fe843783          	ld	a5,-24(s0)
 720:	639c                	ld	a5,0(a5)
 722:	6398                	ld	a4,0(a5)
 724:	fe043783          	ld	a5,-32(s0)
 728:	e398                	sd	a4,0(a5)
 72a:	a039                	j	738 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 72c:	fe843783          	ld	a5,-24(s0)
 730:	6398                	ld	a4,0(a5)
 732:	fe043783          	ld	a5,-32(s0)
 736:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 738:	fe843783          	ld	a5,-24(s0)
 73c:	479c                	lw	a5,8(a5)
 73e:	1782                	slli	a5,a5,0x20
 740:	9381                	srli	a5,a5,0x20
 742:	0792                	slli	a5,a5,0x4
 744:	fe843703          	ld	a4,-24(s0)
 748:	97ba                	add	a5,a5,a4
 74a:	fe043703          	ld	a4,-32(s0)
 74e:	02f71563          	bne	a4,a5,778 <free+0x102>
    p->s.size += bp->s.size;
 752:	fe843783          	ld	a5,-24(s0)
 756:	4798                	lw	a4,8(a5)
 758:	fe043783          	ld	a5,-32(s0)
 75c:	479c                	lw	a5,8(a5)
 75e:	9fb9                	addw	a5,a5,a4
 760:	0007871b          	sext.w	a4,a5
 764:	fe843783          	ld	a5,-24(s0)
 768:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 76a:	fe043783          	ld	a5,-32(s0)
 76e:	6398                	ld	a4,0(a5)
 770:	fe843783          	ld	a5,-24(s0)
 774:	e398                	sd	a4,0(a5)
 776:	a031                	j	782 <free+0x10c>
  } else
    p->s.ptr = bp;
 778:	fe843783          	ld	a5,-24(s0)
 77c:	fe043703          	ld	a4,-32(s0)
 780:	e398                	sd	a4,0(a5)
  freep = p;
 782:	00001797          	auipc	a5,0x1
 786:	c4e78793          	addi	a5,a5,-946 # 13d0 <freep>
 78a:	fe843703          	ld	a4,-24(s0)
 78e:	e398                	sd	a4,0(a5)
}
 790:	0001                	nop
 792:	7422                	ld	s0,40(sp)
 794:	6145                	addi	sp,sp,48
 796:	8082                	ret

0000000000000798 <morecore>:

static Header*
morecore(uint nu)
{
 798:	7179                	addi	sp,sp,-48
 79a:	f406                	sd	ra,40(sp)
 79c:	f022                	sd	s0,32(sp)
 79e:	1800                	addi	s0,sp,48
 7a0:	87aa                	mv	a5,a0
 7a2:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 7a6:	fdc42783          	lw	a5,-36(s0)
 7aa:	0007871b          	sext.w	a4,a5
 7ae:	6785                	lui	a5,0x1
 7b0:	00f77563          	bgeu	a4,a5,7ba <morecore+0x22>
    nu = 4096;
 7b4:	6785                	lui	a5,0x1
 7b6:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 7ba:	fdc42783          	lw	a5,-36(s0)
 7be:	0047979b          	slliw	a5,a5,0x4
 7c2:	2781                	sext.w	a5,a5
 7c4:	2781                	sext.w	a5,a5
 7c6:	853e                	mv	a0,a5
 7c8:	00000097          	auipc	ra,0x0
 7cc:	b6a080e7          	jalr	-1174(ra) # 332 <sbrk>
 7d0:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 7d4:	fe843703          	ld	a4,-24(s0)
 7d8:	57fd                	li	a5,-1
 7da:	00f71463          	bne	a4,a5,7e2 <morecore+0x4a>
    return 0;
 7de:	4781                	li	a5,0
 7e0:	a03d                	j	80e <morecore+0x76>
  hp = (Header*)p;
 7e2:	fe843783          	ld	a5,-24(s0)
 7e6:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 7ea:	fe043783          	ld	a5,-32(s0)
 7ee:	fdc42703          	lw	a4,-36(s0)
 7f2:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 7f4:	fe043783          	ld	a5,-32(s0)
 7f8:	07c1                	addi	a5,a5,16 # 1010 <digits+0x650>
 7fa:	853e                	mv	a0,a5
 7fc:	00000097          	auipc	ra,0x0
 800:	e7a080e7          	jalr	-390(ra) # 676 <free>
  return freep;
 804:	00001797          	auipc	a5,0x1
 808:	bcc78793          	addi	a5,a5,-1076 # 13d0 <freep>
 80c:	639c                	ld	a5,0(a5)
}
 80e:	853e                	mv	a0,a5
 810:	70a2                	ld	ra,40(sp)
 812:	7402                	ld	s0,32(sp)
 814:	6145                	addi	sp,sp,48
 816:	8082                	ret

0000000000000818 <malloc>:

void*
malloc(uint nbytes)
{
 818:	7139                	addi	sp,sp,-64
 81a:	fc06                	sd	ra,56(sp)
 81c:	f822                	sd	s0,48(sp)
 81e:	0080                	addi	s0,sp,64
 820:	87aa                	mv	a5,a0
 822:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 826:	fcc46783          	lwu	a5,-52(s0)
 82a:	07bd                	addi	a5,a5,15
 82c:	8391                	srli	a5,a5,0x4
 82e:	2781                	sext.w	a5,a5
 830:	2785                	addiw	a5,a5,1
 832:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 836:	00001797          	auipc	a5,0x1
 83a:	b9a78793          	addi	a5,a5,-1126 # 13d0 <freep>
 83e:	639c                	ld	a5,0(a5)
 840:	fef43023          	sd	a5,-32(s0)
 844:	fe043783          	ld	a5,-32(s0)
 848:	ef95                	bnez	a5,884 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 84a:	00001797          	auipc	a5,0x1
 84e:	b7678793          	addi	a5,a5,-1162 # 13c0 <base>
 852:	fef43023          	sd	a5,-32(s0)
 856:	00001797          	auipc	a5,0x1
 85a:	b7a78793          	addi	a5,a5,-1158 # 13d0 <freep>
 85e:	fe043703          	ld	a4,-32(s0)
 862:	e398                	sd	a4,0(a5)
 864:	00001797          	auipc	a5,0x1
 868:	b6c78793          	addi	a5,a5,-1172 # 13d0 <freep>
 86c:	6398                	ld	a4,0(a5)
 86e:	00001797          	auipc	a5,0x1
 872:	b5278793          	addi	a5,a5,-1198 # 13c0 <base>
 876:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 878:	00001797          	auipc	a5,0x1
 87c:	b4878793          	addi	a5,a5,-1208 # 13c0 <base>
 880:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 884:	fe043783          	ld	a5,-32(s0)
 888:	639c                	ld	a5,0(a5)
 88a:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 88e:	fe843783          	ld	a5,-24(s0)
 892:	4798                	lw	a4,8(a5)
 894:	fdc42783          	lw	a5,-36(s0)
 898:	2781                	sext.w	a5,a5
 89a:	06f76763          	bltu	a4,a5,908 <malloc+0xf0>
      if(p->s.size == nunits)
 89e:	fe843783          	ld	a5,-24(s0)
 8a2:	4798                	lw	a4,8(a5)
 8a4:	fdc42783          	lw	a5,-36(s0)
 8a8:	2781                	sext.w	a5,a5
 8aa:	00e79963          	bne	a5,a4,8bc <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 8ae:	fe843783          	ld	a5,-24(s0)
 8b2:	6398                	ld	a4,0(a5)
 8b4:	fe043783          	ld	a5,-32(s0)
 8b8:	e398                	sd	a4,0(a5)
 8ba:	a825                	j	8f2 <malloc+0xda>
      else {
        p->s.size -= nunits;
 8bc:	fe843783          	ld	a5,-24(s0)
 8c0:	479c                	lw	a5,8(a5)
 8c2:	fdc42703          	lw	a4,-36(s0)
 8c6:	9f99                	subw	a5,a5,a4
 8c8:	0007871b          	sext.w	a4,a5
 8cc:	fe843783          	ld	a5,-24(s0)
 8d0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8d2:	fe843783          	ld	a5,-24(s0)
 8d6:	479c                	lw	a5,8(a5)
 8d8:	1782                	slli	a5,a5,0x20
 8da:	9381                	srli	a5,a5,0x20
 8dc:	0792                	slli	a5,a5,0x4
 8de:	fe843703          	ld	a4,-24(s0)
 8e2:	97ba                	add	a5,a5,a4
 8e4:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 8e8:	fe843783          	ld	a5,-24(s0)
 8ec:	fdc42703          	lw	a4,-36(s0)
 8f0:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 8f2:	00001797          	auipc	a5,0x1
 8f6:	ade78793          	addi	a5,a5,-1314 # 13d0 <freep>
 8fa:	fe043703          	ld	a4,-32(s0)
 8fe:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 900:	fe843783          	ld	a5,-24(s0)
 904:	07c1                	addi	a5,a5,16
 906:	a091                	j	94a <malloc+0x132>
    }
    if(p == freep)
 908:	00001797          	auipc	a5,0x1
 90c:	ac878793          	addi	a5,a5,-1336 # 13d0 <freep>
 910:	639c                	ld	a5,0(a5)
 912:	fe843703          	ld	a4,-24(s0)
 916:	02f71063          	bne	a4,a5,936 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 91a:	fdc42783          	lw	a5,-36(s0)
 91e:	853e                	mv	a0,a5
 920:	00000097          	auipc	ra,0x0
 924:	e78080e7          	jalr	-392(ra) # 798 <morecore>
 928:	fea43423          	sd	a0,-24(s0)
 92c:	fe843783          	ld	a5,-24(s0)
 930:	e399                	bnez	a5,936 <malloc+0x11e>
        return 0;
 932:	4781                	li	a5,0
 934:	a819                	j	94a <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 936:	fe843783          	ld	a5,-24(s0)
 93a:	fef43023          	sd	a5,-32(s0)
 93e:	fe843783          	ld	a5,-24(s0)
 942:	639c                	ld	a5,0(a5)
 944:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 948:	b799                	j	88e <malloc+0x76>
  }
}
 94a:	853e                	mv	a0,a5
 94c:	70e2                	ld	ra,56(sp)
 94e:	7442                	ld	s0,48(sp)
 950:	6121                	addi	sp,sp,64
 952:	8082                	ret
