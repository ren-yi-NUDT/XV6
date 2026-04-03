
user/_ln:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  if(argc != 3){
   8:	478d                	li	a5,3
   a:	02f50163          	beq	a0,a5,2c <main+0x2c>
   e:	e426                	sd	s1,8(sp)
    fprintf(2, "Usage: ln old new\n");
  10:	00001597          	auipc	a1,0x1
  14:	99058593          	addi	a1,a1,-1648 # 9a0 <malloc+0x14a>
  18:	4509                	li	a0,2
  1a:	00000097          	auipc	ra,0x0
  1e:	620080e7          	jalr	1568(ra) # 63a <fprintf>
    exit(1);
  22:	4505                	li	a0,1
  24:	00000097          	auipc	ra,0x0
  28:	2c4080e7          	jalr	708(ra) # 2e8 <exit>
  2c:	e426                	sd	s1,8(sp)
  2e:	84ae                	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
  30:	698c                	ld	a1,16(a1)
  32:	6488                	ld	a0,8(s1)
  34:	00000097          	auipc	ra,0x0
  38:	314080e7          	jalr	788(ra) # 348 <link>
  3c:	00054763          	bltz	a0,4a <main+0x4a>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  40:	4501                	li	a0,0
  42:	00000097          	auipc	ra,0x0
  46:	2a6080e7          	jalr	678(ra) # 2e8 <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  4a:	6894                	ld	a3,16(s1)
  4c:	6490                	ld	a2,8(s1)
  4e:	00001597          	auipc	a1,0x1
  52:	96a58593          	addi	a1,a1,-1686 # 9b8 <malloc+0x162>
  56:	4509                	li	a0,2
  58:	00000097          	auipc	ra,0x0
  5c:	5e2080e7          	jalr	1506(ra) # 63a <fprintf>
  60:	b7c5                	j	40 <main+0x40>

0000000000000062 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  62:	1141                	addi	sp,sp,-16
  64:	e406                	sd	ra,8(sp)
  66:	e022                	sd	s0,0(sp)
  68:	0800                	addi	s0,sp,16
  extern int main();
  main();
  6a:	00000097          	auipc	ra,0x0
  6e:	f96080e7          	jalr	-106(ra) # 0 <main>
  exit(0);
  72:	4501                	li	a0,0
  74:	00000097          	auipc	ra,0x0
  78:	274080e7          	jalr	628(ra) # 2e8 <exit>

000000000000007c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  7c:	1141                	addi	sp,sp,-16
  7e:	e422                	sd	s0,8(sp)
  80:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  82:	87aa                	mv	a5,a0
  84:	0585                	addi	a1,a1,1
  86:	0785                	addi	a5,a5,1
  88:	fff5c703          	lbu	a4,-1(a1)
  8c:	fee78fa3          	sb	a4,-1(a5)
  90:	fb75                	bnez	a4,84 <strcpy+0x8>
    ;
  return os;
}
  92:	6422                	ld	s0,8(sp)
  94:	0141                	addi	sp,sp,16
  96:	8082                	ret

0000000000000098 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  98:	1141                	addi	sp,sp,-16
  9a:	e422                	sd	s0,8(sp)
  9c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  9e:	00054783          	lbu	a5,0(a0)
  a2:	cb91                	beqz	a5,b6 <strcmp+0x1e>
  a4:	0005c703          	lbu	a4,0(a1)
  a8:	00f71763          	bne	a4,a5,b6 <strcmp+0x1e>
    p++, q++;
  ac:	0505                	addi	a0,a0,1
  ae:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  b0:	00054783          	lbu	a5,0(a0)
  b4:	fbe5                	bnez	a5,a4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  b6:	0005c503          	lbu	a0,0(a1)
}
  ba:	40a7853b          	subw	a0,a5,a0
  be:	6422                	ld	s0,8(sp)
  c0:	0141                	addi	sp,sp,16
  c2:	8082                	ret

00000000000000c4 <strlen>:

uint
strlen(const char *s)
{
  c4:	1141                	addi	sp,sp,-16
  c6:	e422                	sd	s0,8(sp)
  c8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ca:	00054783          	lbu	a5,0(a0)
  ce:	cf91                	beqz	a5,ea <strlen+0x26>
  d0:	0505                	addi	a0,a0,1
  d2:	87aa                	mv	a5,a0
  d4:	86be                	mv	a3,a5
  d6:	0785                	addi	a5,a5,1
  d8:	fff7c703          	lbu	a4,-1(a5)
  dc:	ff65                	bnez	a4,d4 <strlen+0x10>
  de:	40a6853b          	subw	a0,a3,a0
  e2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  e4:	6422                	ld	s0,8(sp)
  e6:	0141                	addi	sp,sp,16
  e8:	8082                	ret
  for(n = 0; s[n]; n++)
  ea:	4501                	li	a0,0
  ec:	bfe5                	j	e4 <strlen+0x20>

00000000000000ee <memset>:

void*
memset(void *dst, int c, uint n)
{
  ee:	1141                	addi	sp,sp,-16
  f0:	e422                	sd	s0,8(sp)
  f2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  f4:	ca19                	beqz	a2,10a <memset+0x1c>
  f6:	87aa                	mv	a5,a0
  f8:	1602                	slli	a2,a2,0x20
  fa:	9201                	srli	a2,a2,0x20
  fc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 100:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 104:	0785                	addi	a5,a5,1
 106:	fee79de3          	bne	a5,a4,100 <memset+0x12>
  }
  return dst;
}
 10a:	6422                	ld	s0,8(sp)
 10c:	0141                	addi	sp,sp,16
 10e:	8082                	ret

0000000000000110 <strchr>:

char*
strchr(const char *s, char c)
{
 110:	1141                	addi	sp,sp,-16
 112:	e422                	sd	s0,8(sp)
 114:	0800                	addi	s0,sp,16
  for(; *s; s++)
 116:	00054783          	lbu	a5,0(a0)
 11a:	cb99                	beqz	a5,130 <strchr+0x20>
    if(*s == c)
 11c:	00f58763          	beq	a1,a5,12a <strchr+0x1a>
  for(; *s; s++)
 120:	0505                	addi	a0,a0,1
 122:	00054783          	lbu	a5,0(a0)
 126:	fbfd                	bnez	a5,11c <strchr+0xc>
      return (char*)s;
  return 0;
 128:	4501                	li	a0,0
}
 12a:	6422                	ld	s0,8(sp)
 12c:	0141                	addi	sp,sp,16
 12e:	8082                	ret
  return 0;
 130:	4501                	li	a0,0
 132:	bfe5                	j	12a <strchr+0x1a>

0000000000000134 <gets>:

char*
gets(char *buf, int max)
{
 134:	711d                	addi	sp,sp,-96
 136:	ec86                	sd	ra,88(sp)
 138:	e8a2                	sd	s0,80(sp)
 13a:	e4a6                	sd	s1,72(sp)
 13c:	e0ca                	sd	s2,64(sp)
 13e:	fc4e                	sd	s3,56(sp)
 140:	f852                	sd	s4,48(sp)
 142:	f456                	sd	s5,40(sp)
 144:	f05a                	sd	s6,32(sp)
 146:	ec5e                	sd	s7,24(sp)
 148:	1080                	addi	s0,sp,96
 14a:	8baa                	mv	s7,a0
 14c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 14e:	892a                	mv	s2,a0
 150:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 152:	4aa9                	li	s5,10
 154:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 156:	89a6                	mv	s3,s1
 158:	2485                	addiw	s1,s1,1
 15a:	0344d863          	bge	s1,s4,18a <gets+0x56>
    cc = read(0, &c, 1);
 15e:	4605                	li	a2,1
 160:	faf40593          	addi	a1,s0,-81
 164:	4501                	li	a0,0
 166:	00000097          	auipc	ra,0x0
 16a:	19a080e7          	jalr	410(ra) # 300 <read>
    if(cc < 1)
 16e:	00a05e63          	blez	a0,18a <gets+0x56>
    buf[i++] = c;
 172:	faf44783          	lbu	a5,-81(s0)
 176:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 17a:	01578763          	beq	a5,s5,188 <gets+0x54>
 17e:	0905                	addi	s2,s2,1
 180:	fd679be3          	bne	a5,s6,156 <gets+0x22>
    buf[i++] = c;
 184:	89a6                	mv	s3,s1
 186:	a011                	j	18a <gets+0x56>
 188:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 18a:	99de                	add	s3,s3,s7
 18c:	00098023          	sb	zero,0(s3)
  return buf;
}
 190:	855e                	mv	a0,s7
 192:	60e6                	ld	ra,88(sp)
 194:	6446                	ld	s0,80(sp)
 196:	64a6                	ld	s1,72(sp)
 198:	6906                	ld	s2,64(sp)
 19a:	79e2                	ld	s3,56(sp)
 19c:	7a42                	ld	s4,48(sp)
 19e:	7aa2                	ld	s5,40(sp)
 1a0:	7b02                	ld	s6,32(sp)
 1a2:	6be2                	ld	s7,24(sp)
 1a4:	6125                	addi	sp,sp,96
 1a6:	8082                	ret

00000000000001a8 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a8:	1101                	addi	sp,sp,-32
 1aa:	ec06                	sd	ra,24(sp)
 1ac:	e822                	sd	s0,16(sp)
 1ae:	e04a                	sd	s2,0(sp)
 1b0:	1000                	addi	s0,sp,32
 1b2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b4:	4581                	li	a1,0
 1b6:	00000097          	auipc	ra,0x0
 1ba:	172080e7          	jalr	370(ra) # 328 <open>
  if(fd < 0)
 1be:	02054663          	bltz	a0,1ea <stat+0x42>
 1c2:	e426                	sd	s1,8(sp)
 1c4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1c6:	85ca                	mv	a1,s2
 1c8:	00000097          	auipc	ra,0x0
 1cc:	178080e7          	jalr	376(ra) # 340 <fstat>
 1d0:	892a                	mv	s2,a0
  close(fd);
 1d2:	8526                	mv	a0,s1
 1d4:	00000097          	auipc	ra,0x0
 1d8:	13c080e7          	jalr	316(ra) # 310 <close>
  return r;
 1dc:	64a2                	ld	s1,8(sp)
}
 1de:	854a                	mv	a0,s2
 1e0:	60e2                	ld	ra,24(sp)
 1e2:	6442                	ld	s0,16(sp)
 1e4:	6902                	ld	s2,0(sp)
 1e6:	6105                	addi	sp,sp,32
 1e8:	8082                	ret
    return -1;
 1ea:	597d                	li	s2,-1
 1ec:	bfcd                	j	1de <stat+0x36>

00000000000001ee <atoi>:

int
atoi(const char *s)
{
 1ee:	1141                	addi	sp,sp,-16
 1f0:	e422                	sd	s0,8(sp)
 1f2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1f4:	00054683          	lbu	a3,0(a0)
 1f8:	fd06879b          	addiw	a5,a3,-48
 1fc:	0ff7f793          	zext.b	a5,a5
 200:	4625                	li	a2,9
 202:	02f66863          	bltu	a2,a5,232 <atoi+0x44>
 206:	872a                	mv	a4,a0
  n = 0;
 208:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 20a:	0705                	addi	a4,a4,1
 20c:	0025179b          	slliw	a5,a0,0x2
 210:	9fa9                	addw	a5,a5,a0
 212:	0017979b          	slliw	a5,a5,0x1
 216:	9fb5                	addw	a5,a5,a3
 218:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 21c:	00074683          	lbu	a3,0(a4)
 220:	fd06879b          	addiw	a5,a3,-48
 224:	0ff7f793          	zext.b	a5,a5
 228:	fef671e3          	bgeu	a2,a5,20a <atoi+0x1c>
  return n;
}
 22c:	6422                	ld	s0,8(sp)
 22e:	0141                	addi	sp,sp,16
 230:	8082                	ret
  n = 0;
 232:	4501                	li	a0,0
 234:	bfe5                	j	22c <atoi+0x3e>

0000000000000236 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 236:	1141                	addi	sp,sp,-16
 238:	e422                	sd	s0,8(sp)
 23a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 23c:	02b57463          	bgeu	a0,a1,264 <memmove+0x2e>
    while(n-- > 0)
 240:	00c05f63          	blez	a2,25e <memmove+0x28>
 244:	1602                	slli	a2,a2,0x20
 246:	9201                	srli	a2,a2,0x20
 248:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 24c:	872a                	mv	a4,a0
      *dst++ = *src++;
 24e:	0585                	addi	a1,a1,1
 250:	0705                	addi	a4,a4,1
 252:	fff5c683          	lbu	a3,-1(a1)
 256:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 25a:	fef71ae3          	bne	a4,a5,24e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 25e:	6422                	ld	s0,8(sp)
 260:	0141                	addi	sp,sp,16
 262:	8082                	ret
    dst += n;
 264:	00c50733          	add	a4,a0,a2
    src += n;
 268:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 26a:	fec05ae3          	blez	a2,25e <memmove+0x28>
 26e:	fff6079b          	addiw	a5,a2,-1
 272:	1782                	slli	a5,a5,0x20
 274:	9381                	srli	a5,a5,0x20
 276:	fff7c793          	not	a5,a5
 27a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 27c:	15fd                	addi	a1,a1,-1
 27e:	177d                	addi	a4,a4,-1
 280:	0005c683          	lbu	a3,0(a1)
 284:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 288:	fee79ae3          	bne	a5,a4,27c <memmove+0x46>
 28c:	bfc9                	j	25e <memmove+0x28>

000000000000028e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 28e:	1141                	addi	sp,sp,-16
 290:	e422                	sd	s0,8(sp)
 292:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 294:	ca05                	beqz	a2,2c4 <memcmp+0x36>
 296:	fff6069b          	addiw	a3,a2,-1
 29a:	1682                	slli	a3,a3,0x20
 29c:	9281                	srli	a3,a3,0x20
 29e:	0685                	addi	a3,a3,1
 2a0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2a2:	00054783          	lbu	a5,0(a0)
 2a6:	0005c703          	lbu	a4,0(a1)
 2aa:	00e79863          	bne	a5,a4,2ba <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2ae:	0505                	addi	a0,a0,1
    p2++;
 2b0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2b2:	fed518e3          	bne	a0,a3,2a2 <memcmp+0x14>
  }
  return 0;
 2b6:	4501                	li	a0,0
 2b8:	a019                	j	2be <memcmp+0x30>
      return *p1 - *p2;
 2ba:	40e7853b          	subw	a0,a5,a4
}
 2be:	6422                	ld	s0,8(sp)
 2c0:	0141                	addi	sp,sp,16
 2c2:	8082                	ret
  return 0;
 2c4:	4501                	li	a0,0
 2c6:	bfe5                	j	2be <memcmp+0x30>

00000000000002c8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2c8:	1141                	addi	sp,sp,-16
 2ca:	e406                	sd	ra,8(sp)
 2cc:	e022                	sd	s0,0(sp)
 2ce:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2d0:	00000097          	auipc	ra,0x0
 2d4:	f66080e7          	jalr	-154(ra) # 236 <memmove>
}
 2d8:	60a2                	ld	ra,8(sp)
 2da:	6402                	ld	s0,0(sp)
 2dc:	0141                	addi	sp,sp,16
 2de:	8082                	ret

00000000000002e0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2e0:	4885                	li	a7,1
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2e8:	4889                	li	a7,2
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2f0:	488d                	li	a7,3
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2f8:	4891                	li	a7,4
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <read>:
.global read
read:
 li a7, SYS_read
 300:	4895                	li	a7,5
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <write>:
.global write
write:
 li a7, SYS_write
 308:	48c1                	li	a7,16
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <close>:
.global close
close:
 li a7, SYS_close
 310:	48d5                	li	a7,21
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <kill>:
.global kill
kill:
 li a7, SYS_kill
 318:	4899                	li	a7,6
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <exec>:
.global exec
exec:
 li a7, SYS_exec
 320:	489d                	li	a7,7
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <open>:
.global open
open:
 li a7, SYS_open
 328:	48bd                	li	a7,15
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 330:	48c5                	li	a7,17
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 338:	48c9                	li	a7,18
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 340:	48a1                	li	a7,8
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <link>:
.global link
link:
 li a7, SYS_link
 348:	48cd                	li	a7,19
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 350:	48d1                	li	a7,20
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 358:	48a5                	li	a7,9
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <dup>:
.global dup
dup:
 li a7, SYS_dup
 360:	48a9                	li	a7,10
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 368:	48ad                	li	a7,11
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 370:	48b1                	li	a7,12
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 378:	48b5                	li	a7,13
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 380:	48b9                	li	a7,14
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <yield>:
.global yield
yield:
 li a7, SYS_yield
 388:	48d9                	li	a7,22
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <lock>:
.global lock
lock:
 li a7, SYS_lock
 390:	48dd                	li	a7,23
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <unlock>:
.global unlock
unlock:
 li a7, SYS_unlock
 398:	48e1                	li	a7,24
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3a0:	1101                	addi	sp,sp,-32
 3a2:	ec06                	sd	ra,24(sp)
 3a4:	e822                	sd	s0,16(sp)
 3a6:	1000                	addi	s0,sp,32
 3a8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ac:	4605                	li	a2,1
 3ae:	fef40593          	addi	a1,s0,-17
 3b2:	00000097          	auipc	ra,0x0
 3b6:	f56080e7          	jalr	-170(ra) # 308 <write>
}
 3ba:	60e2                	ld	ra,24(sp)
 3bc:	6442                	ld	s0,16(sp)
 3be:	6105                	addi	sp,sp,32
 3c0:	8082                	ret

00000000000003c2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3c2:	7139                	addi	sp,sp,-64
 3c4:	fc06                	sd	ra,56(sp)
 3c6:	f822                	sd	s0,48(sp)
 3c8:	f426                	sd	s1,40(sp)
 3ca:	0080                	addi	s0,sp,64
 3cc:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ce:	c299                	beqz	a3,3d4 <printint+0x12>
 3d0:	0805cb63          	bltz	a1,466 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3d4:	2581                	sext.w	a1,a1
  neg = 0;
 3d6:	4881                	li	a7,0
 3d8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3dc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3de:	2601                	sext.w	a2,a2
 3e0:	00000517          	auipc	a0,0x0
 3e4:	65050513          	addi	a0,a0,1616 # a30 <digits>
 3e8:	883a                	mv	a6,a4
 3ea:	2705                	addiw	a4,a4,1
 3ec:	02c5f7bb          	remuw	a5,a1,a2
 3f0:	1782                	slli	a5,a5,0x20
 3f2:	9381                	srli	a5,a5,0x20
 3f4:	97aa                	add	a5,a5,a0
 3f6:	0007c783          	lbu	a5,0(a5)
 3fa:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3fe:	0005879b          	sext.w	a5,a1
 402:	02c5d5bb          	divuw	a1,a1,a2
 406:	0685                	addi	a3,a3,1
 408:	fec7f0e3          	bgeu	a5,a2,3e8 <printint+0x26>
  if(neg)
 40c:	00088c63          	beqz	a7,424 <printint+0x62>
    buf[i++] = '-';
 410:	fd070793          	addi	a5,a4,-48
 414:	00878733          	add	a4,a5,s0
 418:	02d00793          	li	a5,45
 41c:	fef70823          	sb	a5,-16(a4)
 420:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 424:	02e05c63          	blez	a4,45c <printint+0x9a>
 428:	f04a                	sd	s2,32(sp)
 42a:	ec4e                	sd	s3,24(sp)
 42c:	fc040793          	addi	a5,s0,-64
 430:	00e78933          	add	s2,a5,a4
 434:	fff78993          	addi	s3,a5,-1
 438:	99ba                	add	s3,s3,a4
 43a:	377d                	addiw	a4,a4,-1
 43c:	1702                	slli	a4,a4,0x20
 43e:	9301                	srli	a4,a4,0x20
 440:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 444:	fff94583          	lbu	a1,-1(s2)
 448:	8526                	mv	a0,s1
 44a:	00000097          	auipc	ra,0x0
 44e:	f56080e7          	jalr	-170(ra) # 3a0 <putc>
  while(--i >= 0)
 452:	197d                	addi	s2,s2,-1
 454:	ff3918e3          	bne	s2,s3,444 <printint+0x82>
 458:	7902                	ld	s2,32(sp)
 45a:	69e2                	ld	s3,24(sp)
}
 45c:	70e2                	ld	ra,56(sp)
 45e:	7442                	ld	s0,48(sp)
 460:	74a2                	ld	s1,40(sp)
 462:	6121                	addi	sp,sp,64
 464:	8082                	ret
    x = -xx;
 466:	40b005bb          	negw	a1,a1
    neg = 1;
 46a:	4885                	li	a7,1
    x = -xx;
 46c:	b7b5                	j	3d8 <printint+0x16>

000000000000046e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 46e:	715d                	addi	sp,sp,-80
 470:	e486                	sd	ra,72(sp)
 472:	e0a2                	sd	s0,64(sp)
 474:	f84a                	sd	s2,48(sp)
 476:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 478:	0005c903          	lbu	s2,0(a1)
 47c:	1a090a63          	beqz	s2,630 <vprintf+0x1c2>
 480:	fc26                	sd	s1,56(sp)
 482:	f44e                	sd	s3,40(sp)
 484:	f052                	sd	s4,32(sp)
 486:	ec56                	sd	s5,24(sp)
 488:	e85a                	sd	s6,16(sp)
 48a:	e45e                	sd	s7,8(sp)
 48c:	8aaa                	mv	s5,a0
 48e:	8bb2                	mv	s7,a2
 490:	00158493          	addi	s1,a1,1
  state = 0;
 494:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 496:	02500a13          	li	s4,37
 49a:	4b55                	li	s6,21
 49c:	a839                	j	4ba <vprintf+0x4c>
        putc(fd, c);
 49e:	85ca                	mv	a1,s2
 4a0:	8556                	mv	a0,s5
 4a2:	00000097          	auipc	ra,0x0
 4a6:	efe080e7          	jalr	-258(ra) # 3a0 <putc>
 4aa:	a019                	j	4b0 <vprintf+0x42>
    } else if(state == '%'){
 4ac:	01498d63          	beq	s3,s4,4c6 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 4b0:	0485                	addi	s1,s1,1
 4b2:	fff4c903          	lbu	s2,-1(s1)
 4b6:	16090763          	beqz	s2,624 <vprintf+0x1b6>
    if(state == 0){
 4ba:	fe0999e3          	bnez	s3,4ac <vprintf+0x3e>
      if(c == '%'){
 4be:	ff4910e3          	bne	s2,s4,49e <vprintf+0x30>
        state = '%';
 4c2:	89d2                	mv	s3,s4
 4c4:	b7f5                	j	4b0 <vprintf+0x42>
      if(c == 'd'){
 4c6:	13490463          	beq	s2,s4,5ee <vprintf+0x180>
 4ca:	f9d9079b          	addiw	a5,s2,-99
 4ce:	0ff7f793          	zext.b	a5,a5
 4d2:	12fb6763          	bltu	s6,a5,600 <vprintf+0x192>
 4d6:	f9d9079b          	addiw	a5,s2,-99
 4da:	0ff7f713          	zext.b	a4,a5
 4de:	12eb6163          	bltu	s6,a4,600 <vprintf+0x192>
 4e2:	00271793          	slli	a5,a4,0x2
 4e6:	00000717          	auipc	a4,0x0
 4ea:	4f270713          	addi	a4,a4,1266 # 9d8 <malloc+0x182>
 4ee:	97ba                	add	a5,a5,a4
 4f0:	439c                	lw	a5,0(a5)
 4f2:	97ba                	add	a5,a5,a4
 4f4:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4f6:	008b8913          	addi	s2,s7,8
 4fa:	4685                	li	a3,1
 4fc:	4629                	li	a2,10
 4fe:	000ba583          	lw	a1,0(s7)
 502:	8556                	mv	a0,s5
 504:	00000097          	auipc	ra,0x0
 508:	ebe080e7          	jalr	-322(ra) # 3c2 <printint>
 50c:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 50e:	4981                	li	s3,0
 510:	b745                	j	4b0 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 512:	008b8913          	addi	s2,s7,8
 516:	4681                	li	a3,0
 518:	4629                	li	a2,10
 51a:	000ba583          	lw	a1,0(s7)
 51e:	8556                	mv	a0,s5
 520:	00000097          	auipc	ra,0x0
 524:	ea2080e7          	jalr	-350(ra) # 3c2 <printint>
 528:	8bca                	mv	s7,s2
      state = 0;
 52a:	4981                	li	s3,0
 52c:	b751                	j	4b0 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 52e:	008b8913          	addi	s2,s7,8
 532:	4681                	li	a3,0
 534:	4641                	li	a2,16
 536:	000ba583          	lw	a1,0(s7)
 53a:	8556                	mv	a0,s5
 53c:	00000097          	auipc	ra,0x0
 540:	e86080e7          	jalr	-378(ra) # 3c2 <printint>
 544:	8bca                	mv	s7,s2
      state = 0;
 546:	4981                	li	s3,0
 548:	b7a5                	j	4b0 <vprintf+0x42>
 54a:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 54c:	008b8c13          	addi	s8,s7,8
 550:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 554:	03000593          	li	a1,48
 558:	8556                	mv	a0,s5
 55a:	00000097          	auipc	ra,0x0
 55e:	e46080e7          	jalr	-442(ra) # 3a0 <putc>
  putc(fd, 'x');
 562:	07800593          	li	a1,120
 566:	8556                	mv	a0,s5
 568:	00000097          	auipc	ra,0x0
 56c:	e38080e7          	jalr	-456(ra) # 3a0 <putc>
 570:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 572:	00000b97          	auipc	s7,0x0
 576:	4beb8b93          	addi	s7,s7,1214 # a30 <digits>
 57a:	03c9d793          	srli	a5,s3,0x3c
 57e:	97de                	add	a5,a5,s7
 580:	0007c583          	lbu	a1,0(a5)
 584:	8556                	mv	a0,s5
 586:	00000097          	auipc	ra,0x0
 58a:	e1a080e7          	jalr	-486(ra) # 3a0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 58e:	0992                	slli	s3,s3,0x4
 590:	397d                	addiw	s2,s2,-1
 592:	fe0914e3          	bnez	s2,57a <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 596:	8be2                	mv	s7,s8
      state = 0;
 598:	4981                	li	s3,0
 59a:	6c02                	ld	s8,0(sp)
 59c:	bf11                	j	4b0 <vprintf+0x42>
        s = va_arg(ap, char*);
 59e:	008b8993          	addi	s3,s7,8
 5a2:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5a6:	02090163          	beqz	s2,5c8 <vprintf+0x15a>
        while(*s != 0){
 5aa:	00094583          	lbu	a1,0(s2)
 5ae:	c9a5                	beqz	a1,61e <vprintf+0x1b0>
          putc(fd, *s);
 5b0:	8556                	mv	a0,s5
 5b2:	00000097          	auipc	ra,0x0
 5b6:	dee080e7          	jalr	-530(ra) # 3a0 <putc>
          s++;
 5ba:	0905                	addi	s2,s2,1
        while(*s != 0){
 5bc:	00094583          	lbu	a1,0(s2)
 5c0:	f9e5                	bnez	a1,5b0 <vprintf+0x142>
        s = va_arg(ap, char*);
 5c2:	8bce                	mv	s7,s3
      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	b5ed                	j	4b0 <vprintf+0x42>
          s = "(null)";
 5c8:	00000917          	auipc	s2,0x0
 5cc:	40890913          	addi	s2,s2,1032 # 9d0 <malloc+0x17a>
        while(*s != 0){
 5d0:	02800593          	li	a1,40
 5d4:	bff1                	j	5b0 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 5d6:	008b8913          	addi	s2,s7,8
 5da:	000bc583          	lbu	a1,0(s7)
 5de:	8556                	mv	a0,s5
 5e0:	00000097          	auipc	ra,0x0
 5e4:	dc0080e7          	jalr	-576(ra) # 3a0 <putc>
 5e8:	8bca                	mv	s7,s2
      state = 0;
 5ea:	4981                	li	s3,0
 5ec:	b5d1                	j	4b0 <vprintf+0x42>
        putc(fd, c);
 5ee:	02500593          	li	a1,37
 5f2:	8556                	mv	a0,s5
 5f4:	00000097          	auipc	ra,0x0
 5f8:	dac080e7          	jalr	-596(ra) # 3a0 <putc>
      state = 0;
 5fc:	4981                	li	s3,0
 5fe:	bd4d                	j	4b0 <vprintf+0x42>
        putc(fd, '%');
 600:	02500593          	li	a1,37
 604:	8556                	mv	a0,s5
 606:	00000097          	auipc	ra,0x0
 60a:	d9a080e7          	jalr	-614(ra) # 3a0 <putc>
        putc(fd, c);
 60e:	85ca                	mv	a1,s2
 610:	8556                	mv	a0,s5
 612:	00000097          	auipc	ra,0x0
 616:	d8e080e7          	jalr	-626(ra) # 3a0 <putc>
      state = 0;
 61a:	4981                	li	s3,0
 61c:	bd51                	j	4b0 <vprintf+0x42>
        s = va_arg(ap, char*);
 61e:	8bce                	mv	s7,s3
      state = 0;
 620:	4981                	li	s3,0
 622:	b579                	j	4b0 <vprintf+0x42>
 624:	74e2                	ld	s1,56(sp)
 626:	79a2                	ld	s3,40(sp)
 628:	7a02                	ld	s4,32(sp)
 62a:	6ae2                	ld	s5,24(sp)
 62c:	6b42                	ld	s6,16(sp)
 62e:	6ba2                	ld	s7,8(sp)
    }
  }
}
 630:	60a6                	ld	ra,72(sp)
 632:	6406                	ld	s0,64(sp)
 634:	7942                	ld	s2,48(sp)
 636:	6161                	addi	sp,sp,80
 638:	8082                	ret

000000000000063a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 63a:	715d                	addi	sp,sp,-80
 63c:	ec06                	sd	ra,24(sp)
 63e:	e822                	sd	s0,16(sp)
 640:	1000                	addi	s0,sp,32
 642:	e010                	sd	a2,0(s0)
 644:	e414                	sd	a3,8(s0)
 646:	e818                	sd	a4,16(s0)
 648:	ec1c                	sd	a5,24(s0)
 64a:	03043023          	sd	a6,32(s0)
 64e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 652:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 656:	8622                	mv	a2,s0
 658:	00000097          	auipc	ra,0x0
 65c:	e16080e7          	jalr	-490(ra) # 46e <vprintf>
}
 660:	60e2                	ld	ra,24(sp)
 662:	6442                	ld	s0,16(sp)
 664:	6161                	addi	sp,sp,80
 666:	8082                	ret

0000000000000668 <printf>:

void
printf(const char *fmt, ...)
{
 668:	7159                	addi	sp,sp,-112
 66a:	f406                	sd	ra,40(sp)
 66c:	f022                	sd	s0,32(sp)
 66e:	ec26                	sd	s1,24(sp)
 670:	1800                	addi	s0,sp,48
 672:	84aa                	mv	s1,a0
 674:	e40c                	sd	a1,8(s0)
 676:	e810                	sd	a2,16(s0)
 678:	ec14                	sd	a3,24(s0)
 67a:	f018                	sd	a4,32(s0)
 67c:	f41c                	sd	a5,40(s0)
 67e:	03043823          	sd	a6,48(s0)
 682:	03143c23          	sd	a7,56(s0)
  va_list ap;

  lock();
 686:	00000097          	auipc	ra,0x0
 68a:	d0a080e7          	jalr	-758(ra) # 390 <lock>
  va_start(ap, fmt);
 68e:	00840613          	addi	a2,s0,8
 692:	fcc43c23          	sd	a2,-40(s0)
  vprintf(1, fmt, ap);
 696:	85a6                	mv	a1,s1
 698:	4505                	li	a0,1
 69a:	00000097          	auipc	ra,0x0
 69e:	dd4080e7          	jalr	-556(ra) # 46e <vprintf>
  unlock();
 6a2:	00000097          	auipc	ra,0x0
 6a6:	cf6080e7          	jalr	-778(ra) # 398 <unlock>
}
 6aa:	70a2                	ld	ra,40(sp)
 6ac:	7402                	ld	s0,32(sp)
 6ae:	64e2                	ld	s1,24(sp)
 6b0:	6165                	addi	sp,sp,112
 6b2:	8082                	ret

00000000000006b4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6b4:	7179                	addi	sp,sp,-48
 6b6:	f422                	sd	s0,40(sp)
 6b8:	1800                	addi	s0,sp,48
 6ba:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6be:	fd843783          	ld	a5,-40(s0)
 6c2:	17c1                	addi	a5,a5,-16
 6c4:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c8:	00001797          	auipc	a5,0x1
 6cc:	d0878793          	addi	a5,a5,-760 # 13d0 <freep>
 6d0:	639c                	ld	a5,0(a5)
 6d2:	fef43423          	sd	a5,-24(s0)
 6d6:	a815                	j	70a <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d8:	fe843783          	ld	a5,-24(s0)
 6dc:	639c                	ld	a5,0(a5)
 6de:	fe843703          	ld	a4,-24(s0)
 6e2:	00f76f63          	bltu	a4,a5,700 <free+0x4c>
 6e6:	fe043703          	ld	a4,-32(s0)
 6ea:	fe843783          	ld	a5,-24(s0)
 6ee:	02e7eb63          	bltu	a5,a4,724 <free+0x70>
 6f2:	fe843783          	ld	a5,-24(s0)
 6f6:	639c                	ld	a5,0(a5)
 6f8:	fe043703          	ld	a4,-32(s0)
 6fc:	02f76463          	bltu	a4,a5,724 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 700:	fe843783          	ld	a5,-24(s0)
 704:	639c                	ld	a5,0(a5)
 706:	fef43423          	sd	a5,-24(s0)
 70a:	fe043703          	ld	a4,-32(s0)
 70e:	fe843783          	ld	a5,-24(s0)
 712:	fce7f3e3          	bgeu	a5,a4,6d8 <free+0x24>
 716:	fe843783          	ld	a5,-24(s0)
 71a:	639c                	ld	a5,0(a5)
 71c:	fe043703          	ld	a4,-32(s0)
 720:	faf77ce3          	bgeu	a4,a5,6d8 <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 724:	fe043783          	ld	a5,-32(s0)
 728:	479c                	lw	a5,8(a5)
 72a:	1782                	slli	a5,a5,0x20
 72c:	9381                	srli	a5,a5,0x20
 72e:	0792                	slli	a5,a5,0x4
 730:	fe043703          	ld	a4,-32(s0)
 734:	973e                	add	a4,a4,a5
 736:	fe843783          	ld	a5,-24(s0)
 73a:	639c                	ld	a5,0(a5)
 73c:	02f71763          	bne	a4,a5,76a <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 740:	fe043783          	ld	a5,-32(s0)
 744:	4798                	lw	a4,8(a5)
 746:	fe843783          	ld	a5,-24(s0)
 74a:	639c                	ld	a5,0(a5)
 74c:	479c                	lw	a5,8(a5)
 74e:	9fb9                	addw	a5,a5,a4
 750:	0007871b          	sext.w	a4,a5
 754:	fe043783          	ld	a5,-32(s0)
 758:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 75a:	fe843783          	ld	a5,-24(s0)
 75e:	639c                	ld	a5,0(a5)
 760:	6398                	ld	a4,0(a5)
 762:	fe043783          	ld	a5,-32(s0)
 766:	e398                	sd	a4,0(a5)
 768:	a039                	j	776 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 76a:	fe843783          	ld	a5,-24(s0)
 76e:	6398                	ld	a4,0(a5)
 770:	fe043783          	ld	a5,-32(s0)
 774:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 776:	fe843783          	ld	a5,-24(s0)
 77a:	479c                	lw	a5,8(a5)
 77c:	1782                	slli	a5,a5,0x20
 77e:	9381                	srli	a5,a5,0x20
 780:	0792                	slli	a5,a5,0x4
 782:	fe843703          	ld	a4,-24(s0)
 786:	97ba                	add	a5,a5,a4
 788:	fe043703          	ld	a4,-32(s0)
 78c:	02f71563          	bne	a4,a5,7b6 <free+0x102>
    p->s.size += bp->s.size;
 790:	fe843783          	ld	a5,-24(s0)
 794:	4798                	lw	a4,8(a5)
 796:	fe043783          	ld	a5,-32(s0)
 79a:	479c                	lw	a5,8(a5)
 79c:	9fb9                	addw	a5,a5,a4
 79e:	0007871b          	sext.w	a4,a5
 7a2:	fe843783          	ld	a5,-24(s0)
 7a6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7a8:	fe043783          	ld	a5,-32(s0)
 7ac:	6398                	ld	a4,0(a5)
 7ae:	fe843783          	ld	a5,-24(s0)
 7b2:	e398                	sd	a4,0(a5)
 7b4:	a031                	j	7c0 <free+0x10c>
  } else
    p->s.ptr = bp;
 7b6:	fe843783          	ld	a5,-24(s0)
 7ba:	fe043703          	ld	a4,-32(s0)
 7be:	e398                	sd	a4,0(a5)
  freep = p;
 7c0:	00001797          	auipc	a5,0x1
 7c4:	c1078793          	addi	a5,a5,-1008 # 13d0 <freep>
 7c8:	fe843703          	ld	a4,-24(s0)
 7cc:	e398                	sd	a4,0(a5)
}
 7ce:	0001                	nop
 7d0:	7422                	ld	s0,40(sp)
 7d2:	6145                	addi	sp,sp,48
 7d4:	8082                	ret

00000000000007d6 <morecore>:

static Header*
morecore(uint nu)
{
 7d6:	7179                	addi	sp,sp,-48
 7d8:	f406                	sd	ra,40(sp)
 7da:	f022                	sd	s0,32(sp)
 7dc:	1800                	addi	s0,sp,48
 7de:	87aa                	mv	a5,a0
 7e0:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 7e4:	fdc42783          	lw	a5,-36(s0)
 7e8:	0007871b          	sext.w	a4,a5
 7ec:	6785                	lui	a5,0x1
 7ee:	00f77563          	bgeu	a4,a5,7f8 <morecore+0x22>
    nu = 4096;
 7f2:	6785                	lui	a5,0x1
 7f4:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 7f8:	fdc42783          	lw	a5,-36(s0)
 7fc:	0047979b          	slliw	a5,a5,0x4
 800:	2781                	sext.w	a5,a5
 802:	2781                	sext.w	a5,a5
 804:	853e                	mv	a0,a5
 806:	00000097          	auipc	ra,0x0
 80a:	b6a080e7          	jalr	-1174(ra) # 370 <sbrk>
 80e:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 812:	fe843703          	ld	a4,-24(s0)
 816:	57fd                	li	a5,-1
 818:	00f71463          	bne	a4,a5,820 <morecore+0x4a>
    return 0;
 81c:	4781                	li	a5,0
 81e:	a03d                	j	84c <morecore+0x76>
  hp = (Header*)p;
 820:	fe843783          	ld	a5,-24(s0)
 824:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 828:	fe043783          	ld	a5,-32(s0)
 82c:	fdc42703          	lw	a4,-36(s0)
 830:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 832:	fe043783          	ld	a5,-32(s0)
 836:	07c1                	addi	a5,a5,16 # 1010 <digits+0x5e0>
 838:	853e                	mv	a0,a5
 83a:	00000097          	auipc	ra,0x0
 83e:	e7a080e7          	jalr	-390(ra) # 6b4 <free>
  return freep;
 842:	00001797          	auipc	a5,0x1
 846:	b8e78793          	addi	a5,a5,-1138 # 13d0 <freep>
 84a:	639c                	ld	a5,0(a5)
}
 84c:	853e                	mv	a0,a5
 84e:	70a2                	ld	ra,40(sp)
 850:	7402                	ld	s0,32(sp)
 852:	6145                	addi	sp,sp,48
 854:	8082                	ret

0000000000000856 <malloc>:

void*
malloc(uint nbytes)
{
 856:	7139                	addi	sp,sp,-64
 858:	fc06                	sd	ra,56(sp)
 85a:	f822                	sd	s0,48(sp)
 85c:	0080                	addi	s0,sp,64
 85e:	87aa                	mv	a5,a0
 860:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 864:	fcc46783          	lwu	a5,-52(s0)
 868:	07bd                	addi	a5,a5,15
 86a:	8391                	srli	a5,a5,0x4
 86c:	2781                	sext.w	a5,a5
 86e:	2785                	addiw	a5,a5,1
 870:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 874:	00001797          	auipc	a5,0x1
 878:	b5c78793          	addi	a5,a5,-1188 # 13d0 <freep>
 87c:	639c                	ld	a5,0(a5)
 87e:	fef43023          	sd	a5,-32(s0)
 882:	fe043783          	ld	a5,-32(s0)
 886:	ef95                	bnez	a5,8c2 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 888:	00001797          	auipc	a5,0x1
 88c:	b3878793          	addi	a5,a5,-1224 # 13c0 <base>
 890:	fef43023          	sd	a5,-32(s0)
 894:	00001797          	auipc	a5,0x1
 898:	b3c78793          	addi	a5,a5,-1220 # 13d0 <freep>
 89c:	fe043703          	ld	a4,-32(s0)
 8a0:	e398                	sd	a4,0(a5)
 8a2:	00001797          	auipc	a5,0x1
 8a6:	b2e78793          	addi	a5,a5,-1234 # 13d0 <freep>
 8aa:	6398                	ld	a4,0(a5)
 8ac:	00001797          	auipc	a5,0x1
 8b0:	b1478793          	addi	a5,a5,-1260 # 13c0 <base>
 8b4:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 8b6:	00001797          	auipc	a5,0x1
 8ba:	b0a78793          	addi	a5,a5,-1270 # 13c0 <base>
 8be:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c2:	fe043783          	ld	a5,-32(s0)
 8c6:	639c                	ld	a5,0(a5)
 8c8:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 8cc:	fe843783          	ld	a5,-24(s0)
 8d0:	4798                	lw	a4,8(a5)
 8d2:	fdc42783          	lw	a5,-36(s0)
 8d6:	2781                	sext.w	a5,a5
 8d8:	06f76763          	bltu	a4,a5,946 <malloc+0xf0>
      if(p->s.size == nunits)
 8dc:	fe843783          	ld	a5,-24(s0)
 8e0:	4798                	lw	a4,8(a5)
 8e2:	fdc42783          	lw	a5,-36(s0)
 8e6:	2781                	sext.w	a5,a5
 8e8:	00e79963          	bne	a5,a4,8fa <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 8ec:	fe843783          	ld	a5,-24(s0)
 8f0:	6398                	ld	a4,0(a5)
 8f2:	fe043783          	ld	a5,-32(s0)
 8f6:	e398                	sd	a4,0(a5)
 8f8:	a825                	j	930 <malloc+0xda>
      else {
        p->s.size -= nunits;
 8fa:	fe843783          	ld	a5,-24(s0)
 8fe:	479c                	lw	a5,8(a5)
 900:	fdc42703          	lw	a4,-36(s0)
 904:	9f99                	subw	a5,a5,a4
 906:	0007871b          	sext.w	a4,a5
 90a:	fe843783          	ld	a5,-24(s0)
 90e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 910:	fe843783          	ld	a5,-24(s0)
 914:	479c                	lw	a5,8(a5)
 916:	1782                	slli	a5,a5,0x20
 918:	9381                	srli	a5,a5,0x20
 91a:	0792                	slli	a5,a5,0x4
 91c:	fe843703          	ld	a4,-24(s0)
 920:	97ba                	add	a5,a5,a4
 922:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 926:	fe843783          	ld	a5,-24(s0)
 92a:	fdc42703          	lw	a4,-36(s0)
 92e:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 930:	00001797          	auipc	a5,0x1
 934:	aa078793          	addi	a5,a5,-1376 # 13d0 <freep>
 938:	fe043703          	ld	a4,-32(s0)
 93c:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 93e:	fe843783          	ld	a5,-24(s0)
 942:	07c1                	addi	a5,a5,16
 944:	a091                	j	988 <malloc+0x132>
    }
    if(p == freep)
 946:	00001797          	auipc	a5,0x1
 94a:	a8a78793          	addi	a5,a5,-1398 # 13d0 <freep>
 94e:	639c                	ld	a5,0(a5)
 950:	fe843703          	ld	a4,-24(s0)
 954:	02f71063          	bne	a4,a5,974 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 958:	fdc42783          	lw	a5,-36(s0)
 95c:	853e                	mv	a0,a5
 95e:	00000097          	auipc	ra,0x0
 962:	e78080e7          	jalr	-392(ra) # 7d6 <morecore>
 966:	fea43423          	sd	a0,-24(s0)
 96a:	fe843783          	ld	a5,-24(s0)
 96e:	e399                	bnez	a5,974 <malloc+0x11e>
        return 0;
 970:	4781                	li	a5,0
 972:	a819                	j	988 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 974:	fe843783          	ld	a5,-24(s0)
 978:	fef43023          	sd	a5,-32(s0)
 97c:	fe843783          	ld	a5,-24(s0)
 980:	639c                	ld	a5,0(a5)
 982:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 986:	b799                	j	8cc <malloc+0x76>
  }
}
 988:	853e                	mv	a0,a5
 98a:	70e2                	ld	ra,56(sp)
 98c:	7442                	ld	s0,48(sp)
 98e:	6121                	addi	sp,sp,64
 990:	8082                	ret
