
user/_loop:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[]){
   0:	1101                	addi	sp,sp,-32
   2:	ec22                	sd	s0,24(sp)
   4:	1000                	addi	s0,sp,32
   6:	87aa                	mv	a5,a0
   8:	feb43023          	sd	a1,-32(s0)
   c:	fef42623          	sw	a5,-20(s0)
    while(1){
  10:	0001                	nop
  12:	bffd                	j	10 <main+0x10>

0000000000000014 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  14:	1141                	addi	sp,sp,-16
  16:	e406                	sd	ra,8(sp)
  18:	e022                	sd	s0,0(sp)
  1a:	0800                	addi	s0,sp,16
  extern int main();
  main();
  1c:	00000097          	auipc	ra,0x0
  20:	fe4080e7          	jalr	-28(ra) # 0 <main>
  exit(0);
  24:	4501                	li	a0,0
  26:	00000097          	auipc	ra,0x0
  2a:	274080e7          	jalr	628(ra) # 29a <exit>

000000000000002e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  2e:	1141                	addi	sp,sp,-16
  30:	e422                	sd	s0,8(sp)
  32:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  34:	87aa                	mv	a5,a0
  36:	0585                	addi	a1,a1,1
  38:	0785                	addi	a5,a5,1
  3a:	fff5c703          	lbu	a4,-1(a1)
  3e:	fee78fa3          	sb	a4,-1(a5)
  42:	fb75                	bnez	a4,36 <strcpy+0x8>
    ;
  return os;
}
  44:	6422                	ld	s0,8(sp)
  46:	0141                	addi	sp,sp,16
  48:	8082                	ret

000000000000004a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4a:	1141                	addi	sp,sp,-16
  4c:	e422                	sd	s0,8(sp)
  4e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  50:	00054783          	lbu	a5,0(a0)
  54:	cb91                	beqz	a5,68 <strcmp+0x1e>
  56:	0005c703          	lbu	a4,0(a1)
  5a:	00f71763          	bne	a4,a5,68 <strcmp+0x1e>
    p++, q++;
  5e:	0505                	addi	a0,a0,1
  60:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  62:	00054783          	lbu	a5,0(a0)
  66:	fbe5                	bnez	a5,56 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  68:	0005c503          	lbu	a0,0(a1)
}
  6c:	40a7853b          	subw	a0,a5,a0
  70:	6422                	ld	s0,8(sp)
  72:	0141                	addi	sp,sp,16
  74:	8082                	ret

0000000000000076 <strlen>:

uint
strlen(const char *s)
{
  76:	1141                	addi	sp,sp,-16
  78:	e422                	sd	s0,8(sp)
  7a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  7c:	00054783          	lbu	a5,0(a0)
  80:	cf91                	beqz	a5,9c <strlen+0x26>
  82:	0505                	addi	a0,a0,1
  84:	87aa                	mv	a5,a0
  86:	86be                	mv	a3,a5
  88:	0785                	addi	a5,a5,1
  8a:	fff7c703          	lbu	a4,-1(a5)
  8e:	ff65                	bnez	a4,86 <strlen+0x10>
  90:	40a6853b          	subw	a0,a3,a0
  94:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  96:	6422                	ld	s0,8(sp)
  98:	0141                	addi	sp,sp,16
  9a:	8082                	ret
  for(n = 0; s[n]; n++)
  9c:	4501                	li	a0,0
  9e:	bfe5                	j	96 <strlen+0x20>

00000000000000a0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a0:	1141                	addi	sp,sp,-16
  a2:	e422                	sd	s0,8(sp)
  a4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a6:	ca19                	beqz	a2,bc <memset+0x1c>
  a8:	87aa                	mv	a5,a0
  aa:	1602                	slli	a2,a2,0x20
  ac:	9201                	srli	a2,a2,0x20
  ae:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  b2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b6:	0785                	addi	a5,a5,1
  b8:	fee79de3          	bne	a5,a4,b2 <memset+0x12>
  }
  return dst;
}
  bc:	6422                	ld	s0,8(sp)
  be:	0141                	addi	sp,sp,16
  c0:	8082                	ret

00000000000000c2 <strchr>:

char*
strchr(const char *s, char c)
{
  c2:	1141                	addi	sp,sp,-16
  c4:	e422                	sd	s0,8(sp)
  c6:	0800                	addi	s0,sp,16
  for(; *s; s++)
  c8:	00054783          	lbu	a5,0(a0)
  cc:	cb99                	beqz	a5,e2 <strchr+0x20>
    if(*s == c)
  ce:	00f58763          	beq	a1,a5,dc <strchr+0x1a>
  for(; *s; s++)
  d2:	0505                	addi	a0,a0,1
  d4:	00054783          	lbu	a5,0(a0)
  d8:	fbfd                	bnez	a5,ce <strchr+0xc>
      return (char*)s;
  return 0;
  da:	4501                	li	a0,0
}
  dc:	6422                	ld	s0,8(sp)
  de:	0141                	addi	sp,sp,16
  e0:	8082                	ret
  return 0;
  e2:	4501                	li	a0,0
  e4:	bfe5                	j	dc <strchr+0x1a>

00000000000000e6 <gets>:

char*
gets(char *buf, int max)
{
  e6:	711d                	addi	sp,sp,-96
  e8:	ec86                	sd	ra,88(sp)
  ea:	e8a2                	sd	s0,80(sp)
  ec:	e4a6                	sd	s1,72(sp)
  ee:	e0ca                	sd	s2,64(sp)
  f0:	fc4e                	sd	s3,56(sp)
  f2:	f852                	sd	s4,48(sp)
  f4:	f456                	sd	s5,40(sp)
  f6:	f05a                	sd	s6,32(sp)
  f8:	ec5e                	sd	s7,24(sp)
  fa:	1080                	addi	s0,sp,96
  fc:	8baa                	mv	s7,a0
  fe:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 100:	892a                	mv	s2,a0
 102:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 104:	4aa9                	li	s5,10
 106:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 108:	89a6                	mv	s3,s1
 10a:	2485                	addiw	s1,s1,1
 10c:	0344d863          	bge	s1,s4,13c <gets+0x56>
    cc = read(0, &c, 1);
 110:	4605                	li	a2,1
 112:	faf40593          	addi	a1,s0,-81
 116:	4501                	li	a0,0
 118:	00000097          	auipc	ra,0x0
 11c:	19a080e7          	jalr	410(ra) # 2b2 <read>
    if(cc < 1)
 120:	00a05e63          	blez	a0,13c <gets+0x56>
    buf[i++] = c;
 124:	faf44783          	lbu	a5,-81(s0)
 128:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 12c:	01578763          	beq	a5,s5,13a <gets+0x54>
 130:	0905                	addi	s2,s2,1
 132:	fd679be3          	bne	a5,s6,108 <gets+0x22>
    buf[i++] = c;
 136:	89a6                	mv	s3,s1
 138:	a011                	j	13c <gets+0x56>
 13a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 13c:	99de                	add	s3,s3,s7
 13e:	00098023          	sb	zero,0(s3)
  return buf;
}
 142:	855e                	mv	a0,s7
 144:	60e6                	ld	ra,88(sp)
 146:	6446                	ld	s0,80(sp)
 148:	64a6                	ld	s1,72(sp)
 14a:	6906                	ld	s2,64(sp)
 14c:	79e2                	ld	s3,56(sp)
 14e:	7a42                	ld	s4,48(sp)
 150:	7aa2                	ld	s5,40(sp)
 152:	7b02                	ld	s6,32(sp)
 154:	6be2                	ld	s7,24(sp)
 156:	6125                	addi	sp,sp,96
 158:	8082                	ret

000000000000015a <stat>:

int
stat(const char *n, struct stat *st)
{
 15a:	1101                	addi	sp,sp,-32
 15c:	ec06                	sd	ra,24(sp)
 15e:	e822                	sd	s0,16(sp)
 160:	e04a                	sd	s2,0(sp)
 162:	1000                	addi	s0,sp,32
 164:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 166:	4581                	li	a1,0
 168:	00000097          	auipc	ra,0x0
 16c:	172080e7          	jalr	370(ra) # 2da <open>
  if(fd < 0)
 170:	02054663          	bltz	a0,19c <stat+0x42>
 174:	e426                	sd	s1,8(sp)
 176:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 178:	85ca                	mv	a1,s2
 17a:	00000097          	auipc	ra,0x0
 17e:	178080e7          	jalr	376(ra) # 2f2 <fstat>
 182:	892a                	mv	s2,a0
  close(fd);
 184:	8526                	mv	a0,s1
 186:	00000097          	auipc	ra,0x0
 18a:	13c080e7          	jalr	316(ra) # 2c2 <close>
  return r;
 18e:	64a2                	ld	s1,8(sp)
}
 190:	854a                	mv	a0,s2
 192:	60e2                	ld	ra,24(sp)
 194:	6442                	ld	s0,16(sp)
 196:	6902                	ld	s2,0(sp)
 198:	6105                	addi	sp,sp,32
 19a:	8082                	ret
    return -1;
 19c:	597d                	li	s2,-1
 19e:	bfcd                	j	190 <stat+0x36>

00000000000001a0 <atoi>:

int
atoi(const char *s)
{
 1a0:	1141                	addi	sp,sp,-16
 1a2:	e422                	sd	s0,8(sp)
 1a4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1a6:	00054683          	lbu	a3,0(a0)
 1aa:	fd06879b          	addiw	a5,a3,-48
 1ae:	0ff7f793          	zext.b	a5,a5
 1b2:	4625                	li	a2,9
 1b4:	02f66863          	bltu	a2,a5,1e4 <atoi+0x44>
 1b8:	872a                	mv	a4,a0
  n = 0;
 1ba:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1bc:	0705                	addi	a4,a4,1
 1be:	0025179b          	slliw	a5,a0,0x2
 1c2:	9fa9                	addw	a5,a5,a0
 1c4:	0017979b          	slliw	a5,a5,0x1
 1c8:	9fb5                	addw	a5,a5,a3
 1ca:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1ce:	00074683          	lbu	a3,0(a4)
 1d2:	fd06879b          	addiw	a5,a3,-48
 1d6:	0ff7f793          	zext.b	a5,a5
 1da:	fef671e3          	bgeu	a2,a5,1bc <atoi+0x1c>
  return n;
}
 1de:	6422                	ld	s0,8(sp)
 1e0:	0141                	addi	sp,sp,16
 1e2:	8082                	ret
  n = 0;
 1e4:	4501                	li	a0,0
 1e6:	bfe5                	j	1de <atoi+0x3e>

00000000000001e8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1e8:	1141                	addi	sp,sp,-16
 1ea:	e422                	sd	s0,8(sp)
 1ec:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1ee:	02b57463          	bgeu	a0,a1,216 <memmove+0x2e>
    while(n-- > 0)
 1f2:	00c05f63          	blez	a2,210 <memmove+0x28>
 1f6:	1602                	slli	a2,a2,0x20
 1f8:	9201                	srli	a2,a2,0x20
 1fa:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1fe:	872a                	mv	a4,a0
      *dst++ = *src++;
 200:	0585                	addi	a1,a1,1
 202:	0705                	addi	a4,a4,1
 204:	fff5c683          	lbu	a3,-1(a1)
 208:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 20c:	fef71ae3          	bne	a4,a5,200 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 210:	6422                	ld	s0,8(sp)
 212:	0141                	addi	sp,sp,16
 214:	8082                	ret
    dst += n;
 216:	00c50733          	add	a4,a0,a2
    src += n;
 21a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 21c:	fec05ae3          	blez	a2,210 <memmove+0x28>
 220:	fff6079b          	addiw	a5,a2,-1
 224:	1782                	slli	a5,a5,0x20
 226:	9381                	srli	a5,a5,0x20
 228:	fff7c793          	not	a5,a5
 22c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 22e:	15fd                	addi	a1,a1,-1
 230:	177d                	addi	a4,a4,-1
 232:	0005c683          	lbu	a3,0(a1)
 236:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 23a:	fee79ae3          	bne	a5,a4,22e <memmove+0x46>
 23e:	bfc9                	j	210 <memmove+0x28>

0000000000000240 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 240:	1141                	addi	sp,sp,-16
 242:	e422                	sd	s0,8(sp)
 244:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 246:	ca05                	beqz	a2,276 <memcmp+0x36>
 248:	fff6069b          	addiw	a3,a2,-1
 24c:	1682                	slli	a3,a3,0x20
 24e:	9281                	srli	a3,a3,0x20
 250:	0685                	addi	a3,a3,1
 252:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 254:	00054783          	lbu	a5,0(a0)
 258:	0005c703          	lbu	a4,0(a1)
 25c:	00e79863          	bne	a5,a4,26c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 260:	0505                	addi	a0,a0,1
    p2++;
 262:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 264:	fed518e3          	bne	a0,a3,254 <memcmp+0x14>
  }
  return 0;
 268:	4501                	li	a0,0
 26a:	a019                	j	270 <memcmp+0x30>
      return *p1 - *p2;
 26c:	40e7853b          	subw	a0,a5,a4
}
 270:	6422                	ld	s0,8(sp)
 272:	0141                	addi	sp,sp,16
 274:	8082                	ret
  return 0;
 276:	4501                	li	a0,0
 278:	bfe5                	j	270 <memcmp+0x30>

000000000000027a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 27a:	1141                	addi	sp,sp,-16
 27c:	e406                	sd	ra,8(sp)
 27e:	e022                	sd	s0,0(sp)
 280:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 282:	00000097          	auipc	ra,0x0
 286:	f66080e7          	jalr	-154(ra) # 1e8 <memmove>
}
 28a:	60a2                	ld	ra,8(sp)
 28c:	6402                	ld	s0,0(sp)
 28e:	0141                	addi	sp,sp,16
 290:	8082                	ret

0000000000000292 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 292:	4885                	li	a7,1
 ecall
 294:	00000073          	ecall
 ret
 298:	8082                	ret

000000000000029a <exit>:
.global exit
exit:
 li a7, SYS_exit
 29a:	4889                	li	a7,2
 ecall
 29c:	00000073          	ecall
 ret
 2a0:	8082                	ret

00000000000002a2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2a2:	488d                	li	a7,3
 ecall
 2a4:	00000073          	ecall
 ret
 2a8:	8082                	ret

00000000000002aa <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2aa:	4891                	li	a7,4
 ecall
 2ac:	00000073          	ecall
 ret
 2b0:	8082                	ret

00000000000002b2 <read>:
.global read
read:
 li a7, SYS_read
 2b2:	4895                	li	a7,5
 ecall
 2b4:	00000073          	ecall
 ret
 2b8:	8082                	ret

00000000000002ba <write>:
.global write
write:
 li a7, SYS_write
 2ba:	48c1                	li	a7,16
 ecall
 2bc:	00000073          	ecall
 ret
 2c0:	8082                	ret

00000000000002c2 <close>:
.global close
close:
 li a7, SYS_close
 2c2:	48d5                	li	a7,21
 ecall
 2c4:	00000073          	ecall
 ret
 2c8:	8082                	ret

00000000000002ca <kill>:
.global kill
kill:
 li a7, SYS_kill
 2ca:	4899                	li	a7,6
 ecall
 2cc:	00000073          	ecall
 ret
 2d0:	8082                	ret

00000000000002d2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2d2:	489d                	li	a7,7
 ecall
 2d4:	00000073          	ecall
 ret
 2d8:	8082                	ret

00000000000002da <open>:
.global open
open:
 li a7, SYS_open
 2da:	48bd                	li	a7,15
 ecall
 2dc:	00000073          	ecall
 ret
 2e0:	8082                	ret

00000000000002e2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2e2:	48c5                	li	a7,17
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2ea:	48c9                	li	a7,18
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2f2:	48a1                	li	a7,8
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <link>:
.global link
link:
 li a7, SYS_link
 2fa:	48cd                	li	a7,19
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 302:	48d1                	li	a7,20
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 30a:	48a5                	li	a7,9
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <dup>:
.global dup
dup:
 li a7, SYS_dup
 312:	48a9                	li	a7,10
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 31a:	48ad                	li	a7,11
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 322:	48b1                	li	a7,12
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 32a:	48b5                	li	a7,13
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 332:	48b9                	li	a7,14
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <yield>:
.global yield
yield:
 li a7, SYS_yield
 33a:	48d9                	li	a7,22
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <lock>:
.global lock
lock:
 li a7, SYS_lock
 342:	48dd                	li	a7,23
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <unlock>:
.global unlock
unlock:
 li a7, SYS_unlock
 34a:	48e1                	li	a7,24
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 352:	1101                	addi	sp,sp,-32
 354:	ec06                	sd	ra,24(sp)
 356:	e822                	sd	s0,16(sp)
 358:	1000                	addi	s0,sp,32
 35a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 35e:	4605                	li	a2,1
 360:	fef40593          	addi	a1,s0,-17
 364:	00000097          	auipc	ra,0x0
 368:	f56080e7          	jalr	-170(ra) # 2ba <write>
}
 36c:	60e2                	ld	ra,24(sp)
 36e:	6442                	ld	s0,16(sp)
 370:	6105                	addi	sp,sp,32
 372:	8082                	ret

0000000000000374 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 374:	7139                	addi	sp,sp,-64
 376:	fc06                	sd	ra,56(sp)
 378:	f822                	sd	s0,48(sp)
 37a:	f426                	sd	s1,40(sp)
 37c:	0080                	addi	s0,sp,64
 37e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 380:	c299                	beqz	a3,386 <printint+0x12>
 382:	0805cb63          	bltz	a1,418 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 386:	2581                	sext.w	a1,a1
  neg = 0;
 388:	4881                	li	a7,0
 38a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 38e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 390:	2601                	sext.w	a2,a2
 392:	00000517          	auipc	a0,0x0
 396:	61e50513          	addi	a0,a0,1566 # 9b0 <digits>
 39a:	883a                	mv	a6,a4
 39c:	2705                	addiw	a4,a4,1
 39e:	02c5f7bb          	remuw	a5,a1,a2
 3a2:	1782                	slli	a5,a5,0x20
 3a4:	9381                	srli	a5,a5,0x20
 3a6:	97aa                	add	a5,a5,a0
 3a8:	0007c783          	lbu	a5,0(a5)
 3ac:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3b0:	0005879b          	sext.w	a5,a1
 3b4:	02c5d5bb          	divuw	a1,a1,a2
 3b8:	0685                	addi	a3,a3,1
 3ba:	fec7f0e3          	bgeu	a5,a2,39a <printint+0x26>
  if(neg)
 3be:	00088c63          	beqz	a7,3d6 <printint+0x62>
    buf[i++] = '-';
 3c2:	fd070793          	addi	a5,a4,-48
 3c6:	00878733          	add	a4,a5,s0
 3ca:	02d00793          	li	a5,45
 3ce:	fef70823          	sb	a5,-16(a4)
 3d2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3d6:	02e05c63          	blez	a4,40e <printint+0x9a>
 3da:	f04a                	sd	s2,32(sp)
 3dc:	ec4e                	sd	s3,24(sp)
 3de:	fc040793          	addi	a5,s0,-64
 3e2:	00e78933          	add	s2,a5,a4
 3e6:	fff78993          	addi	s3,a5,-1
 3ea:	99ba                	add	s3,s3,a4
 3ec:	377d                	addiw	a4,a4,-1
 3ee:	1702                	slli	a4,a4,0x20
 3f0:	9301                	srli	a4,a4,0x20
 3f2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3f6:	fff94583          	lbu	a1,-1(s2)
 3fa:	8526                	mv	a0,s1
 3fc:	00000097          	auipc	ra,0x0
 400:	f56080e7          	jalr	-170(ra) # 352 <putc>
  while(--i >= 0)
 404:	197d                	addi	s2,s2,-1
 406:	ff3918e3          	bne	s2,s3,3f6 <printint+0x82>
 40a:	7902                	ld	s2,32(sp)
 40c:	69e2                	ld	s3,24(sp)
}
 40e:	70e2                	ld	ra,56(sp)
 410:	7442                	ld	s0,48(sp)
 412:	74a2                	ld	s1,40(sp)
 414:	6121                	addi	sp,sp,64
 416:	8082                	ret
    x = -xx;
 418:	40b005bb          	negw	a1,a1
    neg = 1;
 41c:	4885                	li	a7,1
    x = -xx;
 41e:	b7b5                	j	38a <printint+0x16>

0000000000000420 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 420:	715d                	addi	sp,sp,-80
 422:	e486                	sd	ra,72(sp)
 424:	e0a2                	sd	s0,64(sp)
 426:	f84a                	sd	s2,48(sp)
 428:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 42a:	0005c903          	lbu	s2,0(a1)
 42e:	1a090a63          	beqz	s2,5e2 <vprintf+0x1c2>
 432:	fc26                	sd	s1,56(sp)
 434:	f44e                	sd	s3,40(sp)
 436:	f052                	sd	s4,32(sp)
 438:	ec56                	sd	s5,24(sp)
 43a:	e85a                	sd	s6,16(sp)
 43c:	e45e                	sd	s7,8(sp)
 43e:	8aaa                	mv	s5,a0
 440:	8bb2                	mv	s7,a2
 442:	00158493          	addi	s1,a1,1
  state = 0;
 446:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 448:	02500a13          	li	s4,37
 44c:	4b55                	li	s6,21
 44e:	a839                	j	46c <vprintf+0x4c>
        putc(fd, c);
 450:	85ca                	mv	a1,s2
 452:	8556                	mv	a0,s5
 454:	00000097          	auipc	ra,0x0
 458:	efe080e7          	jalr	-258(ra) # 352 <putc>
 45c:	a019                	j	462 <vprintf+0x42>
    } else if(state == '%'){
 45e:	01498d63          	beq	s3,s4,478 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 462:	0485                	addi	s1,s1,1
 464:	fff4c903          	lbu	s2,-1(s1)
 468:	16090763          	beqz	s2,5d6 <vprintf+0x1b6>
    if(state == 0){
 46c:	fe0999e3          	bnez	s3,45e <vprintf+0x3e>
      if(c == '%'){
 470:	ff4910e3          	bne	s2,s4,450 <vprintf+0x30>
        state = '%';
 474:	89d2                	mv	s3,s4
 476:	b7f5                	j	462 <vprintf+0x42>
      if(c == 'd'){
 478:	13490463          	beq	s2,s4,5a0 <vprintf+0x180>
 47c:	f9d9079b          	addiw	a5,s2,-99
 480:	0ff7f793          	zext.b	a5,a5
 484:	12fb6763          	bltu	s6,a5,5b2 <vprintf+0x192>
 488:	f9d9079b          	addiw	a5,s2,-99
 48c:	0ff7f713          	zext.b	a4,a5
 490:	12eb6163          	bltu	s6,a4,5b2 <vprintf+0x192>
 494:	00271793          	slli	a5,a4,0x2
 498:	00000717          	auipc	a4,0x0
 49c:	4c070713          	addi	a4,a4,1216 # 958 <malloc+0x150>
 4a0:	97ba                	add	a5,a5,a4
 4a2:	439c                	lw	a5,0(a5)
 4a4:	97ba                	add	a5,a5,a4
 4a6:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4a8:	008b8913          	addi	s2,s7,8
 4ac:	4685                	li	a3,1
 4ae:	4629                	li	a2,10
 4b0:	000ba583          	lw	a1,0(s7)
 4b4:	8556                	mv	a0,s5
 4b6:	00000097          	auipc	ra,0x0
 4ba:	ebe080e7          	jalr	-322(ra) # 374 <printint>
 4be:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4c0:	4981                	li	s3,0
 4c2:	b745                	j	462 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4c4:	008b8913          	addi	s2,s7,8
 4c8:	4681                	li	a3,0
 4ca:	4629                	li	a2,10
 4cc:	000ba583          	lw	a1,0(s7)
 4d0:	8556                	mv	a0,s5
 4d2:	00000097          	auipc	ra,0x0
 4d6:	ea2080e7          	jalr	-350(ra) # 374 <printint>
 4da:	8bca                	mv	s7,s2
      state = 0;
 4dc:	4981                	li	s3,0
 4de:	b751                	j	462 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 4e0:	008b8913          	addi	s2,s7,8
 4e4:	4681                	li	a3,0
 4e6:	4641                	li	a2,16
 4e8:	000ba583          	lw	a1,0(s7)
 4ec:	8556                	mv	a0,s5
 4ee:	00000097          	auipc	ra,0x0
 4f2:	e86080e7          	jalr	-378(ra) # 374 <printint>
 4f6:	8bca                	mv	s7,s2
      state = 0;
 4f8:	4981                	li	s3,0
 4fa:	b7a5                	j	462 <vprintf+0x42>
 4fc:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 4fe:	008b8c13          	addi	s8,s7,8
 502:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 506:	03000593          	li	a1,48
 50a:	8556                	mv	a0,s5
 50c:	00000097          	auipc	ra,0x0
 510:	e46080e7          	jalr	-442(ra) # 352 <putc>
  putc(fd, 'x');
 514:	07800593          	li	a1,120
 518:	8556                	mv	a0,s5
 51a:	00000097          	auipc	ra,0x0
 51e:	e38080e7          	jalr	-456(ra) # 352 <putc>
 522:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 524:	00000b97          	auipc	s7,0x0
 528:	48cb8b93          	addi	s7,s7,1164 # 9b0 <digits>
 52c:	03c9d793          	srli	a5,s3,0x3c
 530:	97de                	add	a5,a5,s7
 532:	0007c583          	lbu	a1,0(a5)
 536:	8556                	mv	a0,s5
 538:	00000097          	auipc	ra,0x0
 53c:	e1a080e7          	jalr	-486(ra) # 352 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 540:	0992                	slli	s3,s3,0x4
 542:	397d                	addiw	s2,s2,-1
 544:	fe0914e3          	bnez	s2,52c <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 548:	8be2                	mv	s7,s8
      state = 0;
 54a:	4981                	li	s3,0
 54c:	6c02                	ld	s8,0(sp)
 54e:	bf11                	j	462 <vprintf+0x42>
        s = va_arg(ap, char*);
 550:	008b8993          	addi	s3,s7,8
 554:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 558:	02090163          	beqz	s2,57a <vprintf+0x15a>
        while(*s != 0){
 55c:	00094583          	lbu	a1,0(s2)
 560:	c9a5                	beqz	a1,5d0 <vprintf+0x1b0>
          putc(fd, *s);
 562:	8556                	mv	a0,s5
 564:	00000097          	auipc	ra,0x0
 568:	dee080e7          	jalr	-530(ra) # 352 <putc>
          s++;
 56c:	0905                	addi	s2,s2,1
        while(*s != 0){
 56e:	00094583          	lbu	a1,0(s2)
 572:	f9e5                	bnez	a1,562 <vprintf+0x142>
        s = va_arg(ap, char*);
 574:	8bce                	mv	s7,s3
      state = 0;
 576:	4981                	li	s3,0
 578:	b5ed                	j	462 <vprintf+0x42>
          s = "(null)";
 57a:	00000917          	auipc	s2,0x0
 57e:	3d690913          	addi	s2,s2,982 # 950 <malloc+0x148>
        while(*s != 0){
 582:	02800593          	li	a1,40
 586:	bff1                	j	562 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 588:	008b8913          	addi	s2,s7,8
 58c:	000bc583          	lbu	a1,0(s7)
 590:	8556                	mv	a0,s5
 592:	00000097          	auipc	ra,0x0
 596:	dc0080e7          	jalr	-576(ra) # 352 <putc>
 59a:	8bca                	mv	s7,s2
      state = 0;
 59c:	4981                	li	s3,0
 59e:	b5d1                	j	462 <vprintf+0x42>
        putc(fd, c);
 5a0:	02500593          	li	a1,37
 5a4:	8556                	mv	a0,s5
 5a6:	00000097          	auipc	ra,0x0
 5aa:	dac080e7          	jalr	-596(ra) # 352 <putc>
      state = 0;
 5ae:	4981                	li	s3,0
 5b0:	bd4d                	j	462 <vprintf+0x42>
        putc(fd, '%');
 5b2:	02500593          	li	a1,37
 5b6:	8556                	mv	a0,s5
 5b8:	00000097          	auipc	ra,0x0
 5bc:	d9a080e7          	jalr	-614(ra) # 352 <putc>
        putc(fd, c);
 5c0:	85ca                	mv	a1,s2
 5c2:	8556                	mv	a0,s5
 5c4:	00000097          	auipc	ra,0x0
 5c8:	d8e080e7          	jalr	-626(ra) # 352 <putc>
      state = 0;
 5cc:	4981                	li	s3,0
 5ce:	bd51                	j	462 <vprintf+0x42>
        s = va_arg(ap, char*);
 5d0:	8bce                	mv	s7,s3
      state = 0;
 5d2:	4981                	li	s3,0
 5d4:	b579                	j	462 <vprintf+0x42>
 5d6:	74e2                	ld	s1,56(sp)
 5d8:	79a2                	ld	s3,40(sp)
 5da:	7a02                	ld	s4,32(sp)
 5dc:	6ae2                	ld	s5,24(sp)
 5de:	6b42                	ld	s6,16(sp)
 5e0:	6ba2                	ld	s7,8(sp)
    }
  }
}
 5e2:	60a6                	ld	ra,72(sp)
 5e4:	6406                	ld	s0,64(sp)
 5e6:	7942                	ld	s2,48(sp)
 5e8:	6161                	addi	sp,sp,80
 5ea:	8082                	ret

00000000000005ec <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5ec:	715d                	addi	sp,sp,-80
 5ee:	ec06                	sd	ra,24(sp)
 5f0:	e822                	sd	s0,16(sp)
 5f2:	1000                	addi	s0,sp,32
 5f4:	e010                	sd	a2,0(s0)
 5f6:	e414                	sd	a3,8(s0)
 5f8:	e818                	sd	a4,16(s0)
 5fa:	ec1c                	sd	a5,24(s0)
 5fc:	03043023          	sd	a6,32(s0)
 600:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 604:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 608:	8622                	mv	a2,s0
 60a:	00000097          	auipc	ra,0x0
 60e:	e16080e7          	jalr	-490(ra) # 420 <vprintf>
}
 612:	60e2                	ld	ra,24(sp)
 614:	6442                	ld	s0,16(sp)
 616:	6161                	addi	sp,sp,80
 618:	8082                	ret

000000000000061a <printf>:

void
printf(const char *fmt, ...)
{
 61a:	7159                	addi	sp,sp,-112
 61c:	f406                	sd	ra,40(sp)
 61e:	f022                	sd	s0,32(sp)
 620:	ec26                	sd	s1,24(sp)
 622:	1800                	addi	s0,sp,48
 624:	84aa                	mv	s1,a0
 626:	e40c                	sd	a1,8(s0)
 628:	e810                	sd	a2,16(s0)
 62a:	ec14                	sd	a3,24(s0)
 62c:	f018                	sd	a4,32(s0)
 62e:	f41c                	sd	a5,40(s0)
 630:	03043823          	sd	a6,48(s0)
 634:	03143c23          	sd	a7,56(s0)
  va_list ap;

  lock();
 638:	00000097          	auipc	ra,0x0
 63c:	d0a080e7          	jalr	-758(ra) # 342 <lock>
  va_start(ap, fmt);
 640:	00840613          	addi	a2,s0,8
 644:	fcc43c23          	sd	a2,-40(s0)
  vprintf(1, fmt, ap);
 648:	85a6                	mv	a1,s1
 64a:	4505                	li	a0,1
 64c:	00000097          	auipc	ra,0x0
 650:	dd4080e7          	jalr	-556(ra) # 420 <vprintf>
  unlock();
 654:	00000097          	auipc	ra,0x0
 658:	cf6080e7          	jalr	-778(ra) # 34a <unlock>
}
 65c:	70a2                	ld	ra,40(sp)
 65e:	7402                	ld	s0,32(sp)
 660:	64e2                	ld	s1,24(sp)
 662:	6165                	addi	sp,sp,112
 664:	8082                	ret

0000000000000666 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 666:	7179                	addi	sp,sp,-48
 668:	f422                	sd	s0,40(sp)
 66a:	1800                	addi	s0,sp,48
 66c:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 670:	fd843783          	ld	a5,-40(s0)
 674:	17c1                	addi	a5,a5,-16
 676:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 67a:	00001797          	auipc	a5,0x1
 67e:	d4678793          	addi	a5,a5,-698 # 13c0 <freep>
 682:	639c                	ld	a5,0(a5)
 684:	fef43423          	sd	a5,-24(s0)
 688:	a815                	j	6bc <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 68a:	fe843783          	ld	a5,-24(s0)
 68e:	639c                	ld	a5,0(a5)
 690:	fe843703          	ld	a4,-24(s0)
 694:	00f76f63          	bltu	a4,a5,6b2 <free+0x4c>
 698:	fe043703          	ld	a4,-32(s0)
 69c:	fe843783          	ld	a5,-24(s0)
 6a0:	02e7eb63          	bltu	a5,a4,6d6 <free+0x70>
 6a4:	fe843783          	ld	a5,-24(s0)
 6a8:	639c                	ld	a5,0(a5)
 6aa:	fe043703          	ld	a4,-32(s0)
 6ae:	02f76463          	bltu	a4,a5,6d6 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b2:	fe843783          	ld	a5,-24(s0)
 6b6:	639c                	ld	a5,0(a5)
 6b8:	fef43423          	sd	a5,-24(s0)
 6bc:	fe043703          	ld	a4,-32(s0)
 6c0:	fe843783          	ld	a5,-24(s0)
 6c4:	fce7f3e3          	bgeu	a5,a4,68a <free+0x24>
 6c8:	fe843783          	ld	a5,-24(s0)
 6cc:	639c                	ld	a5,0(a5)
 6ce:	fe043703          	ld	a4,-32(s0)
 6d2:	faf77ce3          	bgeu	a4,a5,68a <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6d6:	fe043783          	ld	a5,-32(s0)
 6da:	479c                	lw	a5,8(a5)
 6dc:	1782                	slli	a5,a5,0x20
 6de:	9381                	srli	a5,a5,0x20
 6e0:	0792                	slli	a5,a5,0x4
 6e2:	fe043703          	ld	a4,-32(s0)
 6e6:	973e                	add	a4,a4,a5
 6e8:	fe843783          	ld	a5,-24(s0)
 6ec:	639c                	ld	a5,0(a5)
 6ee:	02f71763          	bne	a4,a5,71c <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 6f2:	fe043783          	ld	a5,-32(s0)
 6f6:	4798                	lw	a4,8(a5)
 6f8:	fe843783          	ld	a5,-24(s0)
 6fc:	639c                	ld	a5,0(a5)
 6fe:	479c                	lw	a5,8(a5)
 700:	9fb9                	addw	a5,a5,a4
 702:	0007871b          	sext.w	a4,a5
 706:	fe043783          	ld	a5,-32(s0)
 70a:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 70c:	fe843783          	ld	a5,-24(s0)
 710:	639c                	ld	a5,0(a5)
 712:	6398                	ld	a4,0(a5)
 714:	fe043783          	ld	a5,-32(s0)
 718:	e398                	sd	a4,0(a5)
 71a:	a039                	j	728 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 71c:	fe843783          	ld	a5,-24(s0)
 720:	6398                	ld	a4,0(a5)
 722:	fe043783          	ld	a5,-32(s0)
 726:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 728:	fe843783          	ld	a5,-24(s0)
 72c:	479c                	lw	a5,8(a5)
 72e:	1782                	slli	a5,a5,0x20
 730:	9381                	srli	a5,a5,0x20
 732:	0792                	slli	a5,a5,0x4
 734:	fe843703          	ld	a4,-24(s0)
 738:	97ba                	add	a5,a5,a4
 73a:	fe043703          	ld	a4,-32(s0)
 73e:	02f71563          	bne	a4,a5,768 <free+0x102>
    p->s.size += bp->s.size;
 742:	fe843783          	ld	a5,-24(s0)
 746:	4798                	lw	a4,8(a5)
 748:	fe043783          	ld	a5,-32(s0)
 74c:	479c                	lw	a5,8(a5)
 74e:	9fb9                	addw	a5,a5,a4
 750:	0007871b          	sext.w	a4,a5
 754:	fe843783          	ld	a5,-24(s0)
 758:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 75a:	fe043783          	ld	a5,-32(s0)
 75e:	6398                	ld	a4,0(a5)
 760:	fe843783          	ld	a5,-24(s0)
 764:	e398                	sd	a4,0(a5)
 766:	a031                	j	772 <free+0x10c>
  } else
    p->s.ptr = bp;
 768:	fe843783          	ld	a5,-24(s0)
 76c:	fe043703          	ld	a4,-32(s0)
 770:	e398                	sd	a4,0(a5)
  freep = p;
 772:	00001797          	auipc	a5,0x1
 776:	c4e78793          	addi	a5,a5,-946 # 13c0 <freep>
 77a:	fe843703          	ld	a4,-24(s0)
 77e:	e398                	sd	a4,0(a5)
}
 780:	0001                	nop
 782:	7422                	ld	s0,40(sp)
 784:	6145                	addi	sp,sp,48
 786:	8082                	ret

0000000000000788 <morecore>:

static Header*
morecore(uint nu)
{
 788:	7179                	addi	sp,sp,-48
 78a:	f406                	sd	ra,40(sp)
 78c:	f022                	sd	s0,32(sp)
 78e:	1800                	addi	s0,sp,48
 790:	87aa                	mv	a5,a0
 792:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 796:	fdc42783          	lw	a5,-36(s0)
 79a:	0007871b          	sext.w	a4,a5
 79e:	6785                	lui	a5,0x1
 7a0:	00f77563          	bgeu	a4,a5,7aa <morecore+0x22>
    nu = 4096;
 7a4:	6785                	lui	a5,0x1
 7a6:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 7aa:	fdc42783          	lw	a5,-36(s0)
 7ae:	0047979b          	slliw	a5,a5,0x4
 7b2:	2781                	sext.w	a5,a5
 7b4:	2781                	sext.w	a5,a5
 7b6:	853e                	mv	a0,a5
 7b8:	00000097          	auipc	ra,0x0
 7bc:	b6a080e7          	jalr	-1174(ra) # 322 <sbrk>
 7c0:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 7c4:	fe843703          	ld	a4,-24(s0)
 7c8:	57fd                	li	a5,-1
 7ca:	00f71463          	bne	a4,a5,7d2 <morecore+0x4a>
    return 0;
 7ce:	4781                	li	a5,0
 7d0:	a03d                	j	7fe <morecore+0x76>
  hp = (Header*)p;
 7d2:	fe843783          	ld	a5,-24(s0)
 7d6:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 7da:	fe043783          	ld	a5,-32(s0)
 7de:	fdc42703          	lw	a4,-36(s0)
 7e2:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 7e4:	fe043783          	ld	a5,-32(s0)
 7e8:	07c1                	addi	a5,a5,16 # 1010 <digits+0x660>
 7ea:	853e                	mv	a0,a5
 7ec:	00000097          	auipc	ra,0x0
 7f0:	e7a080e7          	jalr	-390(ra) # 666 <free>
  return freep;
 7f4:	00001797          	auipc	a5,0x1
 7f8:	bcc78793          	addi	a5,a5,-1076 # 13c0 <freep>
 7fc:	639c                	ld	a5,0(a5)
}
 7fe:	853e                	mv	a0,a5
 800:	70a2                	ld	ra,40(sp)
 802:	7402                	ld	s0,32(sp)
 804:	6145                	addi	sp,sp,48
 806:	8082                	ret

0000000000000808 <malloc>:

void*
malloc(uint nbytes)
{
 808:	7139                	addi	sp,sp,-64
 80a:	fc06                	sd	ra,56(sp)
 80c:	f822                	sd	s0,48(sp)
 80e:	0080                	addi	s0,sp,64
 810:	87aa                	mv	a5,a0
 812:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 816:	fcc46783          	lwu	a5,-52(s0)
 81a:	07bd                	addi	a5,a5,15
 81c:	8391                	srli	a5,a5,0x4
 81e:	2781                	sext.w	a5,a5
 820:	2785                	addiw	a5,a5,1
 822:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 826:	00001797          	auipc	a5,0x1
 82a:	b9a78793          	addi	a5,a5,-1126 # 13c0 <freep>
 82e:	639c                	ld	a5,0(a5)
 830:	fef43023          	sd	a5,-32(s0)
 834:	fe043783          	ld	a5,-32(s0)
 838:	ef95                	bnez	a5,874 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 83a:	00001797          	auipc	a5,0x1
 83e:	b7678793          	addi	a5,a5,-1162 # 13b0 <base>
 842:	fef43023          	sd	a5,-32(s0)
 846:	00001797          	auipc	a5,0x1
 84a:	b7a78793          	addi	a5,a5,-1158 # 13c0 <freep>
 84e:	fe043703          	ld	a4,-32(s0)
 852:	e398                	sd	a4,0(a5)
 854:	00001797          	auipc	a5,0x1
 858:	b6c78793          	addi	a5,a5,-1172 # 13c0 <freep>
 85c:	6398                	ld	a4,0(a5)
 85e:	00001797          	auipc	a5,0x1
 862:	b5278793          	addi	a5,a5,-1198 # 13b0 <base>
 866:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 868:	00001797          	auipc	a5,0x1
 86c:	b4878793          	addi	a5,a5,-1208 # 13b0 <base>
 870:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 874:	fe043783          	ld	a5,-32(s0)
 878:	639c                	ld	a5,0(a5)
 87a:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 87e:	fe843783          	ld	a5,-24(s0)
 882:	4798                	lw	a4,8(a5)
 884:	fdc42783          	lw	a5,-36(s0)
 888:	2781                	sext.w	a5,a5
 88a:	06f76763          	bltu	a4,a5,8f8 <malloc+0xf0>
      if(p->s.size == nunits)
 88e:	fe843783          	ld	a5,-24(s0)
 892:	4798                	lw	a4,8(a5)
 894:	fdc42783          	lw	a5,-36(s0)
 898:	2781                	sext.w	a5,a5
 89a:	00e79963          	bne	a5,a4,8ac <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 89e:	fe843783          	ld	a5,-24(s0)
 8a2:	6398                	ld	a4,0(a5)
 8a4:	fe043783          	ld	a5,-32(s0)
 8a8:	e398                	sd	a4,0(a5)
 8aa:	a825                	j	8e2 <malloc+0xda>
      else {
        p->s.size -= nunits;
 8ac:	fe843783          	ld	a5,-24(s0)
 8b0:	479c                	lw	a5,8(a5)
 8b2:	fdc42703          	lw	a4,-36(s0)
 8b6:	9f99                	subw	a5,a5,a4
 8b8:	0007871b          	sext.w	a4,a5
 8bc:	fe843783          	ld	a5,-24(s0)
 8c0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8c2:	fe843783          	ld	a5,-24(s0)
 8c6:	479c                	lw	a5,8(a5)
 8c8:	1782                	slli	a5,a5,0x20
 8ca:	9381                	srli	a5,a5,0x20
 8cc:	0792                	slli	a5,a5,0x4
 8ce:	fe843703          	ld	a4,-24(s0)
 8d2:	97ba                	add	a5,a5,a4
 8d4:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 8d8:	fe843783          	ld	a5,-24(s0)
 8dc:	fdc42703          	lw	a4,-36(s0)
 8e0:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 8e2:	00001797          	auipc	a5,0x1
 8e6:	ade78793          	addi	a5,a5,-1314 # 13c0 <freep>
 8ea:	fe043703          	ld	a4,-32(s0)
 8ee:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 8f0:	fe843783          	ld	a5,-24(s0)
 8f4:	07c1                	addi	a5,a5,16
 8f6:	a091                	j	93a <malloc+0x132>
    }
    if(p == freep)
 8f8:	00001797          	auipc	a5,0x1
 8fc:	ac878793          	addi	a5,a5,-1336 # 13c0 <freep>
 900:	639c                	ld	a5,0(a5)
 902:	fe843703          	ld	a4,-24(s0)
 906:	02f71063          	bne	a4,a5,926 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 90a:	fdc42783          	lw	a5,-36(s0)
 90e:	853e                	mv	a0,a5
 910:	00000097          	auipc	ra,0x0
 914:	e78080e7          	jalr	-392(ra) # 788 <morecore>
 918:	fea43423          	sd	a0,-24(s0)
 91c:	fe843783          	ld	a5,-24(s0)
 920:	e399                	bnez	a5,926 <malloc+0x11e>
        return 0;
 922:	4781                	li	a5,0
 924:	a819                	j	93a <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 926:	fe843783          	ld	a5,-24(s0)
 92a:	fef43023          	sd	a5,-32(s0)
 92e:	fe843783          	ld	a5,-24(s0)
 932:	639c                	ld	a5,0(a5)
 934:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 938:	b799                	j	87e <malloc+0x76>
  }
}
 93a:	853e                	mv	a0,a5
 93c:	70e2                	ld	ra,56(sp)
 93e:	7442                	ld	s0,48(sp)
 940:	6121                	addi	sp,sp,64
 942:	8082                	ret
