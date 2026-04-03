
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   8:	4785                	li	a5,1
   a:	02a7df63          	bge	a5,a0,48 <main+0x48>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  26:	6088                	ld	a0,0(s1)
  28:	00000097          	auipc	ra,0x0
  2c:	1cc080e7          	jalr	460(ra) # 1f4 <atoi>
  30:	00000097          	auipc	ra,0x0
  34:	2ee080e7          	jalr	750(ra) # 31e <kill>
  for(i=1; i<argc; i++)
  38:	04a1                	addi	s1,s1,8
  3a:	ff2496e3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  3e:	4501                	li	a0,0
  40:	00000097          	auipc	ra,0x0
  44:	2ae080e7          	jalr	686(ra) # 2ee <exit>
  48:	e426                	sd	s1,8(sp)
  4a:	e04a                	sd	s2,0(sp)
    fprintf(2, "usage: kill pid...\n");
  4c:	00001597          	auipc	a1,0x1
  50:	95458593          	addi	a1,a1,-1708 # 9a0 <malloc+0x144>
  54:	4509                	li	a0,2
  56:	00000097          	auipc	ra,0x0
  5a:	5ea080e7          	jalr	1514(ra) # 640 <fprintf>
    exit(1);
  5e:	4505                	li	a0,1
  60:	00000097          	auipc	ra,0x0
  64:	28e080e7          	jalr	654(ra) # 2ee <exit>

0000000000000068 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  68:	1141                	addi	sp,sp,-16
  6a:	e406                	sd	ra,8(sp)
  6c:	e022                	sd	s0,0(sp)
  6e:	0800                	addi	s0,sp,16
  extern int main();
  main();
  70:	00000097          	auipc	ra,0x0
  74:	f90080e7          	jalr	-112(ra) # 0 <main>
  exit(0);
  78:	4501                	li	a0,0
  7a:	00000097          	auipc	ra,0x0
  7e:	274080e7          	jalr	628(ra) # 2ee <exit>

0000000000000082 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  82:	1141                	addi	sp,sp,-16
  84:	e422                	sd	s0,8(sp)
  86:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  88:	87aa                	mv	a5,a0
  8a:	0585                	addi	a1,a1,1
  8c:	0785                	addi	a5,a5,1
  8e:	fff5c703          	lbu	a4,-1(a1)
  92:	fee78fa3          	sb	a4,-1(a5)
  96:	fb75                	bnez	a4,8a <strcpy+0x8>
    ;
  return os;
}
  98:	6422                	ld	s0,8(sp)
  9a:	0141                	addi	sp,sp,16
  9c:	8082                	ret

000000000000009e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  9e:	1141                	addi	sp,sp,-16
  a0:	e422                	sd	s0,8(sp)
  a2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  a4:	00054783          	lbu	a5,0(a0)
  a8:	cb91                	beqz	a5,bc <strcmp+0x1e>
  aa:	0005c703          	lbu	a4,0(a1)
  ae:	00f71763          	bne	a4,a5,bc <strcmp+0x1e>
    p++, q++;
  b2:	0505                	addi	a0,a0,1
  b4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  b6:	00054783          	lbu	a5,0(a0)
  ba:	fbe5                	bnez	a5,aa <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  bc:	0005c503          	lbu	a0,0(a1)
}
  c0:	40a7853b          	subw	a0,a5,a0
  c4:	6422                	ld	s0,8(sp)
  c6:	0141                	addi	sp,sp,16
  c8:	8082                	ret

00000000000000ca <strlen>:

uint
strlen(const char *s)
{
  ca:	1141                	addi	sp,sp,-16
  cc:	e422                	sd	s0,8(sp)
  ce:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  d0:	00054783          	lbu	a5,0(a0)
  d4:	cf91                	beqz	a5,f0 <strlen+0x26>
  d6:	0505                	addi	a0,a0,1
  d8:	87aa                	mv	a5,a0
  da:	86be                	mv	a3,a5
  dc:	0785                	addi	a5,a5,1
  de:	fff7c703          	lbu	a4,-1(a5)
  e2:	ff65                	bnez	a4,da <strlen+0x10>
  e4:	40a6853b          	subw	a0,a3,a0
  e8:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  ea:	6422                	ld	s0,8(sp)
  ec:	0141                	addi	sp,sp,16
  ee:	8082                	ret
  for(n = 0; s[n]; n++)
  f0:	4501                	li	a0,0
  f2:	bfe5                	j	ea <strlen+0x20>

00000000000000f4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f4:	1141                	addi	sp,sp,-16
  f6:	e422                	sd	s0,8(sp)
  f8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  fa:	ca19                	beqz	a2,110 <memset+0x1c>
  fc:	87aa                	mv	a5,a0
  fe:	1602                	slli	a2,a2,0x20
 100:	9201                	srli	a2,a2,0x20
 102:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 106:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 10a:	0785                	addi	a5,a5,1
 10c:	fee79de3          	bne	a5,a4,106 <memset+0x12>
  }
  return dst;
}
 110:	6422                	ld	s0,8(sp)
 112:	0141                	addi	sp,sp,16
 114:	8082                	ret

0000000000000116 <strchr>:

char*
strchr(const char *s, char c)
{
 116:	1141                	addi	sp,sp,-16
 118:	e422                	sd	s0,8(sp)
 11a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 11c:	00054783          	lbu	a5,0(a0)
 120:	cb99                	beqz	a5,136 <strchr+0x20>
    if(*s == c)
 122:	00f58763          	beq	a1,a5,130 <strchr+0x1a>
  for(; *s; s++)
 126:	0505                	addi	a0,a0,1
 128:	00054783          	lbu	a5,0(a0)
 12c:	fbfd                	bnez	a5,122 <strchr+0xc>
      return (char*)s;
  return 0;
 12e:	4501                	li	a0,0
}
 130:	6422                	ld	s0,8(sp)
 132:	0141                	addi	sp,sp,16
 134:	8082                	ret
  return 0;
 136:	4501                	li	a0,0
 138:	bfe5                	j	130 <strchr+0x1a>

000000000000013a <gets>:

char*
gets(char *buf, int max)
{
 13a:	711d                	addi	sp,sp,-96
 13c:	ec86                	sd	ra,88(sp)
 13e:	e8a2                	sd	s0,80(sp)
 140:	e4a6                	sd	s1,72(sp)
 142:	e0ca                	sd	s2,64(sp)
 144:	fc4e                	sd	s3,56(sp)
 146:	f852                	sd	s4,48(sp)
 148:	f456                	sd	s5,40(sp)
 14a:	f05a                	sd	s6,32(sp)
 14c:	ec5e                	sd	s7,24(sp)
 14e:	1080                	addi	s0,sp,96
 150:	8baa                	mv	s7,a0
 152:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 154:	892a                	mv	s2,a0
 156:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 158:	4aa9                	li	s5,10
 15a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 15c:	89a6                	mv	s3,s1
 15e:	2485                	addiw	s1,s1,1
 160:	0344d863          	bge	s1,s4,190 <gets+0x56>
    cc = read(0, &c, 1);
 164:	4605                	li	a2,1
 166:	faf40593          	addi	a1,s0,-81
 16a:	4501                	li	a0,0
 16c:	00000097          	auipc	ra,0x0
 170:	19a080e7          	jalr	410(ra) # 306 <read>
    if(cc < 1)
 174:	00a05e63          	blez	a0,190 <gets+0x56>
    buf[i++] = c;
 178:	faf44783          	lbu	a5,-81(s0)
 17c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 180:	01578763          	beq	a5,s5,18e <gets+0x54>
 184:	0905                	addi	s2,s2,1
 186:	fd679be3          	bne	a5,s6,15c <gets+0x22>
    buf[i++] = c;
 18a:	89a6                	mv	s3,s1
 18c:	a011                	j	190 <gets+0x56>
 18e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 190:	99de                	add	s3,s3,s7
 192:	00098023          	sb	zero,0(s3)
  return buf;
}
 196:	855e                	mv	a0,s7
 198:	60e6                	ld	ra,88(sp)
 19a:	6446                	ld	s0,80(sp)
 19c:	64a6                	ld	s1,72(sp)
 19e:	6906                	ld	s2,64(sp)
 1a0:	79e2                	ld	s3,56(sp)
 1a2:	7a42                	ld	s4,48(sp)
 1a4:	7aa2                	ld	s5,40(sp)
 1a6:	7b02                	ld	s6,32(sp)
 1a8:	6be2                	ld	s7,24(sp)
 1aa:	6125                	addi	sp,sp,96
 1ac:	8082                	ret

00000000000001ae <stat>:

int
stat(const char *n, struct stat *st)
{
 1ae:	1101                	addi	sp,sp,-32
 1b0:	ec06                	sd	ra,24(sp)
 1b2:	e822                	sd	s0,16(sp)
 1b4:	e04a                	sd	s2,0(sp)
 1b6:	1000                	addi	s0,sp,32
 1b8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ba:	4581                	li	a1,0
 1bc:	00000097          	auipc	ra,0x0
 1c0:	172080e7          	jalr	370(ra) # 32e <open>
  if(fd < 0)
 1c4:	02054663          	bltz	a0,1f0 <stat+0x42>
 1c8:	e426                	sd	s1,8(sp)
 1ca:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1cc:	85ca                	mv	a1,s2
 1ce:	00000097          	auipc	ra,0x0
 1d2:	178080e7          	jalr	376(ra) # 346 <fstat>
 1d6:	892a                	mv	s2,a0
  close(fd);
 1d8:	8526                	mv	a0,s1
 1da:	00000097          	auipc	ra,0x0
 1de:	13c080e7          	jalr	316(ra) # 316 <close>
  return r;
 1e2:	64a2                	ld	s1,8(sp)
}
 1e4:	854a                	mv	a0,s2
 1e6:	60e2                	ld	ra,24(sp)
 1e8:	6442                	ld	s0,16(sp)
 1ea:	6902                	ld	s2,0(sp)
 1ec:	6105                	addi	sp,sp,32
 1ee:	8082                	ret
    return -1;
 1f0:	597d                	li	s2,-1
 1f2:	bfcd                	j	1e4 <stat+0x36>

00000000000001f4 <atoi>:

int
atoi(const char *s)
{
 1f4:	1141                	addi	sp,sp,-16
 1f6:	e422                	sd	s0,8(sp)
 1f8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1fa:	00054683          	lbu	a3,0(a0)
 1fe:	fd06879b          	addiw	a5,a3,-48
 202:	0ff7f793          	zext.b	a5,a5
 206:	4625                	li	a2,9
 208:	02f66863          	bltu	a2,a5,238 <atoi+0x44>
 20c:	872a                	mv	a4,a0
  n = 0;
 20e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 210:	0705                	addi	a4,a4,1
 212:	0025179b          	slliw	a5,a0,0x2
 216:	9fa9                	addw	a5,a5,a0
 218:	0017979b          	slliw	a5,a5,0x1
 21c:	9fb5                	addw	a5,a5,a3
 21e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 222:	00074683          	lbu	a3,0(a4)
 226:	fd06879b          	addiw	a5,a3,-48
 22a:	0ff7f793          	zext.b	a5,a5
 22e:	fef671e3          	bgeu	a2,a5,210 <atoi+0x1c>
  return n;
}
 232:	6422                	ld	s0,8(sp)
 234:	0141                	addi	sp,sp,16
 236:	8082                	ret
  n = 0;
 238:	4501                	li	a0,0
 23a:	bfe5                	j	232 <atoi+0x3e>

000000000000023c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 23c:	1141                	addi	sp,sp,-16
 23e:	e422                	sd	s0,8(sp)
 240:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 242:	02b57463          	bgeu	a0,a1,26a <memmove+0x2e>
    while(n-- > 0)
 246:	00c05f63          	blez	a2,264 <memmove+0x28>
 24a:	1602                	slli	a2,a2,0x20
 24c:	9201                	srli	a2,a2,0x20
 24e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 252:	872a                	mv	a4,a0
      *dst++ = *src++;
 254:	0585                	addi	a1,a1,1
 256:	0705                	addi	a4,a4,1
 258:	fff5c683          	lbu	a3,-1(a1)
 25c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 260:	fef71ae3          	bne	a4,a5,254 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 264:	6422                	ld	s0,8(sp)
 266:	0141                	addi	sp,sp,16
 268:	8082                	ret
    dst += n;
 26a:	00c50733          	add	a4,a0,a2
    src += n;
 26e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 270:	fec05ae3          	blez	a2,264 <memmove+0x28>
 274:	fff6079b          	addiw	a5,a2,-1
 278:	1782                	slli	a5,a5,0x20
 27a:	9381                	srli	a5,a5,0x20
 27c:	fff7c793          	not	a5,a5
 280:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 282:	15fd                	addi	a1,a1,-1
 284:	177d                	addi	a4,a4,-1
 286:	0005c683          	lbu	a3,0(a1)
 28a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 28e:	fee79ae3          	bne	a5,a4,282 <memmove+0x46>
 292:	bfc9                	j	264 <memmove+0x28>

0000000000000294 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 294:	1141                	addi	sp,sp,-16
 296:	e422                	sd	s0,8(sp)
 298:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 29a:	ca05                	beqz	a2,2ca <memcmp+0x36>
 29c:	fff6069b          	addiw	a3,a2,-1
 2a0:	1682                	slli	a3,a3,0x20
 2a2:	9281                	srli	a3,a3,0x20
 2a4:	0685                	addi	a3,a3,1
 2a6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2a8:	00054783          	lbu	a5,0(a0)
 2ac:	0005c703          	lbu	a4,0(a1)
 2b0:	00e79863          	bne	a5,a4,2c0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2b4:	0505                	addi	a0,a0,1
    p2++;
 2b6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2b8:	fed518e3          	bne	a0,a3,2a8 <memcmp+0x14>
  }
  return 0;
 2bc:	4501                	li	a0,0
 2be:	a019                	j	2c4 <memcmp+0x30>
      return *p1 - *p2;
 2c0:	40e7853b          	subw	a0,a5,a4
}
 2c4:	6422                	ld	s0,8(sp)
 2c6:	0141                	addi	sp,sp,16
 2c8:	8082                	ret
  return 0;
 2ca:	4501                	li	a0,0
 2cc:	bfe5                	j	2c4 <memcmp+0x30>

00000000000002ce <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2ce:	1141                	addi	sp,sp,-16
 2d0:	e406                	sd	ra,8(sp)
 2d2:	e022                	sd	s0,0(sp)
 2d4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2d6:	00000097          	auipc	ra,0x0
 2da:	f66080e7          	jalr	-154(ra) # 23c <memmove>
}
 2de:	60a2                	ld	ra,8(sp)
 2e0:	6402                	ld	s0,0(sp)
 2e2:	0141                	addi	sp,sp,16
 2e4:	8082                	ret

00000000000002e6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2e6:	4885                	li	a7,1
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <exit>:
.global exit
exit:
 li a7, SYS_exit
 2ee:	4889                	li	a7,2
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2f6:	488d                	li	a7,3
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2fe:	4891                	li	a7,4
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <read>:
.global read
read:
 li a7, SYS_read
 306:	4895                	li	a7,5
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <write>:
.global write
write:
 li a7, SYS_write
 30e:	48c1                	li	a7,16
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <close>:
.global close
close:
 li a7, SYS_close
 316:	48d5                	li	a7,21
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <kill>:
.global kill
kill:
 li a7, SYS_kill
 31e:	4899                	li	a7,6
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <exec>:
.global exec
exec:
 li a7, SYS_exec
 326:	489d                	li	a7,7
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <open>:
.global open
open:
 li a7, SYS_open
 32e:	48bd                	li	a7,15
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 336:	48c5                	li	a7,17
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 33e:	48c9                	li	a7,18
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 346:	48a1                	li	a7,8
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <link>:
.global link
link:
 li a7, SYS_link
 34e:	48cd                	li	a7,19
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 356:	48d1                	li	a7,20
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 35e:	48a5                	li	a7,9
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <dup>:
.global dup
dup:
 li a7, SYS_dup
 366:	48a9                	li	a7,10
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 36e:	48ad                	li	a7,11
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 376:	48b1                	li	a7,12
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 37e:	48b5                	li	a7,13
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 386:	48b9                	li	a7,14
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <yield>:
.global yield
yield:
 li a7, SYS_yield
 38e:	48d9                	li	a7,22
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <lock>:
.global lock
lock:
 li a7, SYS_lock
 396:	48dd                	li	a7,23
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <unlock>:
.global unlock
unlock:
 li a7, SYS_unlock
 39e:	48e1                	li	a7,24
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3a6:	1101                	addi	sp,sp,-32
 3a8:	ec06                	sd	ra,24(sp)
 3aa:	e822                	sd	s0,16(sp)
 3ac:	1000                	addi	s0,sp,32
 3ae:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3b2:	4605                	li	a2,1
 3b4:	fef40593          	addi	a1,s0,-17
 3b8:	00000097          	auipc	ra,0x0
 3bc:	f56080e7          	jalr	-170(ra) # 30e <write>
}
 3c0:	60e2                	ld	ra,24(sp)
 3c2:	6442                	ld	s0,16(sp)
 3c4:	6105                	addi	sp,sp,32
 3c6:	8082                	ret

00000000000003c8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3c8:	7139                	addi	sp,sp,-64
 3ca:	fc06                	sd	ra,56(sp)
 3cc:	f822                	sd	s0,48(sp)
 3ce:	f426                	sd	s1,40(sp)
 3d0:	0080                	addi	s0,sp,64
 3d2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3d4:	c299                	beqz	a3,3da <printint+0x12>
 3d6:	0805cb63          	bltz	a1,46c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3da:	2581                	sext.w	a1,a1
  neg = 0;
 3dc:	4881                	li	a7,0
 3de:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3e2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3e4:	2601                	sext.w	a2,a2
 3e6:	00000517          	auipc	a0,0x0
 3ea:	63250513          	addi	a0,a0,1586 # a18 <digits>
 3ee:	883a                	mv	a6,a4
 3f0:	2705                	addiw	a4,a4,1
 3f2:	02c5f7bb          	remuw	a5,a1,a2
 3f6:	1782                	slli	a5,a5,0x20
 3f8:	9381                	srli	a5,a5,0x20
 3fa:	97aa                	add	a5,a5,a0
 3fc:	0007c783          	lbu	a5,0(a5)
 400:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 404:	0005879b          	sext.w	a5,a1
 408:	02c5d5bb          	divuw	a1,a1,a2
 40c:	0685                	addi	a3,a3,1
 40e:	fec7f0e3          	bgeu	a5,a2,3ee <printint+0x26>
  if(neg)
 412:	00088c63          	beqz	a7,42a <printint+0x62>
    buf[i++] = '-';
 416:	fd070793          	addi	a5,a4,-48
 41a:	00878733          	add	a4,a5,s0
 41e:	02d00793          	li	a5,45
 422:	fef70823          	sb	a5,-16(a4)
 426:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 42a:	02e05c63          	blez	a4,462 <printint+0x9a>
 42e:	f04a                	sd	s2,32(sp)
 430:	ec4e                	sd	s3,24(sp)
 432:	fc040793          	addi	a5,s0,-64
 436:	00e78933          	add	s2,a5,a4
 43a:	fff78993          	addi	s3,a5,-1
 43e:	99ba                	add	s3,s3,a4
 440:	377d                	addiw	a4,a4,-1
 442:	1702                	slli	a4,a4,0x20
 444:	9301                	srli	a4,a4,0x20
 446:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 44a:	fff94583          	lbu	a1,-1(s2)
 44e:	8526                	mv	a0,s1
 450:	00000097          	auipc	ra,0x0
 454:	f56080e7          	jalr	-170(ra) # 3a6 <putc>
  while(--i >= 0)
 458:	197d                	addi	s2,s2,-1
 45a:	ff3918e3          	bne	s2,s3,44a <printint+0x82>
 45e:	7902                	ld	s2,32(sp)
 460:	69e2                	ld	s3,24(sp)
}
 462:	70e2                	ld	ra,56(sp)
 464:	7442                	ld	s0,48(sp)
 466:	74a2                	ld	s1,40(sp)
 468:	6121                	addi	sp,sp,64
 46a:	8082                	ret
    x = -xx;
 46c:	40b005bb          	negw	a1,a1
    neg = 1;
 470:	4885                	li	a7,1
    x = -xx;
 472:	b7b5                	j	3de <printint+0x16>

0000000000000474 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 474:	715d                	addi	sp,sp,-80
 476:	e486                	sd	ra,72(sp)
 478:	e0a2                	sd	s0,64(sp)
 47a:	f84a                	sd	s2,48(sp)
 47c:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 47e:	0005c903          	lbu	s2,0(a1)
 482:	1a090a63          	beqz	s2,636 <vprintf+0x1c2>
 486:	fc26                	sd	s1,56(sp)
 488:	f44e                	sd	s3,40(sp)
 48a:	f052                	sd	s4,32(sp)
 48c:	ec56                	sd	s5,24(sp)
 48e:	e85a                	sd	s6,16(sp)
 490:	e45e                	sd	s7,8(sp)
 492:	8aaa                	mv	s5,a0
 494:	8bb2                	mv	s7,a2
 496:	00158493          	addi	s1,a1,1
  state = 0;
 49a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 49c:	02500a13          	li	s4,37
 4a0:	4b55                	li	s6,21
 4a2:	a839                	j	4c0 <vprintf+0x4c>
        putc(fd, c);
 4a4:	85ca                	mv	a1,s2
 4a6:	8556                	mv	a0,s5
 4a8:	00000097          	auipc	ra,0x0
 4ac:	efe080e7          	jalr	-258(ra) # 3a6 <putc>
 4b0:	a019                	j	4b6 <vprintf+0x42>
    } else if(state == '%'){
 4b2:	01498d63          	beq	s3,s4,4cc <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 4b6:	0485                	addi	s1,s1,1
 4b8:	fff4c903          	lbu	s2,-1(s1)
 4bc:	16090763          	beqz	s2,62a <vprintf+0x1b6>
    if(state == 0){
 4c0:	fe0999e3          	bnez	s3,4b2 <vprintf+0x3e>
      if(c == '%'){
 4c4:	ff4910e3          	bne	s2,s4,4a4 <vprintf+0x30>
        state = '%';
 4c8:	89d2                	mv	s3,s4
 4ca:	b7f5                	j	4b6 <vprintf+0x42>
      if(c == 'd'){
 4cc:	13490463          	beq	s2,s4,5f4 <vprintf+0x180>
 4d0:	f9d9079b          	addiw	a5,s2,-99
 4d4:	0ff7f793          	zext.b	a5,a5
 4d8:	12fb6763          	bltu	s6,a5,606 <vprintf+0x192>
 4dc:	f9d9079b          	addiw	a5,s2,-99
 4e0:	0ff7f713          	zext.b	a4,a5
 4e4:	12eb6163          	bltu	s6,a4,606 <vprintf+0x192>
 4e8:	00271793          	slli	a5,a4,0x2
 4ec:	00000717          	auipc	a4,0x0
 4f0:	4d470713          	addi	a4,a4,1236 # 9c0 <malloc+0x164>
 4f4:	97ba                	add	a5,a5,a4
 4f6:	439c                	lw	a5,0(a5)
 4f8:	97ba                	add	a5,a5,a4
 4fa:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4fc:	008b8913          	addi	s2,s7,8
 500:	4685                	li	a3,1
 502:	4629                	li	a2,10
 504:	000ba583          	lw	a1,0(s7)
 508:	8556                	mv	a0,s5
 50a:	00000097          	auipc	ra,0x0
 50e:	ebe080e7          	jalr	-322(ra) # 3c8 <printint>
 512:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 514:	4981                	li	s3,0
 516:	b745                	j	4b6 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 518:	008b8913          	addi	s2,s7,8
 51c:	4681                	li	a3,0
 51e:	4629                	li	a2,10
 520:	000ba583          	lw	a1,0(s7)
 524:	8556                	mv	a0,s5
 526:	00000097          	auipc	ra,0x0
 52a:	ea2080e7          	jalr	-350(ra) # 3c8 <printint>
 52e:	8bca                	mv	s7,s2
      state = 0;
 530:	4981                	li	s3,0
 532:	b751                	j	4b6 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 534:	008b8913          	addi	s2,s7,8
 538:	4681                	li	a3,0
 53a:	4641                	li	a2,16
 53c:	000ba583          	lw	a1,0(s7)
 540:	8556                	mv	a0,s5
 542:	00000097          	auipc	ra,0x0
 546:	e86080e7          	jalr	-378(ra) # 3c8 <printint>
 54a:	8bca                	mv	s7,s2
      state = 0;
 54c:	4981                	li	s3,0
 54e:	b7a5                	j	4b6 <vprintf+0x42>
 550:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 552:	008b8c13          	addi	s8,s7,8
 556:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 55a:	03000593          	li	a1,48
 55e:	8556                	mv	a0,s5
 560:	00000097          	auipc	ra,0x0
 564:	e46080e7          	jalr	-442(ra) # 3a6 <putc>
  putc(fd, 'x');
 568:	07800593          	li	a1,120
 56c:	8556                	mv	a0,s5
 56e:	00000097          	auipc	ra,0x0
 572:	e38080e7          	jalr	-456(ra) # 3a6 <putc>
 576:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 578:	00000b97          	auipc	s7,0x0
 57c:	4a0b8b93          	addi	s7,s7,1184 # a18 <digits>
 580:	03c9d793          	srli	a5,s3,0x3c
 584:	97de                	add	a5,a5,s7
 586:	0007c583          	lbu	a1,0(a5)
 58a:	8556                	mv	a0,s5
 58c:	00000097          	auipc	ra,0x0
 590:	e1a080e7          	jalr	-486(ra) # 3a6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 594:	0992                	slli	s3,s3,0x4
 596:	397d                	addiw	s2,s2,-1
 598:	fe0914e3          	bnez	s2,580 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 59c:	8be2                	mv	s7,s8
      state = 0;
 59e:	4981                	li	s3,0
 5a0:	6c02                	ld	s8,0(sp)
 5a2:	bf11                	j	4b6 <vprintf+0x42>
        s = va_arg(ap, char*);
 5a4:	008b8993          	addi	s3,s7,8
 5a8:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5ac:	02090163          	beqz	s2,5ce <vprintf+0x15a>
        while(*s != 0){
 5b0:	00094583          	lbu	a1,0(s2)
 5b4:	c9a5                	beqz	a1,624 <vprintf+0x1b0>
          putc(fd, *s);
 5b6:	8556                	mv	a0,s5
 5b8:	00000097          	auipc	ra,0x0
 5bc:	dee080e7          	jalr	-530(ra) # 3a6 <putc>
          s++;
 5c0:	0905                	addi	s2,s2,1
        while(*s != 0){
 5c2:	00094583          	lbu	a1,0(s2)
 5c6:	f9e5                	bnez	a1,5b6 <vprintf+0x142>
        s = va_arg(ap, char*);
 5c8:	8bce                	mv	s7,s3
      state = 0;
 5ca:	4981                	li	s3,0
 5cc:	b5ed                	j	4b6 <vprintf+0x42>
          s = "(null)";
 5ce:	00000917          	auipc	s2,0x0
 5d2:	3ea90913          	addi	s2,s2,1002 # 9b8 <malloc+0x15c>
        while(*s != 0){
 5d6:	02800593          	li	a1,40
 5da:	bff1                	j	5b6 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 5dc:	008b8913          	addi	s2,s7,8
 5e0:	000bc583          	lbu	a1,0(s7)
 5e4:	8556                	mv	a0,s5
 5e6:	00000097          	auipc	ra,0x0
 5ea:	dc0080e7          	jalr	-576(ra) # 3a6 <putc>
 5ee:	8bca                	mv	s7,s2
      state = 0;
 5f0:	4981                	li	s3,0
 5f2:	b5d1                	j	4b6 <vprintf+0x42>
        putc(fd, c);
 5f4:	02500593          	li	a1,37
 5f8:	8556                	mv	a0,s5
 5fa:	00000097          	auipc	ra,0x0
 5fe:	dac080e7          	jalr	-596(ra) # 3a6 <putc>
      state = 0;
 602:	4981                	li	s3,0
 604:	bd4d                	j	4b6 <vprintf+0x42>
        putc(fd, '%');
 606:	02500593          	li	a1,37
 60a:	8556                	mv	a0,s5
 60c:	00000097          	auipc	ra,0x0
 610:	d9a080e7          	jalr	-614(ra) # 3a6 <putc>
        putc(fd, c);
 614:	85ca                	mv	a1,s2
 616:	8556                	mv	a0,s5
 618:	00000097          	auipc	ra,0x0
 61c:	d8e080e7          	jalr	-626(ra) # 3a6 <putc>
      state = 0;
 620:	4981                	li	s3,0
 622:	bd51                	j	4b6 <vprintf+0x42>
        s = va_arg(ap, char*);
 624:	8bce                	mv	s7,s3
      state = 0;
 626:	4981                	li	s3,0
 628:	b579                	j	4b6 <vprintf+0x42>
 62a:	74e2                	ld	s1,56(sp)
 62c:	79a2                	ld	s3,40(sp)
 62e:	7a02                	ld	s4,32(sp)
 630:	6ae2                	ld	s5,24(sp)
 632:	6b42                	ld	s6,16(sp)
 634:	6ba2                	ld	s7,8(sp)
    }
  }
}
 636:	60a6                	ld	ra,72(sp)
 638:	6406                	ld	s0,64(sp)
 63a:	7942                	ld	s2,48(sp)
 63c:	6161                	addi	sp,sp,80
 63e:	8082                	ret

0000000000000640 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 640:	715d                	addi	sp,sp,-80
 642:	ec06                	sd	ra,24(sp)
 644:	e822                	sd	s0,16(sp)
 646:	1000                	addi	s0,sp,32
 648:	e010                	sd	a2,0(s0)
 64a:	e414                	sd	a3,8(s0)
 64c:	e818                	sd	a4,16(s0)
 64e:	ec1c                	sd	a5,24(s0)
 650:	03043023          	sd	a6,32(s0)
 654:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 658:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 65c:	8622                	mv	a2,s0
 65e:	00000097          	auipc	ra,0x0
 662:	e16080e7          	jalr	-490(ra) # 474 <vprintf>
}
 666:	60e2                	ld	ra,24(sp)
 668:	6442                	ld	s0,16(sp)
 66a:	6161                	addi	sp,sp,80
 66c:	8082                	ret

000000000000066e <printf>:

void
printf(const char *fmt, ...)
{
 66e:	7159                	addi	sp,sp,-112
 670:	f406                	sd	ra,40(sp)
 672:	f022                	sd	s0,32(sp)
 674:	ec26                	sd	s1,24(sp)
 676:	1800                	addi	s0,sp,48
 678:	84aa                	mv	s1,a0
 67a:	e40c                	sd	a1,8(s0)
 67c:	e810                	sd	a2,16(s0)
 67e:	ec14                	sd	a3,24(s0)
 680:	f018                	sd	a4,32(s0)
 682:	f41c                	sd	a5,40(s0)
 684:	03043823          	sd	a6,48(s0)
 688:	03143c23          	sd	a7,56(s0)
  va_list ap;

  lock();
 68c:	00000097          	auipc	ra,0x0
 690:	d0a080e7          	jalr	-758(ra) # 396 <lock>
  va_start(ap, fmt);
 694:	00840613          	addi	a2,s0,8
 698:	fcc43c23          	sd	a2,-40(s0)
  vprintf(1, fmt, ap);
 69c:	85a6                	mv	a1,s1
 69e:	4505                	li	a0,1
 6a0:	00000097          	auipc	ra,0x0
 6a4:	dd4080e7          	jalr	-556(ra) # 474 <vprintf>
  unlock();
 6a8:	00000097          	auipc	ra,0x0
 6ac:	cf6080e7          	jalr	-778(ra) # 39e <unlock>
}
 6b0:	70a2                	ld	ra,40(sp)
 6b2:	7402                	ld	s0,32(sp)
 6b4:	64e2                	ld	s1,24(sp)
 6b6:	6165                	addi	sp,sp,112
 6b8:	8082                	ret

00000000000006ba <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ba:	7179                	addi	sp,sp,-48
 6bc:	f422                	sd	s0,40(sp)
 6be:	1800                	addi	s0,sp,48
 6c0:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6c4:	fd843783          	ld	a5,-40(s0)
 6c8:	17c1                	addi	a5,a5,-16
 6ca:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ce:	00001797          	auipc	a5,0x1
 6d2:	d0278793          	addi	a5,a5,-766 # 13d0 <freep>
 6d6:	639c                	ld	a5,0(a5)
 6d8:	fef43423          	sd	a5,-24(s0)
 6dc:	a815                	j	710 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6de:	fe843783          	ld	a5,-24(s0)
 6e2:	639c                	ld	a5,0(a5)
 6e4:	fe843703          	ld	a4,-24(s0)
 6e8:	00f76f63          	bltu	a4,a5,706 <free+0x4c>
 6ec:	fe043703          	ld	a4,-32(s0)
 6f0:	fe843783          	ld	a5,-24(s0)
 6f4:	02e7eb63          	bltu	a5,a4,72a <free+0x70>
 6f8:	fe843783          	ld	a5,-24(s0)
 6fc:	639c                	ld	a5,0(a5)
 6fe:	fe043703          	ld	a4,-32(s0)
 702:	02f76463          	bltu	a4,a5,72a <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 706:	fe843783          	ld	a5,-24(s0)
 70a:	639c                	ld	a5,0(a5)
 70c:	fef43423          	sd	a5,-24(s0)
 710:	fe043703          	ld	a4,-32(s0)
 714:	fe843783          	ld	a5,-24(s0)
 718:	fce7f3e3          	bgeu	a5,a4,6de <free+0x24>
 71c:	fe843783          	ld	a5,-24(s0)
 720:	639c                	ld	a5,0(a5)
 722:	fe043703          	ld	a4,-32(s0)
 726:	faf77ce3          	bgeu	a4,a5,6de <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 72a:	fe043783          	ld	a5,-32(s0)
 72e:	479c                	lw	a5,8(a5)
 730:	1782                	slli	a5,a5,0x20
 732:	9381                	srli	a5,a5,0x20
 734:	0792                	slli	a5,a5,0x4
 736:	fe043703          	ld	a4,-32(s0)
 73a:	973e                	add	a4,a4,a5
 73c:	fe843783          	ld	a5,-24(s0)
 740:	639c                	ld	a5,0(a5)
 742:	02f71763          	bne	a4,a5,770 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 746:	fe043783          	ld	a5,-32(s0)
 74a:	4798                	lw	a4,8(a5)
 74c:	fe843783          	ld	a5,-24(s0)
 750:	639c                	ld	a5,0(a5)
 752:	479c                	lw	a5,8(a5)
 754:	9fb9                	addw	a5,a5,a4
 756:	0007871b          	sext.w	a4,a5
 75a:	fe043783          	ld	a5,-32(s0)
 75e:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 760:	fe843783          	ld	a5,-24(s0)
 764:	639c                	ld	a5,0(a5)
 766:	6398                	ld	a4,0(a5)
 768:	fe043783          	ld	a5,-32(s0)
 76c:	e398                	sd	a4,0(a5)
 76e:	a039                	j	77c <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 770:	fe843783          	ld	a5,-24(s0)
 774:	6398                	ld	a4,0(a5)
 776:	fe043783          	ld	a5,-32(s0)
 77a:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 77c:	fe843783          	ld	a5,-24(s0)
 780:	479c                	lw	a5,8(a5)
 782:	1782                	slli	a5,a5,0x20
 784:	9381                	srli	a5,a5,0x20
 786:	0792                	slli	a5,a5,0x4
 788:	fe843703          	ld	a4,-24(s0)
 78c:	97ba                	add	a5,a5,a4
 78e:	fe043703          	ld	a4,-32(s0)
 792:	02f71563          	bne	a4,a5,7bc <free+0x102>
    p->s.size += bp->s.size;
 796:	fe843783          	ld	a5,-24(s0)
 79a:	4798                	lw	a4,8(a5)
 79c:	fe043783          	ld	a5,-32(s0)
 7a0:	479c                	lw	a5,8(a5)
 7a2:	9fb9                	addw	a5,a5,a4
 7a4:	0007871b          	sext.w	a4,a5
 7a8:	fe843783          	ld	a5,-24(s0)
 7ac:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7ae:	fe043783          	ld	a5,-32(s0)
 7b2:	6398                	ld	a4,0(a5)
 7b4:	fe843783          	ld	a5,-24(s0)
 7b8:	e398                	sd	a4,0(a5)
 7ba:	a031                	j	7c6 <free+0x10c>
  } else
    p->s.ptr = bp;
 7bc:	fe843783          	ld	a5,-24(s0)
 7c0:	fe043703          	ld	a4,-32(s0)
 7c4:	e398                	sd	a4,0(a5)
  freep = p;
 7c6:	00001797          	auipc	a5,0x1
 7ca:	c0a78793          	addi	a5,a5,-1014 # 13d0 <freep>
 7ce:	fe843703          	ld	a4,-24(s0)
 7d2:	e398                	sd	a4,0(a5)
}
 7d4:	0001                	nop
 7d6:	7422                	ld	s0,40(sp)
 7d8:	6145                	addi	sp,sp,48
 7da:	8082                	ret

00000000000007dc <morecore>:

static Header*
morecore(uint nu)
{
 7dc:	7179                	addi	sp,sp,-48
 7de:	f406                	sd	ra,40(sp)
 7e0:	f022                	sd	s0,32(sp)
 7e2:	1800                	addi	s0,sp,48
 7e4:	87aa                	mv	a5,a0
 7e6:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 7ea:	fdc42783          	lw	a5,-36(s0)
 7ee:	0007871b          	sext.w	a4,a5
 7f2:	6785                	lui	a5,0x1
 7f4:	00f77563          	bgeu	a4,a5,7fe <morecore+0x22>
    nu = 4096;
 7f8:	6785                	lui	a5,0x1
 7fa:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 7fe:	fdc42783          	lw	a5,-36(s0)
 802:	0047979b          	slliw	a5,a5,0x4
 806:	2781                	sext.w	a5,a5
 808:	2781                	sext.w	a5,a5
 80a:	853e                	mv	a0,a5
 80c:	00000097          	auipc	ra,0x0
 810:	b6a080e7          	jalr	-1174(ra) # 376 <sbrk>
 814:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 818:	fe843703          	ld	a4,-24(s0)
 81c:	57fd                	li	a5,-1
 81e:	00f71463          	bne	a4,a5,826 <morecore+0x4a>
    return 0;
 822:	4781                	li	a5,0
 824:	a03d                	j	852 <morecore+0x76>
  hp = (Header*)p;
 826:	fe843783          	ld	a5,-24(s0)
 82a:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 82e:	fe043783          	ld	a5,-32(s0)
 832:	fdc42703          	lw	a4,-36(s0)
 836:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 838:	fe043783          	ld	a5,-32(s0)
 83c:	07c1                	addi	a5,a5,16 # 1010 <digits+0x5f8>
 83e:	853e                	mv	a0,a5
 840:	00000097          	auipc	ra,0x0
 844:	e7a080e7          	jalr	-390(ra) # 6ba <free>
  return freep;
 848:	00001797          	auipc	a5,0x1
 84c:	b8878793          	addi	a5,a5,-1144 # 13d0 <freep>
 850:	639c                	ld	a5,0(a5)
}
 852:	853e                	mv	a0,a5
 854:	70a2                	ld	ra,40(sp)
 856:	7402                	ld	s0,32(sp)
 858:	6145                	addi	sp,sp,48
 85a:	8082                	ret

000000000000085c <malloc>:

void*
malloc(uint nbytes)
{
 85c:	7139                	addi	sp,sp,-64
 85e:	fc06                	sd	ra,56(sp)
 860:	f822                	sd	s0,48(sp)
 862:	0080                	addi	s0,sp,64
 864:	87aa                	mv	a5,a0
 866:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 86a:	fcc46783          	lwu	a5,-52(s0)
 86e:	07bd                	addi	a5,a5,15
 870:	8391                	srli	a5,a5,0x4
 872:	2781                	sext.w	a5,a5
 874:	2785                	addiw	a5,a5,1
 876:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 87a:	00001797          	auipc	a5,0x1
 87e:	b5678793          	addi	a5,a5,-1194 # 13d0 <freep>
 882:	639c                	ld	a5,0(a5)
 884:	fef43023          	sd	a5,-32(s0)
 888:	fe043783          	ld	a5,-32(s0)
 88c:	ef95                	bnez	a5,8c8 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 88e:	00001797          	auipc	a5,0x1
 892:	b3278793          	addi	a5,a5,-1230 # 13c0 <base>
 896:	fef43023          	sd	a5,-32(s0)
 89a:	00001797          	auipc	a5,0x1
 89e:	b3678793          	addi	a5,a5,-1226 # 13d0 <freep>
 8a2:	fe043703          	ld	a4,-32(s0)
 8a6:	e398                	sd	a4,0(a5)
 8a8:	00001797          	auipc	a5,0x1
 8ac:	b2878793          	addi	a5,a5,-1240 # 13d0 <freep>
 8b0:	6398                	ld	a4,0(a5)
 8b2:	00001797          	auipc	a5,0x1
 8b6:	b0e78793          	addi	a5,a5,-1266 # 13c0 <base>
 8ba:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 8bc:	00001797          	auipc	a5,0x1
 8c0:	b0478793          	addi	a5,a5,-1276 # 13c0 <base>
 8c4:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c8:	fe043783          	ld	a5,-32(s0)
 8cc:	639c                	ld	a5,0(a5)
 8ce:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 8d2:	fe843783          	ld	a5,-24(s0)
 8d6:	4798                	lw	a4,8(a5)
 8d8:	fdc42783          	lw	a5,-36(s0)
 8dc:	2781                	sext.w	a5,a5
 8de:	06f76763          	bltu	a4,a5,94c <malloc+0xf0>
      if(p->s.size == nunits)
 8e2:	fe843783          	ld	a5,-24(s0)
 8e6:	4798                	lw	a4,8(a5)
 8e8:	fdc42783          	lw	a5,-36(s0)
 8ec:	2781                	sext.w	a5,a5
 8ee:	00e79963          	bne	a5,a4,900 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 8f2:	fe843783          	ld	a5,-24(s0)
 8f6:	6398                	ld	a4,0(a5)
 8f8:	fe043783          	ld	a5,-32(s0)
 8fc:	e398                	sd	a4,0(a5)
 8fe:	a825                	j	936 <malloc+0xda>
      else {
        p->s.size -= nunits;
 900:	fe843783          	ld	a5,-24(s0)
 904:	479c                	lw	a5,8(a5)
 906:	fdc42703          	lw	a4,-36(s0)
 90a:	9f99                	subw	a5,a5,a4
 90c:	0007871b          	sext.w	a4,a5
 910:	fe843783          	ld	a5,-24(s0)
 914:	c798                	sw	a4,8(a5)
        p += p->s.size;
 916:	fe843783          	ld	a5,-24(s0)
 91a:	479c                	lw	a5,8(a5)
 91c:	1782                	slli	a5,a5,0x20
 91e:	9381                	srli	a5,a5,0x20
 920:	0792                	slli	a5,a5,0x4
 922:	fe843703          	ld	a4,-24(s0)
 926:	97ba                	add	a5,a5,a4
 928:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 92c:	fe843783          	ld	a5,-24(s0)
 930:	fdc42703          	lw	a4,-36(s0)
 934:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 936:	00001797          	auipc	a5,0x1
 93a:	a9a78793          	addi	a5,a5,-1382 # 13d0 <freep>
 93e:	fe043703          	ld	a4,-32(s0)
 942:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 944:	fe843783          	ld	a5,-24(s0)
 948:	07c1                	addi	a5,a5,16
 94a:	a091                	j	98e <malloc+0x132>
    }
    if(p == freep)
 94c:	00001797          	auipc	a5,0x1
 950:	a8478793          	addi	a5,a5,-1404 # 13d0 <freep>
 954:	639c                	ld	a5,0(a5)
 956:	fe843703          	ld	a4,-24(s0)
 95a:	02f71063          	bne	a4,a5,97a <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 95e:	fdc42783          	lw	a5,-36(s0)
 962:	853e                	mv	a0,a5
 964:	00000097          	auipc	ra,0x0
 968:	e78080e7          	jalr	-392(ra) # 7dc <morecore>
 96c:	fea43423          	sd	a0,-24(s0)
 970:	fe843783          	ld	a5,-24(s0)
 974:	e399                	bnez	a5,97a <malloc+0x11e>
        return 0;
 976:	4781                	li	a5,0
 978:	a819                	j	98e <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 97a:	fe843783          	ld	a5,-24(s0)
 97e:	fef43023          	sd	a5,-32(s0)
 982:	fe843783          	ld	a5,-24(s0)
 986:	639c                	ld	a5,0(a5)
 988:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 98c:	b799                	j	8d2 <malloc+0x76>
  }
}
 98e:	853e                	mv	a0,a5
 990:	70e2                	ld	ra,56(sp)
 992:	7442                	ld	s0,48(sp)
 994:	6121                	addi	sp,sp,64
 996:	8082                	ret
