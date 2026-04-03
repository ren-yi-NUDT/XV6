
user/_sleep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

#define SLEEPTIME 20

int main(int argc, char *argv[]){
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    if (argc != 2){
   8:	4789                	li	a5,2
   a:	00f50c63          	beq	a0,a5,22 <main+0x22>
        sleep(SLEEPTIME);
   e:	4551                	li	a0,20
  10:	00000097          	auipc	ra,0x0
  14:	342080e7          	jalr	834(ra) # 352 <sleep>
    }
    else {
        int tick = atoi(argv[1]) * 10;
        sleep(tick);
    }
    exit(0);
  18:	4501                	li	a0,0
  1a:	00000097          	auipc	ra,0x0
  1e:	2a8080e7          	jalr	680(ra) # 2c2 <exit>
        int tick = atoi(argv[1]) * 10;
  22:	6588                	ld	a0,8(a1)
  24:	00000097          	auipc	ra,0x0
  28:	1a4080e7          	jalr	420(ra) # 1c8 <atoi>
        sleep(tick);
  2c:	47a9                	li	a5,10
  2e:	02a7853b          	mulw	a0,a5,a0
  32:	00000097          	auipc	ra,0x0
  36:	320080e7          	jalr	800(ra) # 352 <sleep>
  3a:	bff9                	j	18 <main+0x18>

000000000000003c <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  3c:	1141                	addi	sp,sp,-16
  3e:	e406                	sd	ra,8(sp)
  40:	e022                	sd	s0,0(sp)
  42:	0800                	addi	s0,sp,16
  extern int main();
  main();
  44:	00000097          	auipc	ra,0x0
  48:	fbc080e7          	jalr	-68(ra) # 0 <main>
  exit(0);
  4c:	4501                	li	a0,0
  4e:	00000097          	auipc	ra,0x0
  52:	274080e7          	jalr	628(ra) # 2c2 <exit>

0000000000000056 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  56:	1141                	addi	sp,sp,-16
  58:	e422                	sd	s0,8(sp)
  5a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  5c:	87aa                	mv	a5,a0
  5e:	0585                	addi	a1,a1,1
  60:	0785                	addi	a5,a5,1
  62:	fff5c703          	lbu	a4,-1(a1)
  66:	fee78fa3          	sb	a4,-1(a5)
  6a:	fb75                	bnez	a4,5e <strcpy+0x8>
    ;
  return os;
}
  6c:	6422                	ld	s0,8(sp)
  6e:	0141                	addi	sp,sp,16
  70:	8082                	ret

0000000000000072 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  72:	1141                	addi	sp,sp,-16
  74:	e422                	sd	s0,8(sp)
  76:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  78:	00054783          	lbu	a5,0(a0)
  7c:	cb91                	beqz	a5,90 <strcmp+0x1e>
  7e:	0005c703          	lbu	a4,0(a1)
  82:	00f71763          	bne	a4,a5,90 <strcmp+0x1e>
    p++, q++;
  86:	0505                	addi	a0,a0,1
  88:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  8a:	00054783          	lbu	a5,0(a0)
  8e:	fbe5                	bnez	a5,7e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  90:	0005c503          	lbu	a0,0(a1)
}
  94:	40a7853b          	subw	a0,a5,a0
  98:	6422                	ld	s0,8(sp)
  9a:	0141                	addi	sp,sp,16
  9c:	8082                	ret

000000000000009e <strlen>:

uint
strlen(const char *s)
{
  9e:	1141                	addi	sp,sp,-16
  a0:	e422                	sd	s0,8(sp)
  a2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  a4:	00054783          	lbu	a5,0(a0)
  a8:	cf91                	beqz	a5,c4 <strlen+0x26>
  aa:	0505                	addi	a0,a0,1
  ac:	87aa                	mv	a5,a0
  ae:	86be                	mv	a3,a5
  b0:	0785                	addi	a5,a5,1
  b2:	fff7c703          	lbu	a4,-1(a5)
  b6:	ff65                	bnez	a4,ae <strlen+0x10>
  b8:	40a6853b          	subw	a0,a3,a0
  bc:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  be:	6422                	ld	s0,8(sp)
  c0:	0141                	addi	sp,sp,16
  c2:	8082                	ret
  for(n = 0; s[n]; n++)
  c4:	4501                	li	a0,0
  c6:	bfe5                	j	be <strlen+0x20>

00000000000000c8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  c8:	1141                	addi	sp,sp,-16
  ca:	e422                	sd	s0,8(sp)
  cc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  ce:	ca19                	beqz	a2,e4 <memset+0x1c>
  d0:	87aa                	mv	a5,a0
  d2:	1602                	slli	a2,a2,0x20
  d4:	9201                	srli	a2,a2,0x20
  d6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  da:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  de:	0785                	addi	a5,a5,1
  e0:	fee79de3          	bne	a5,a4,da <memset+0x12>
  }
  return dst;
}
  e4:	6422                	ld	s0,8(sp)
  e6:	0141                	addi	sp,sp,16
  e8:	8082                	ret

00000000000000ea <strchr>:

char*
strchr(const char *s, char c)
{
  ea:	1141                	addi	sp,sp,-16
  ec:	e422                	sd	s0,8(sp)
  ee:	0800                	addi	s0,sp,16
  for(; *s; s++)
  f0:	00054783          	lbu	a5,0(a0)
  f4:	cb99                	beqz	a5,10a <strchr+0x20>
    if(*s == c)
  f6:	00f58763          	beq	a1,a5,104 <strchr+0x1a>
  for(; *s; s++)
  fa:	0505                	addi	a0,a0,1
  fc:	00054783          	lbu	a5,0(a0)
 100:	fbfd                	bnez	a5,f6 <strchr+0xc>
      return (char*)s;
  return 0;
 102:	4501                	li	a0,0
}
 104:	6422                	ld	s0,8(sp)
 106:	0141                	addi	sp,sp,16
 108:	8082                	ret
  return 0;
 10a:	4501                	li	a0,0
 10c:	bfe5                	j	104 <strchr+0x1a>

000000000000010e <gets>:

char*
gets(char *buf, int max)
{
 10e:	711d                	addi	sp,sp,-96
 110:	ec86                	sd	ra,88(sp)
 112:	e8a2                	sd	s0,80(sp)
 114:	e4a6                	sd	s1,72(sp)
 116:	e0ca                	sd	s2,64(sp)
 118:	fc4e                	sd	s3,56(sp)
 11a:	f852                	sd	s4,48(sp)
 11c:	f456                	sd	s5,40(sp)
 11e:	f05a                	sd	s6,32(sp)
 120:	ec5e                	sd	s7,24(sp)
 122:	1080                	addi	s0,sp,96
 124:	8baa                	mv	s7,a0
 126:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 128:	892a                	mv	s2,a0
 12a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 12c:	4aa9                	li	s5,10
 12e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 130:	89a6                	mv	s3,s1
 132:	2485                	addiw	s1,s1,1
 134:	0344d863          	bge	s1,s4,164 <gets+0x56>
    cc = read(0, &c, 1);
 138:	4605                	li	a2,1
 13a:	faf40593          	addi	a1,s0,-81
 13e:	4501                	li	a0,0
 140:	00000097          	auipc	ra,0x0
 144:	19a080e7          	jalr	410(ra) # 2da <read>
    if(cc < 1)
 148:	00a05e63          	blez	a0,164 <gets+0x56>
    buf[i++] = c;
 14c:	faf44783          	lbu	a5,-81(s0)
 150:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 154:	01578763          	beq	a5,s5,162 <gets+0x54>
 158:	0905                	addi	s2,s2,1
 15a:	fd679be3          	bne	a5,s6,130 <gets+0x22>
    buf[i++] = c;
 15e:	89a6                	mv	s3,s1
 160:	a011                	j	164 <gets+0x56>
 162:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 164:	99de                	add	s3,s3,s7
 166:	00098023          	sb	zero,0(s3)
  return buf;
}
 16a:	855e                	mv	a0,s7
 16c:	60e6                	ld	ra,88(sp)
 16e:	6446                	ld	s0,80(sp)
 170:	64a6                	ld	s1,72(sp)
 172:	6906                	ld	s2,64(sp)
 174:	79e2                	ld	s3,56(sp)
 176:	7a42                	ld	s4,48(sp)
 178:	7aa2                	ld	s5,40(sp)
 17a:	7b02                	ld	s6,32(sp)
 17c:	6be2                	ld	s7,24(sp)
 17e:	6125                	addi	sp,sp,96
 180:	8082                	ret

0000000000000182 <stat>:

int
stat(const char *n, struct stat *st)
{
 182:	1101                	addi	sp,sp,-32
 184:	ec06                	sd	ra,24(sp)
 186:	e822                	sd	s0,16(sp)
 188:	e04a                	sd	s2,0(sp)
 18a:	1000                	addi	s0,sp,32
 18c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 18e:	4581                	li	a1,0
 190:	00000097          	auipc	ra,0x0
 194:	172080e7          	jalr	370(ra) # 302 <open>
  if(fd < 0)
 198:	02054663          	bltz	a0,1c4 <stat+0x42>
 19c:	e426                	sd	s1,8(sp)
 19e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1a0:	85ca                	mv	a1,s2
 1a2:	00000097          	auipc	ra,0x0
 1a6:	178080e7          	jalr	376(ra) # 31a <fstat>
 1aa:	892a                	mv	s2,a0
  close(fd);
 1ac:	8526                	mv	a0,s1
 1ae:	00000097          	auipc	ra,0x0
 1b2:	13c080e7          	jalr	316(ra) # 2ea <close>
  return r;
 1b6:	64a2                	ld	s1,8(sp)
}
 1b8:	854a                	mv	a0,s2
 1ba:	60e2                	ld	ra,24(sp)
 1bc:	6442                	ld	s0,16(sp)
 1be:	6902                	ld	s2,0(sp)
 1c0:	6105                	addi	sp,sp,32
 1c2:	8082                	ret
    return -1;
 1c4:	597d                	li	s2,-1
 1c6:	bfcd                	j	1b8 <stat+0x36>

00000000000001c8 <atoi>:

int
atoi(const char *s)
{
 1c8:	1141                	addi	sp,sp,-16
 1ca:	e422                	sd	s0,8(sp)
 1cc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ce:	00054683          	lbu	a3,0(a0)
 1d2:	fd06879b          	addiw	a5,a3,-48
 1d6:	0ff7f793          	zext.b	a5,a5
 1da:	4625                	li	a2,9
 1dc:	02f66863          	bltu	a2,a5,20c <atoi+0x44>
 1e0:	872a                	mv	a4,a0
  n = 0;
 1e2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1e4:	0705                	addi	a4,a4,1
 1e6:	0025179b          	slliw	a5,a0,0x2
 1ea:	9fa9                	addw	a5,a5,a0
 1ec:	0017979b          	slliw	a5,a5,0x1
 1f0:	9fb5                	addw	a5,a5,a3
 1f2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1f6:	00074683          	lbu	a3,0(a4)
 1fa:	fd06879b          	addiw	a5,a3,-48
 1fe:	0ff7f793          	zext.b	a5,a5
 202:	fef671e3          	bgeu	a2,a5,1e4 <atoi+0x1c>
  return n;
}
 206:	6422                	ld	s0,8(sp)
 208:	0141                	addi	sp,sp,16
 20a:	8082                	ret
  n = 0;
 20c:	4501                	li	a0,0
 20e:	bfe5                	j	206 <atoi+0x3e>

0000000000000210 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 210:	1141                	addi	sp,sp,-16
 212:	e422                	sd	s0,8(sp)
 214:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 216:	02b57463          	bgeu	a0,a1,23e <memmove+0x2e>
    while(n-- > 0)
 21a:	00c05f63          	blez	a2,238 <memmove+0x28>
 21e:	1602                	slli	a2,a2,0x20
 220:	9201                	srli	a2,a2,0x20
 222:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 226:	872a                	mv	a4,a0
      *dst++ = *src++;
 228:	0585                	addi	a1,a1,1
 22a:	0705                	addi	a4,a4,1
 22c:	fff5c683          	lbu	a3,-1(a1)
 230:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 234:	fef71ae3          	bne	a4,a5,228 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 238:	6422                	ld	s0,8(sp)
 23a:	0141                	addi	sp,sp,16
 23c:	8082                	ret
    dst += n;
 23e:	00c50733          	add	a4,a0,a2
    src += n;
 242:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 244:	fec05ae3          	blez	a2,238 <memmove+0x28>
 248:	fff6079b          	addiw	a5,a2,-1
 24c:	1782                	slli	a5,a5,0x20
 24e:	9381                	srli	a5,a5,0x20
 250:	fff7c793          	not	a5,a5
 254:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 256:	15fd                	addi	a1,a1,-1
 258:	177d                	addi	a4,a4,-1
 25a:	0005c683          	lbu	a3,0(a1)
 25e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 262:	fee79ae3          	bne	a5,a4,256 <memmove+0x46>
 266:	bfc9                	j	238 <memmove+0x28>

0000000000000268 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 268:	1141                	addi	sp,sp,-16
 26a:	e422                	sd	s0,8(sp)
 26c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 26e:	ca05                	beqz	a2,29e <memcmp+0x36>
 270:	fff6069b          	addiw	a3,a2,-1
 274:	1682                	slli	a3,a3,0x20
 276:	9281                	srli	a3,a3,0x20
 278:	0685                	addi	a3,a3,1
 27a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 27c:	00054783          	lbu	a5,0(a0)
 280:	0005c703          	lbu	a4,0(a1)
 284:	00e79863          	bne	a5,a4,294 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 288:	0505                	addi	a0,a0,1
    p2++;
 28a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 28c:	fed518e3          	bne	a0,a3,27c <memcmp+0x14>
  }
  return 0;
 290:	4501                	li	a0,0
 292:	a019                	j	298 <memcmp+0x30>
      return *p1 - *p2;
 294:	40e7853b          	subw	a0,a5,a4
}
 298:	6422                	ld	s0,8(sp)
 29a:	0141                	addi	sp,sp,16
 29c:	8082                	ret
  return 0;
 29e:	4501                	li	a0,0
 2a0:	bfe5                	j	298 <memcmp+0x30>

00000000000002a2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2a2:	1141                	addi	sp,sp,-16
 2a4:	e406                	sd	ra,8(sp)
 2a6:	e022                	sd	s0,0(sp)
 2a8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2aa:	00000097          	auipc	ra,0x0
 2ae:	f66080e7          	jalr	-154(ra) # 210 <memmove>
}
 2b2:	60a2                	ld	ra,8(sp)
 2b4:	6402                	ld	s0,0(sp)
 2b6:	0141                	addi	sp,sp,16
 2b8:	8082                	ret

00000000000002ba <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2ba:	4885                	li	a7,1
 ecall
 2bc:	00000073          	ecall
 ret
 2c0:	8082                	ret

00000000000002c2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2c2:	4889                	li	a7,2
 ecall
 2c4:	00000073          	ecall
 ret
 2c8:	8082                	ret

00000000000002ca <wait>:
.global wait
wait:
 li a7, SYS_wait
 2ca:	488d                	li	a7,3
 ecall
 2cc:	00000073          	ecall
 ret
 2d0:	8082                	ret

00000000000002d2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2d2:	4891                	li	a7,4
 ecall
 2d4:	00000073          	ecall
 ret
 2d8:	8082                	ret

00000000000002da <read>:
.global read
read:
 li a7, SYS_read
 2da:	4895                	li	a7,5
 ecall
 2dc:	00000073          	ecall
 ret
 2e0:	8082                	ret

00000000000002e2 <write>:
.global write
write:
 li a7, SYS_write
 2e2:	48c1                	li	a7,16
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <close>:
.global close
close:
 li a7, SYS_close
 2ea:	48d5                	li	a7,21
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2f2:	4899                	li	a7,6
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <exec>:
.global exec
exec:
 li a7, SYS_exec
 2fa:	489d                	li	a7,7
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <open>:
.global open
open:
 li a7, SYS_open
 302:	48bd                	li	a7,15
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 30a:	48c5                	li	a7,17
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 312:	48c9                	li	a7,18
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 31a:	48a1                	li	a7,8
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <link>:
.global link
link:
 li a7, SYS_link
 322:	48cd                	li	a7,19
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 32a:	48d1                	li	a7,20
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 332:	48a5                	li	a7,9
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <dup>:
.global dup
dup:
 li a7, SYS_dup
 33a:	48a9                	li	a7,10
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 342:	48ad                	li	a7,11
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 34a:	48b1                	li	a7,12
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 352:	48b5                	li	a7,13
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 35a:	48b9                	li	a7,14
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <yield>:
.global yield
yield:
 li a7, SYS_yield
 362:	48d9                	li	a7,22
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <lock>:
.global lock
lock:
 li a7, SYS_lock
 36a:	48dd                	li	a7,23
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <unlock>:
.global unlock
unlock:
 li a7, SYS_unlock
 372:	48e1                	li	a7,24
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 37a:	1101                	addi	sp,sp,-32
 37c:	ec06                	sd	ra,24(sp)
 37e:	e822                	sd	s0,16(sp)
 380:	1000                	addi	s0,sp,32
 382:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 386:	4605                	li	a2,1
 388:	fef40593          	addi	a1,s0,-17
 38c:	00000097          	auipc	ra,0x0
 390:	f56080e7          	jalr	-170(ra) # 2e2 <write>
}
 394:	60e2                	ld	ra,24(sp)
 396:	6442                	ld	s0,16(sp)
 398:	6105                	addi	sp,sp,32
 39a:	8082                	ret

000000000000039c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 39c:	7139                	addi	sp,sp,-64
 39e:	fc06                	sd	ra,56(sp)
 3a0:	f822                	sd	s0,48(sp)
 3a2:	f426                	sd	s1,40(sp)
 3a4:	0080                	addi	s0,sp,64
 3a6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3a8:	c299                	beqz	a3,3ae <printint+0x12>
 3aa:	0805cb63          	bltz	a1,440 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3ae:	2581                	sext.w	a1,a1
  neg = 0;
 3b0:	4881                	li	a7,0
 3b2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3b6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3b8:	2601                	sext.w	a2,a2
 3ba:	00000517          	auipc	a0,0x0
 3be:	61650513          	addi	a0,a0,1558 # 9d0 <digits>
 3c2:	883a                	mv	a6,a4
 3c4:	2705                	addiw	a4,a4,1
 3c6:	02c5f7bb          	remuw	a5,a1,a2
 3ca:	1782                	slli	a5,a5,0x20
 3cc:	9381                	srli	a5,a5,0x20
 3ce:	97aa                	add	a5,a5,a0
 3d0:	0007c783          	lbu	a5,0(a5)
 3d4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3d8:	0005879b          	sext.w	a5,a1
 3dc:	02c5d5bb          	divuw	a1,a1,a2
 3e0:	0685                	addi	a3,a3,1
 3e2:	fec7f0e3          	bgeu	a5,a2,3c2 <printint+0x26>
  if(neg)
 3e6:	00088c63          	beqz	a7,3fe <printint+0x62>
    buf[i++] = '-';
 3ea:	fd070793          	addi	a5,a4,-48
 3ee:	00878733          	add	a4,a5,s0
 3f2:	02d00793          	li	a5,45
 3f6:	fef70823          	sb	a5,-16(a4)
 3fa:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3fe:	02e05c63          	blez	a4,436 <printint+0x9a>
 402:	f04a                	sd	s2,32(sp)
 404:	ec4e                	sd	s3,24(sp)
 406:	fc040793          	addi	a5,s0,-64
 40a:	00e78933          	add	s2,a5,a4
 40e:	fff78993          	addi	s3,a5,-1
 412:	99ba                	add	s3,s3,a4
 414:	377d                	addiw	a4,a4,-1
 416:	1702                	slli	a4,a4,0x20
 418:	9301                	srli	a4,a4,0x20
 41a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 41e:	fff94583          	lbu	a1,-1(s2)
 422:	8526                	mv	a0,s1
 424:	00000097          	auipc	ra,0x0
 428:	f56080e7          	jalr	-170(ra) # 37a <putc>
  while(--i >= 0)
 42c:	197d                	addi	s2,s2,-1
 42e:	ff3918e3          	bne	s2,s3,41e <printint+0x82>
 432:	7902                	ld	s2,32(sp)
 434:	69e2                	ld	s3,24(sp)
}
 436:	70e2                	ld	ra,56(sp)
 438:	7442                	ld	s0,48(sp)
 43a:	74a2                	ld	s1,40(sp)
 43c:	6121                	addi	sp,sp,64
 43e:	8082                	ret
    x = -xx;
 440:	40b005bb          	negw	a1,a1
    neg = 1;
 444:	4885                	li	a7,1
    x = -xx;
 446:	b7b5                	j	3b2 <printint+0x16>

0000000000000448 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 448:	715d                	addi	sp,sp,-80
 44a:	e486                	sd	ra,72(sp)
 44c:	e0a2                	sd	s0,64(sp)
 44e:	f84a                	sd	s2,48(sp)
 450:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 452:	0005c903          	lbu	s2,0(a1)
 456:	1a090a63          	beqz	s2,60a <vprintf+0x1c2>
 45a:	fc26                	sd	s1,56(sp)
 45c:	f44e                	sd	s3,40(sp)
 45e:	f052                	sd	s4,32(sp)
 460:	ec56                	sd	s5,24(sp)
 462:	e85a                	sd	s6,16(sp)
 464:	e45e                	sd	s7,8(sp)
 466:	8aaa                	mv	s5,a0
 468:	8bb2                	mv	s7,a2
 46a:	00158493          	addi	s1,a1,1
  state = 0;
 46e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 470:	02500a13          	li	s4,37
 474:	4b55                	li	s6,21
 476:	a839                	j	494 <vprintf+0x4c>
        putc(fd, c);
 478:	85ca                	mv	a1,s2
 47a:	8556                	mv	a0,s5
 47c:	00000097          	auipc	ra,0x0
 480:	efe080e7          	jalr	-258(ra) # 37a <putc>
 484:	a019                	j	48a <vprintf+0x42>
    } else if(state == '%'){
 486:	01498d63          	beq	s3,s4,4a0 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 48a:	0485                	addi	s1,s1,1
 48c:	fff4c903          	lbu	s2,-1(s1)
 490:	16090763          	beqz	s2,5fe <vprintf+0x1b6>
    if(state == 0){
 494:	fe0999e3          	bnez	s3,486 <vprintf+0x3e>
      if(c == '%'){
 498:	ff4910e3          	bne	s2,s4,478 <vprintf+0x30>
        state = '%';
 49c:	89d2                	mv	s3,s4
 49e:	b7f5                	j	48a <vprintf+0x42>
      if(c == 'd'){
 4a0:	13490463          	beq	s2,s4,5c8 <vprintf+0x180>
 4a4:	f9d9079b          	addiw	a5,s2,-99
 4a8:	0ff7f793          	zext.b	a5,a5
 4ac:	12fb6763          	bltu	s6,a5,5da <vprintf+0x192>
 4b0:	f9d9079b          	addiw	a5,s2,-99
 4b4:	0ff7f713          	zext.b	a4,a5
 4b8:	12eb6163          	bltu	s6,a4,5da <vprintf+0x192>
 4bc:	00271793          	slli	a5,a4,0x2
 4c0:	00000717          	auipc	a4,0x0
 4c4:	4b870713          	addi	a4,a4,1208 # 978 <malloc+0x148>
 4c8:	97ba                	add	a5,a5,a4
 4ca:	439c                	lw	a5,0(a5)
 4cc:	97ba                	add	a5,a5,a4
 4ce:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4d0:	008b8913          	addi	s2,s7,8
 4d4:	4685                	li	a3,1
 4d6:	4629                	li	a2,10
 4d8:	000ba583          	lw	a1,0(s7)
 4dc:	8556                	mv	a0,s5
 4de:	00000097          	auipc	ra,0x0
 4e2:	ebe080e7          	jalr	-322(ra) # 39c <printint>
 4e6:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4e8:	4981                	li	s3,0
 4ea:	b745                	j	48a <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4ec:	008b8913          	addi	s2,s7,8
 4f0:	4681                	li	a3,0
 4f2:	4629                	li	a2,10
 4f4:	000ba583          	lw	a1,0(s7)
 4f8:	8556                	mv	a0,s5
 4fa:	00000097          	auipc	ra,0x0
 4fe:	ea2080e7          	jalr	-350(ra) # 39c <printint>
 502:	8bca                	mv	s7,s2
      state = 0;
 504:	4981                	li	s3,0
 506:	b751                	j	48a <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 508:	008b8913          	addi	s2,s7,8
 50c:	4681                	li	a3,0
 50e:	4641                	li	a2,16
 510:	000ba583          	lw	a1,0(s7)
 514:	8556                	mv	a0,s5
 516:	00000097          	auipc	ra,0x0
 51a:	e86080e7          	jalr	-378(ra) # 39c <printint>
 51e:	8bca                	mv	s7,s2
      state = 0;
 520:	4981                	li	s3,0
 522:	b7a5                	j	48a <vprintf+0x42>
 524:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 526:	008b8c13          	addi	s8,s7,8
 52a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 52e:	03000593          	li	a1,48
 532:	8556                	mv	a0,s5
 534:	00000097          	auipc	ra,0x0
 538:	e46080e7          	jalr	-442(ra) # 37a <putc>
  putc(fd, 'x');
 53c:	07800593          	li	a1,120
 540:	8556                	mv	a0,s5
 542:	00000097          	auipc	ra,0x0
 546:	e38080e7          	jalr	-456(ra) # 37a <putc>
 54a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 54c:	00000b97          	auipc	s7,0x0
 550:	484b8b93          	addi	s7,s7,1156 # 9d0 <digits>
 554:	03c9d793          	srli	a5,s3,0x3c
 558:	97de                	add	a5,a5,s7
 55a:	0007c583          	lbu	a1,0(a5)
 55e:	8556                	mv	a0,s5
 560:	00000097          	auipc	ra,0x0
 564:	e1a080e7          	jalr	-486(ra) # 37a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 568:	0992                	slli	s3,s3,0x4
 56a:	397d                	addiw	s2,s2,-1
 56c:	fe0914e3          	bnez	s2,554 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 570:	8be2                	mv	s7,s8
      state = 0;
 572:	4981                	li	s3,0
 574:	6c02                	ld	s8,0(sp)
 576:	bf11                	j	48a <vprintf+0x42>
        s = va_arg(ap, char*);
 578:	008b8993          	addi	s3,s7,8
 57c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 580:	02090163          	beqz	s2,5a2 <vprintf+0x15a>
        while(*s != 0){
 584:	00094583          	lbu	a1,0(s2)
 588:	c9a5                	beqz	a1,5f8 <vprintf+0x1b0>
          putc(fd, *s);
 58a:	8556                	mv	a0,s5
 58c:	00000097          	auipc	ra,0x0
 590:	dee080e7          	jalr	-530(ra) # 37a <putc>
          s++;
 594:	0905                	addi	s2,s2,1
        while(*s != 0){
 596:	00094583          	lbu	a1,0(s2)
 59a:	f9e5                	bnez	a1,58a <vprintf+0x142>
        s = va_arg(ap, char*);
 59c:	8bce                	mv	s7,s3
      state = 0;
 59e:	4981                	li	s3,0
 5a0:	b5ed                	j	48a <vprintf+0x42>
          s = "(null)";
 5a2:	00000917          	auipc	s2,0x0
 5a6:	3ce90913          	addi	s2,s2,974 # 970 <malloc+0x140>
        while(*s != 0){
 5aa:	02800593          	li	a1,40
 5ae:	bff1                	j	58a <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 5b0:	008b8913          	addi	s2,s7,8
 5b4:	000bc583          	lbu	a1,0(s7)
 5b8:	8556                	mv	a0,s5
 5ba:	00000097          	auipc	ra,0x0
 5be:	dc0080e7          	jalr	-576(ra) # 37a <putc>
 5c2:	8bca                	mv	s7,s2
      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	b5d1                	j	48a <vprintf+0x42>
        putc(fd, c);
 5c8:	02500593          	li	a1,37
 5cc:	8556                	mv	a0,s5
 5ce:	00000097          	auipc	ra,0x0
 5d2:	dac080e7          	jalr	-596(ra) # 37a <putc>
      state = 0;
 5d6:	4981                	li	s3,0
 5d8:	bd4d                	j	48a <vprintf+0x42>
        putc(fd, '%');
 5da:	02500593          	li	a1,37
 5de:	8556                	mv	a0,s5
 5e0:	00000097          	auipc	ra,0x0
 5e4:	d9a080e7          	jalr	-614(ra) # 37a <putc>
        putc(fd, c);
 5e8:	85ca                	mv	a1,s2
 5ea:	8556                	mv	a0,s5
 5ec:	00000097          	auipc	ra,0x0
 5f0:	d8e080e7          	jalr	-626(ra) # 37a <putc>
      state = 0;
 5f4:	4981                	li	s3,0
 5f6:	bd51                	j	48a <vprintf+0x42>
        s = va_arg(ap, char*);
 5f8:	8bce                	mv	s7,s3
      state = 0;
 5fa:	4981                	li	s3,0
 5fc:	b579                	j	48a <vprintf+0x42>
 5fe:	74e2                	ld	s1,56(sp)
 600:	79a2                	ld	s3,40(sp)
 602:	7a02                	ld	s4,32(sp)
 604:	6ae2                	ld	s5,24(sp)
 606:	6b42                	ld	s6,16(sp)
 608:	6ba2                	ld	s7,8(sp)
    }
  }
}
 60a:	60a6                	ld	ra,72(sp)
 60c:	6406                	ld	s0,64(sp)
 60e:	7942                	ld	s2,48(sp)
 610:	6161                	addi	sp,sp,80
 612:	8082                	ret

0000000000000614 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 614:	715d                	addi	sp,sp,-80
 616:	ec06                	sd	ra,24(sp)
 618:	e822                	sd	s0,16(sp)
 61a:	1000                	addi	s0,sp,32
 61c:	e010                	sd	a2,0(s0)
 61e:	e414                	sd	a3,8(s0)
 620:	e818                	sd	a4,16(s0)
 622:	ec1c                	sd	a5,24(s0)
 624:	03043023          	sd	a6,32(s0)
 628:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 62c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 630:	8622                	mv	a2,s0
 632:	00000097          	auipc	ra,0x0
 636:	e16080e7          	jalr	-490(ra) # 448 <vprintf>
}
 63a:	60e2                	ld	ra,24(sp)
 63c:	6442                	ld	s0,16(sp)
 63e:	6161                	addi	sp,sp,80
 640:	8082                	ret

0000000000000642 <printf>:

void
printf(const char *fmt, ...)
{
 642:	7159                	addi	sp,sp,-112
 644:	f406                	sd	ra,40(sp)
 646:	f022                	sd	s0,32(sp)
 648:	ec26                	sd	s1,24(sp)
 64a:	1800                	addi	s0,sp,48
 64c:	84aa                	mv	s1,a0
 64e:	e40c                	sd	a1,8(s0)
 650:	e810                	sd	a2,16(s0)
 652:	ec14                	sd	a3,24(s0)
 654:	f018                	sd	a4,32(s0)
 656:	f41c                	sd	a5,40(s0)
 658:	03043823          	sd	a6,48(s0)
 65c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  lock();
 660:	00000097          	auipc	ra,0x0
 664:	d0a080e7          	jalr	-758(ra) # 36a <lock>
  va_start(ap, fmt);
 668:	00840613          	addi	a2,s0,8
 66c:	fcc43c23          	sd	a2,-40(s0)
  vprintf(1, fmt, ap);
 670:	85a6                	mv	a1,s1
 672:	4505                	li	a0,1
 674:	00000097          	auipc	ra,0x0
 678:	dd4080e7          	jalr	-556(ra) # 448 <vprintf>
  unlock();
 67c:	00000097          	auipc	ra,0x0
 680:	cf6080e7          	jalr	-778(ra) # 372 <unlock>
}
 684:	70a2                	ld	ra,40(sp)
 686:	7402                	ld	s0,32(sp)
 688:	64e2                	ld	s1,24(sp)
 68a:	6165                	addi	sp,sp,112
 68c:	8082                	ret

000000000000068e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 68e:	7179                	addi	sp,sp,-48
 690:	f422                	sd	s0,40(sp)
 692:	1800                	addi	s0,sp,48
 694:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 698:	fd843783          	ld	a5,-40(s0)
 69c:	17c1                	addi	a5,a5,-16
 69e:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a2:	00001797          	auipc	a5,0x1
 6a6:	d1e78793          	addi	a5,a5,-738 # 13c0 <freep>
 6aa:	639c                	ld	a5,0(a5)
 6ac:	fef43423          	sd	a5,-24(s0)
 6b0:	a815                	j	6e4 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b2:	fe843783          	ld	a5,-24(s0)
 6b6:	639c                	ld	a5,0(a5)
 6b8:	fe843703          	ld	a4,-24(s0)
 6bc:	00f76f63          	bltu	a4,a5,6da <free+0x4c>
 6c0:	fe043703          	ld	a4,-32(s0)
 6c4:	fe843783          	ld	a5,-24(s0)
 6c8:	02e7eb63          	bltu	a5,a4,6fe <free+0x70>
 6cc:	fe843783          	ld	a5,-24(s0)
 6d0:	639c                	ld	a5,0(a5)
 6d2:	fe043703          	ld	a4,-32(s0)
 6d6:	02f76463          	bltu	a4,a5,6fe <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6da:	fe843783          	ld	a5,-24(s0)
 6de:	639c                	ld	a5,0(a5)
 6e0:	fef43423          	sd	a5,-24(s0)
 6e4:	fe043703          	ld	a4,-32(s0)
 6e8:	fe843783          	ld	a5,-24(s0)
 6ec:	fce7f3e3          	bgeu	a5,a4,6b2 <free+0x24>
 6f0:	fe843783          	ld	a5,-24(s0)
 6f4:	639c                	ld	a5,0(a5)
 6f6:	fe043703          	ld	a4,-32(s0)
 6fa:	faf77ce3          	bgeu	a4,a5,6b2 <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6fe:	fe043783          	ld	a5,-32(s0)
 702:	479c                	lw	a5,8(a5)
 704:	1782                	slli	a5,a5,0x20
 706:	9381                	srli	a5,a5,0x20
 708:	0792                	slli	a5,a5,0x4
 70a:	fe043703          	ld	a4,-32(s0)
 70e:	973e                	add	a4,a4,a5
 710:	fe843783          	ld	a5,-24(s0)
 714:	639c                	ld	a5,0(a5)
 716:	02f71763          	bne	a4,a5,744 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 71a:	fe043783          	ld	a5,-32(s0)
 71e:	4798                	lw	a4,8(a5)
 720:	fe843783          	ld	a5,-24(s0)
 724:	639c                	ld	a5,0(a5)
 726:	479c                	lw	a5,8(a5)
 728:	9fb9                	addw	a5,a5,a4
 72a:	0007871b          	sext.w	a4,a5
 72e:	fe043783          	ld	a5,-32(s0)
 732:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 734:	fe843783          	ld	a5,-24(s0)
 738:	639c                	ld	a5,0(a5)
 73a:	6398                	ld	a4,0(a5)
 73c:	fe043783          	ld	a5,-32(s0)
 740:	e398                	sd	a4,0(a5)
 742:	a039                	j	750 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 744:	fe843783          	ld	a5,-24(s0)
 748:	6398                	ld	a4,0(a5)
 74a:	fe043783          	ld	a5,-32(s0)
 74e:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 750:	fe843783          	ld	a5,-24(s0)
 754:	479c                	lw	a5,8(a5)
 756:	1782                	slli	a5,a5,0x20
 758:	9381                	srli	a5,a5,0x20
 75a:	0792                	slli	a5,a5,0x4
 75c:	fe843703          	ld	a4,-24(s0)
 760:	97ba                	add	a5,a5,a4
 762:	fe043703          	ld	a4,-32(s0)
 766:	02f71563          	bne	a4,a5,790 <free+0x102>
    p->s.size += bp->s.size;
 76a:	fe843783          	ld	a5,-24(s0)
 76e:	4798                	lw	a4,8(a5)
 770:	fe043783          	ld	a5,-32(s0)
 774:	479c                	lw	a5,8(a5)
 776:	9fb9                	addw	a5,a5,a4
 778:	0007871b          	sext.w	a4,a5
 77c:	fe843783          	ld	a5,-24(s0)
 780:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 782:	fe043783          	ld	a5,-32(s0)
 786:	6398                	ld	a4,0(a5)
 788:	fe843783          	ld	a5,-24(s0)
 78c:	e398                	sd	a4,0(a5)
 78e:	a031                	j	79a <free+0x10c>
  } else
    p->s.ptr = bp;
 790:	fe843783          	ld	a5,-24(s0)
 794:	fe043703          	ld	a4,-32(s0)
 798:	e398                	sd	a4,0(a5)
  freep = p;
 79a:	00001797          	auipc	a5,0x1
 79e:	c2678793          	addi	a5,a5,-986 # 13c0 <freep>
 7a2:	fe843703          	ld	a4,-24(s0)
 7a6:	e398                	sd	a4,0(a5)
}
 7a8:	0001                	nop
 7aa:	7422                	ld	s0,40(sp)
 7ac:	6145                	addi	sp,sp,48
 7ae:	8082                	ret

00000000000007b0 <morecore>:

static Header*
morecore(uint nu)
{
 7b0:	7179                	addi	sp,sp,-48
 7b2:	f406                	sd	ra,40(sp)
 7b4:	f022                	sd	s0,32(sp)
 7b6:	1800                	addi	s0,sp,48
 7b8:	87aa                	mv	a5,a0
 7ba:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 7be:	fdc42783          	lw	a5,-36(s0)
 7c2:	0007871b          	sext.w	a4,a5
 7c6:	6785                	lui	a5,0x1
 7c8:	00f77563          	bgeu	a4,a5,7d2 <morecore+0x22>
    nu = 4096;
 7cc:	6785                	lui	a5,0x1
 7ce:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 7d2:	fdc42783          	lw	a5,-36(s0)
 7d6:	0047979b          	slliw	a5,a5,0x4
 7da:	2781                	sext.w	a5,a5
 7dc:	2781                	sext.w	a5,a5
 7de:	853e                	mv	a0,a5
 7e0:	00000097          	auipc	ra,0x0
 7e4:	b6a080e7          	jalr	-1174(ra) # 34a <sbrk>
 7e8:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 7ec:	fe843703          	ld	a4,-24(s0)
 7f0:	57fd                	li	a5,-1
 7f2:	00f71463          	bne	a4,a5,7fa <morecore+0x4a>
    return 0;
 7f6:	4781                	li	a5,0
 7f8:	a03d                	j	826 <morecore+0x76>
  hp = (Header*)p;
 7fa:	fe843783          	ld	a5,-24(s0)
 7fe:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 802:	fe043783          	ld	a5,-32(s0)
 806:	fdc42703          	lw	a4,-36(s0)
 80a:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 80c:	fe043783          	ld	a5,-32(s0)
 810:	07c1                	addi	a5,a5,16 # 1010 <digits+0x640>
 812:	853e                	mv	a0,a5
 814:	00000097          	auipc	ra,0x0
 818:	e7a080e7          	jalr	-390(ra) # 68e <free>
  return freep;
 81c:	00001797          	auipc	a5,0x1
 820:	ba478793          	addi	a5,a5,-1116 # 13c0 <freep>
 824:	639c                	ld	a5,0(a5)
}
 826:	853e                	mv	a0,a5
 828:	70a2                	ld	ra,40(sp)
 82a:	7402                	ld	s0,32(sp)
 82c:	6145                	addi	sp,sp,48
 82e:	8082                	ret

0000000000000830 <malloc>:

void*
malloc(uint nbytes)
{
 830:	7139                	addi	sp,sp,-64
 832:	fc06                	sd	ra,56(sp)
 834:	f822                	sd	s0,48(sp)
 836:	0080                	addi	s0,sp,64
 838:	87aa                	mv	a5,a0
 83a:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 83e:	fcc46783          	lwu	a5,-52(s0)
 842:	07bd                	addi	a5,a5,15
 844:	8391                	srli	a5,a5,0x4
 846:	2781                	sext.w	a5,a5
 848:	2785                	addiw	a5,a5,1
 84a:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 84e:	00001797          	auipc	a5,0x1
 852:	b7278793          	addi	a5,a5,-1166 # 13c0 <freep>
 856:	639c                	ld	a5,0(a5)
 858:	fef43023          	sd	a5,-32(s0)
 85c:	fe043783          	ld	a5,-32(s0)
 860:	ef95                	bnez	a5,89c <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 862:	00001797          	auipc	a5,0x1
 866:	b4e78793          	addi	a5,a5,-1202 # 13b0 <base>
 86a:	fef43023          	sd	a5,-32(s0)
 86e:	00001797          	auipc	a5,0x1
 872:	b5278793          	addi	a5,a5,-1198 # 13c0 <freep>
 876:	fe043703          	ld	a4,-32(s0)
 87a:	e398                	sd	a4,0(a5)
 87c:	00001797          	auipc	a5,0x1
 880:	b4478793          	addi	a5,a5,-1212 # 13c0 <freep>
 884:	6398                	ld	a4,0(a5)
 886:	00001797          	auipc	a5,0x1
 88a:	b2a78793          	addi	a5,a5,-1238 # 13b0 <base>
 88e:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 890:	00001797          	auipc	a5,0x1
 894:	b2078793          	addi	a5,a5,-1248 # 13b0 <base>
 898:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89c:	fe043783          	ld	a5,-32(s0)
 8a0:	639c                	ld	a5,0(a5)
 8a2:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 8a6:	fe843783          	ld	a5,-24(s0)
 8aa:	4798                	lw	a4,8(a5)
 8ac:	fdc42783          	lw	a5,-36(s0)
 8b0:	2781                	sext.w	a5,a5
 8b2:	06f76763          	bltu	a4,a5,920 <malloc+0xf0>
      if(p->s.size == nunits)
 8b6:	fe843783          	ld	a5,-24(s0)
 8ba:	4798                	lw	a4,8(a5)
 8bc:	fdc42783          	lw	a5,-36(s0)
 8c0:	2781                	sext.w	a5,a5
 8c2:	00e79963          	bne	a5,a4,8d4 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 8c6:	fe843783          	ld	a5,-24(s0)
 8ca:	6398                	ld	a4,0(a5)
 8cc:	fe043783          	ld	a5,-32(s0)
 8d0:	e398                	sd	a4,0(a5)
 8d2:	a825                	j	90a <malloc+0xda>
      else {
        p->s.size -= nunits;
 8d4:	fe843783          	ld	a5,-24(s0)
 8d8:	479c                	lw	a5,8(a5)
 8da:	fdc42703          	lw	a4,-36(s0)
 8de:	9f99                	subw	a5,a5,a4
 8e0:	0007871b          	sext.w	a4,a5
 8e4:	fe843783          	ld	a5,-24(s0)
 8e8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8ea:	fe843783          	ld	a5,-24(s0)
 8ee:	479c                	lw	a5,8(a5)
 8f0:	1782                	slli	a5,a5,0x20
 8f2:	9381                	srli	a5,a5,0x20
 8f4:	0792                	slli	a5,a5,0x4
 8f6:	fe843703          	ld	a4,-24(s0)
 8fa:	97ba                	add	a5,a5,a4
 8fc:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 900:	fe843783          	ld	a5,-24(s0)
 904:	fdc42703          	lw	a4,-36(s0)
 908:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 90a:	00001797          	auipc	a5,0x1
 90e:	ab678793          	addi	a5,a5,-1354 # 13c0 <freep>
 912:	fe043703          	ld	a4,-32(s0)
 916:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 918:	fe843783          	ld	a5,-24(s0)
 91c:	07c1                	addi	a5,a5,16
 91e:	a091                	j	962 <malloc+0x132>
    }
    if(p == freep)
 920:	00001797          	auipc	a5,0x1
 924:	aa078793          	addi	a5,a5,-1376 # 13c0 <freep>
 928:	639c                	ld	a5,0(a5)
 92a:	fe843703          	ld	a4,-24(s0)
 92e:	02f71063          	bne	a4,a5,94e <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 932:	fdc42783          	lw	a5,-36(s0)
 936:	853e                	mv	a0,a5
 938:	00000097          	auipc	ra,0x0
 93c:	e78080e7          	jalr	-392(ra) # 7b0 <morecore>
 940:	fea43423          	sd	a0,-24(s0)
 944:	fe843783          	ld	a5,-24(s0)
 948:	e399                	bnez	a5,94e <malloc+0x11e>
        return 0;
 94a:	4781                	li	a5,0
 94c:	a819                	j	962 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 94e:	fe843783          	ld	a5,-24(s0)
 952:	fef43023          	sd	a5,-32(s0)
 956:	fe843783          	ld	a5,-24(s0)
 95a:	639c                	ld	a5,0(a5)
 95c:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 960:	b799                	j	8a6 <malloc+0x76>
  }
}
 962:	853e                	mv	a0,a5
 964:	70e2                	ld	ra,56(sp)
 966:	7442                	ld	s0,48(sp)
 968:	6121                	addi	sp,sp,64
 96a:	8082                	ret
