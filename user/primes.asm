
user/_primes:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <primes>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void primes(int p[2]){
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	0080                	addi	s0,sp,64
   a:	84aa                	mv	s1,a0
    int base;
    if (read(p[0], &base, sizeof(int)) <= 0){
   c:	4611                	li	a2,4
   e:	fdc40593          	addi	a1,s0,-36
  12:	4108                	lw	a0,0(a0)
  14:	00000097          	auipc	ra,0x0
  18:	482080e7          	jalr	1154(ra) # 496 <read>
  1c:	04a05d63          	blez	a0,76 <primes+0x76>
        close(p[0]);
        exit(0);
    }
    printf("prime %d\n", base);
  20:	fdc42583          	lw	a1,-36(s0)
  24:	00001517          	auipc	a0,0x1
  28:	b0c50513          	addi	a0,a0,-1268 # b30 <malloc+0x144>
  2c:	00000097          	auipc	ra,0x0
  30:	7d2080e7          	jalr	2002(ra) # 7fe <printf>

    int next[2];
    pipe(next);
  34:	fd040513          	addi	a0,s0,-48
  38:	00000097          	auipc	ra,0x0
  3c:	456080e7          	jalr	1110(ra) # 48e <pipe>
    int n;
    while (read(p[0], &n, sizeof(int)) > 0){
  40:	4611                	li	a2,4
  42:	fcc40593          	addi	a1,s0,-52
  46:	4088                	lw	a0,0(s1)
  48:	00000097          	auipc	ra,0x0
  4c:	44e080e7          	jalr	1102(ra) # 496 <read>
  50:	02a05d63          	blez	a0,8a <primes+0x8a>
        if (n % base != 0){
  54:	fcc42783          	lw	a5,-52(s0)
  58:	fdc42703          	lw	a4,-36(s0)
  5c:	02e7e7bb          	remw	a5,a5,a4
  60:	d3e5                	beqz	a5,40 <primes+0x40>
            write(next[1], &n, sizeof(int));
  62:	4611                	li	a2,4
  64:	fcc40593          	addi	a1,s0,-52
  68:	fd442503          	lw	a0,-44(s0)
  6c:	00000097          	auipc	ra,0x0
  70:	432080e7          	jalr	1074(ra) # 49e <write>
  74:	b7f1                	j	40 <primes+0x40>
        close(p[0]);
  76:	4088                	lw	a0,0(s1)
  78:	00000097          	auipc	ra,0x0
  7c:	42e080e7          	jalr	1070(ra) # 4a6 <close>
        exit(0);
  80:	4501                	li	a0,0
  82:	00000097          	auipc	ra,0x0
  86:	3fc080e7          	jalr	1020(ra) # 47e <exit>
        }
    }

    close(p[0]);
  8a:	4088                	lw	a0,0(s1)
  8c:	00000097          	auipc	ra,0x0
  90:	41a080e7          	jalr	1050(ra) # 4a6 <close>
    close(next[1]);
  94:	fd442503          	lw	a0,-44(s0)
  98:	00000097          	auipc	ra,0x0
  9c:	40e080e7          	jalr	1038(ra) # 4a6 <close>

    int pid = fork();
  a0:	00000097          	auipc	ra,0x0
  a4:	3d6080e7          	jalr	982(ra) # 476 <fork>
    if (pid < 0){
  a8:	00054e63          	bltz	a0,c4 <primes+0xc4>
        fprintf(2, "fork failed\n");
        exit(1);
    }
    else if (pid == 0){
  ac:	e915                	bnez	a0,e0 <primes+0xe0>
        primes(next);
  ae:	fd040513          	addi	a0,s0,-48
  b2:	00000097          	auipc	ra,0x0
  b6:	f4e080e7          	jalr	-178(ra) # 0 <primes>
    }
    else{
        close(next[0]);
        wait(0);
    }
}
  ba:	70e2                	ld	ra,56(sp)
  bc:	7442                	ld	s0,48(sp)
  be:	74a2                	ld	s1,40(sp)
  c0:	6121                	addi	sp,sp,64
  c2:	8082                	ret
        fprintf(2, "fork failed\n");
  c4:	00001597          	auipc	a1,0x1
  c8:	a7c58593          	addi	a1,a1,-1412 # b40 <malloc+0x154>
  cc:	4509                	li	a0,2
  ce:	00000097          	auipc	ra,0x0
  d2:	702080e7          	jalr	1794(ra) # 7d0 <fprintf>
        exit(1);
  d6:	4505                	li	a0,1
  d8:	00000097          	auipc	ra,0x0
  dc:	3a6080e7          	jalr	934(ra) # 47e <exit>
        close(next[0]);
  e0:	fd042503          	lw	a0,-48(s0)
  e4:	00000097          	auipc	ra,0x0
  e8:	3c2080e7          	jalr	962(ra) # 4a6 <close>
        wait(0);
  ec:	4501                	li	a0,0
  ee:	00000097          	auipc	ra,0x0
  f2:	398080e7          	jalr	920(ra) # 486 <wait>
}
  f6:	b7d1                	j	ba <primes+0xba>

00000000000000f8 <main>:

int main(int argc, char *argv[]){
  f8:	7139                	addi	sp,sp,-64
  fa:	fc06                	sd	ra,56(sp)
  fc:	f822                	sd	s0,48(sp)
  fe:	f426                	sd	s1,40(sp)
 100:	f04a                	sd	s2,32(sp)
 102:	ec4e                	sd	s3,24(sp)
 104:	0080                	addi	s0,sp,64
 106:	84aa                	mv	s1,a0
 108:	892e                	mv	s2,a1
    int p[2];
    pipe(p);
 10a:	fc840513          	addi	a0,s0,-56
 10e:	00000097          	auipc	ra,0x0
 112:	380080e7          	jalr	896(ra) # 48e <pipe>
    
    if (argc != 2){
 116:	4789                	li	a5,2
        for (int i = 2; i <= 35; i++){
            write(p[1], &i, sizeof(int));
        }
    }
    else{
        for (int i = 2; i <= (atoi(argv[1]) > 129 ? 129 : atoi(argv[1])); i++){
 118:	08100993          	li	s3,129
    if (argc != 2){
 11c:	08f48163          	beq	s1,a5,19e <main+0xa6>
        for (int i = 2; i <= 35; i++){
 120:	4789                	li	a5,2
 122:	fcf42223          	sw	a5,-60(s0)
 126:	02300493          	li	s1,35
            write(p[1], &i, sizeof(int));
 12a:	4611                	li	a2,4
 12c:	fc440593          	addi	a1,s0,-60
 130:	fcc42503          	lw	a0,-52(s0)
 134:	00000097          	auipc	ra,0x0
 138:	36a080e7          	jalr	874(ra) # 49e <write>
        for (int i = 2; i <= 35; i++){
 13c:	fc442783          	lw	a5,-60(s0)
 140:	2785                	addiw	a5,a5,1
 142:	0007871b          	sext.w	a4,a5
 146:	fcf42223          	sw	a5,-60(s0)
 14a:	fee4d0e3          	bge	s1,a4,12a <main+0x32>
            write(p[1], &i, sizeof(int));
        }
    }
    close(p[1]);
 14e:	fcc42503          	lw	a0,-52(s0)
 152:	00000097          	auipc	ra,0x0
 156:	354080e7          	jalr	852(ra) # 4a6 <close>

    int pid = fork();
 15a:	00000097          	auipc	ra,0x0
 15e:	31c080e7          	jalr	796(ra) # 476 <fork>
    if (pid < 0){
 162:	06054163          	bltz	a0,1c4 <main+0xcc>
        fprintf(2, "fork failed\n");
        exit(1);
    }
    else if (pid == 0){
 166:	ed2d                	bnez	a0,1e0 <main+0xe8>
        primes(p);
 168:	fc840513          	addi	a0,s0,-56
 16c:	00000097          	auipc	ra,0x0
 170:	e94080e7          	jalr	-364(ra) # 0 <primes>
    }
    else{
        close(p[0]);
        wait(0);
    }
    exit(0);
 174:	4501                	li	a0,0
 176:	00000097          	auipc	ra,0x0
 17a:	308080e7          	jalr	776(ra) # 47e <exit>
        for (int i = 2; i <= (atoi(argv[1]) > 129 ? 129 : atoi(argv[1])); i++){
 17e:	fc442703          	lw	a4,-60(s0)
 182:	fce7c6e3          	blt	a5,a4,14e <main+0x56>
            write(p[1], &i, sizeof(int));
 186:	4611                	li	a2,4
 188:	fc440593          	addi	a1,s0,-60
 18c:	fcc42503          	lw	a0,-52(s0)
 190:	00000097          	auipc	ra,0x0
 194:	30e080e7          	jalr	782(ra) # 49e <write>
        for (int i = 2; i <= (atoi(argv[1]) > 129 ? 129 : atoi(argv[1])); i++){
 198:	fc442483          	lw	s1,-60(s0)
 19c:	2485                	addiw	s1,s1,1
 19e:	fc942223          	sw	s1,-60(s0)
 1a2:	00893503          	ld	a0,8(s2)
 1a6:	00000097          	auipc	ra,0x0
 1aa:	1de080e7          	jalr	478(ra) # 384 <atoi>
 1ae:	87ce                	mv	a5,s3
 1b0:	fca9c7e3          	blt	s3,a0,17e <main+0x86>
 1b4:	00893503          	ld	a0,8(s2)
 1b8:	00000097          	auipc	ra,0x0
 1bc:	1cc080e7          	jalr	460(ra) # 384 <atoi>
 1c0:	87aa                	mv	a5,a0
 1c2:	bf75                	j	17e <main+0x86>
        fprintf(2, "fork failed\n");
 1c4:	00001597          	auipc	a1,0x1
 1c8:	97c58593          	addi	a1,a1,-1668 # b40 <malloc+0x154>
 1cc:	4509                	li	a0,2
 1ce:	00000097          	auipc	ra,0x0
 1d2:	602080e7          	jalr	1538(ra) # 7d0 <fprintf>
        exit(1);
 1d6:	4505                	li	a0,1
 1d8:	00000097          	auipc	ra,0x0
 1dc:	2a6080e7          	jalr	678(ra) # 47e <exit>
        close(p[0]);
 1e0:	fc842503          	lw	a0,-56(s0)
 1e4:	00000097          	auipc	ra,0x0
 1e8:	2c2080e7          	jalr	706(ra) # 4a6 <close>
        wait(0);
 1ec:	4501                	li	a0,0
 1ee:	00000097          	auipc	ra,0x0
 1f2:	298080e7          	jalr	664(ra) # 486 <wait>
 1f6:	bfbd                	j	174 <main+0x7c>

00000000000001f8 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 1f8:	1141                	addi	sp,sp,-16
 1fa:	e406                	sd	ra,8(sp)
 1fc:	e022                	sd	s0,0(sp)
 1fe:	0800                	addi	s0,sp,16
  extern int main();
  main();
 200:	00000097          	auipc	ra,0x0
 204:	ef8080e7          	jalr	-264(ra) # f8 <main>
  exit(0);
 208:	4501                	li	a0,0
 20a:	00000097          	auipc	ra,0x0
 20e:	274080e7          	jalr	628(ra) # 47e <exit>

0000000000000212 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 212:	1141                	addi	sp,sp,-16
 214:	e422                	sd	s0,8(sp)
 216:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 218:	87aa                	mv	a5,a0
 21a:	0585                	addi	a1,a1,1
 21c:	0785                	addi	a5,a5,1
 21e:	fff5c703          	lbu	a4,-1(a1)
 222:	fee78fa3          	sb	a4,-1(a5)
 226:	fb75                	bnez	a4,21a <strcpy+0x8>
    ;
  return os;
}
 228:	6422                	ld	s0,8(sp)
 22a:	0141                	addi	sp,sp,16
 22c:	8082                	ret

000000000000022e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 22e:	1141                	addi	sp,sp,-16
 230:	e422                	sd	s0,8(sp)
 232:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 234:	00054783          	lbu	a5,0(a0)
 238:	cb91                	beqz	a5,24c <strcmp+0x1e>
 23a:	0005c703          	lbu	a4,0(a1)
 23e:	00f71763          	bne	a4,a5,24c <strcmp+0x1e>
    p++, q++;
 242:	0505                	addi	a0,a0,1
 244:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 246:	00054783          	lbu	a5,0(a0)
 24a:	fbe5                	bnez	a5,23a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 24c:	0005c503          	lbu	a0,0(a1)
}
 250:	40a7853b          	subw	a0,a5,a0
 254:	6422                	ld	s0,8(sp)
 256:	0141                	addi	sp,sp,16
 258:	8082                	ret

000000000000025a <strlen>:

uint
strlen(const char *s)
{
 25a:	1141                	addi	sp,sp,-16
 25c:	e422                	sd	s0,8(sp)
 25e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 260:	00054783          	lbu	a5,0(a0)
 264:	cf91                	beqz	a5,280 <strlen+0x26>
 266:	0505                	addi	a0,a0,1
 268:	87aa                	mv	a5,a0
 26a:	86be                	mv	a3,a5
 26c:	0785                	addi	a5,a5,1
 26e:	fff7c703          	lbu	a4,-1(a5)
 272:	ff65                	bnez	a4,26a <strlen+0x10>
 274:	40a6853b          	subw	a0,a3,a0
 278:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 27a:	6422                	ld	s0,8(sp)
 27c:	0141                	addi	sp,sp,16
 27e:	8082                	ret
  for(n = 0; s[n]; n++)
 280:	4501                	li	a0,0
 282:	bfe5                	j	27a <strlen+0x20>

0000000000000284 <memset>:

void*
memset(void *dst, int c, uint n)
{
 284:	1141                	addi	sp,sp,-16
 286:	e422                	sd	s0,8(sp)
 288:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 28a:	ca19                	beqz	a2,2a0 <memset+0x1c>
 28c:	87aa                	mv	a5,a0
 28e:	1602                	slli	a2,a2,0x20
 290:	9201                	srli	a2,a2,0x20
 292:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 296:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 29a:	0785                	addi	a5,a5,1
 29c:	fee79de3          	bne	a5,a4,296 <memset+0x12>
  }
  return dst;
}
 2a0:	6422                	ld	s0,8(sp)
 2a2:	0141                	addi	sp,sp,16
 2a4:	8082                	ret

00000000000002a6 <strchr>:

char*
strchr(const char *s, char c)
{
 2a6:	1141                	addi	sp,sp,-16
 2a8:	e422                	sd	s0,8(sp)
 2aa:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2ac:	00054783          	lbu	a5,0(a0)
 2b0:	cb99                	beqz	a5,2c6 <strchr+0x20>
    if(*s == c)
 2b2:	00f58763          	beq	a1,a5,2c0 <strchr+0x1a>
  for(; *s; s++)
 2b6:	0505                	addi	a0,a0,1
 2b8:	00054783          	lbu	a5,0(a0)
 2bc:	fbfd                	bnez	a5,2b2 <strchr+0xc>
      return (char*)s;
  return 0;
 2be:	4501                	li	a0,0
}
 2c0:	6422                	ld	s0,8(sp)
 2c2:	0141                	addi	sp,sp,16
 2c4:	8082                	ret
  return 0;
 2c6:	4501                	li	a0,0
 2c8:	bfe5                	j	2c0 <strchr+0x1a>

00000000000002ca <gets>:

char*
gets(char *buf, int max)
{
 2ca:	711d                	addi	sp,sp,-96
 2cc:	ec86                	sd	ra,88(sp)
 2ce:	e8a2                	sd	s0,80(sp)
 2d0:	e4a6                	sd	s1,72(sp)
 2d2:	e0ca                	sd	s2,64(sp)
 2d4:	fc4e                	sd	s3,56(sp)
 2d6:	f852                	sd	s4,48(sp)
 2d8:	f456                	sd	s5,40(sp)
 2da:	f05a                	sd	s6,32(sp)
 2dc:	ec5e                	sd	s7,24(sp)
 2de:	1080                	addi	s0,sp,96
 2e0:	8baa                	mv	s7,a0
 2e2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2e4:	892a                	mv	s2,a0
 2e6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2e8:	4aa9                	li	s5,10
 2ea:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2ec:	89a6                	mv	s3,s1
 2ee:	2485                	addiw	s1,s1,1
 2f0:	0344d863          	bge	s1,s4,320 <gets+0x56>
    cc = read(0, &c, 1);
 2f4:	4605                	li	a2,1
 2f6:	faf40593          	addi	a1,s0,-81
 2fa:	4501                	li	a0,0
 2fc:	00000097          	auipc	ra,0x0
 300:	19a080e7          	jalr	410(ra) # 496 <read>
    if(cc < 1)
 304:	00a05e63          	blez	a0,320 <gets+0x56>
    buf[i++] = c;
 308:	faf44783          	lbu	a5,-81(s0)
 30c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 310:	01578763          	beq	a5,s5,31e <gets+0x54>
 314:	0905                	addi	s2,s2,1
 316:	fd679be3          	bne	a5,s6,2ec <gets+0x22>
    buf[i++] = c;
 31a:	89a6                	mv	s3,s1
 31c:	a011                	j	320 <gets+0x56>
 31e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 320:	99de                	add	s3,s3,s7
 322:	00098023          	sb	zero,0(s3)
  return buf;
}
 326:	855e                	mv	a0,s7
 328:	60e6                	ld	ra,88(sp)
 32a:	6446                	ld	s0,80(sp)
 32c:	64a6                	ld	s1,72(sp)
 32e:	6906                	ld	s2,64(sp)
 330:	79e2                	ld	s3,56(sp)
 332:	7a42                	ld	s4,48(sp)
 334:	7aa2                	ld	s5,40(sp)
 336:	7b02                	ld	s6,32(sp)
 338:	6be2                	ld	s7,24(sp)
 33a:	6125                	addi	sp,sp,96
 33c:	8082                	ret

000000000000033e <stat>:

int
stat(const char *n, struct stat *st)
{
 33e:	1101                	addi	sp,sp,-32
 340:	ec06                	sd	ra,24(sp)
 342:	e822                	sd	s0,16(sp)
 344:	e04a                	sd	s2,0(sp)
 346:	1000                	addi	s0,sp,32
 348:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 34a:	4581                	li	a1,0
 34c:	00000097          	auipc	ra,0x0
 350:	172080e7          	jalr	370(ra) # 4be <open>
  if(fd < 0)
 354:	02054663          	bltz	a0,380 <stat+0x42>
 358:	e426                	sd	s1,8(sp)
 35a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 35c:	85ca                	mv	a1,s2
 35e:	00000097          	auipc	ra,0x0
 362:	178080e7          	jalr	376(ra) # 4d6 <fstat>
 366:	892a                	mv	s2,a0
  close(fd);
 368:	8526                	mv	a0,s1
 36a:	00000097          	auipc	ra,0x0
 36e:	13c080e7          	jalr	316(ra) # 4a6 <close>
  return r;
 372:	64a2                	ld	s1,8(sp)
}
 374:	854a                	mv	a0,s2
 376:	60e2                	ld	ra,24(sp)
 378:	6442                	ld	s0,16(sp)
 37a:	6902                	ld	s2,0(sp)
 37c:	6105                	addi	sp,sp,32
 37e:	8082                	ret
    return -1;
 380:	597d                	li	s2,-1
 382:	bfcd                	j	374 <stat+0x36>

0000000000000384 <atoi>:

int
atoi(const char *s)
{
 384:	1141                	addi	sp,sp,-16
 386:	e422                	sd	s0,8(sp)
 388:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 38a:	00054683          	lbu	a3,0(a0)
 38e:	fd06879b          	addiw	a5,a3,-48
 392:	0ff7f793          	zext.b	a5,a5
 396:	4625                	li	a2,9
 398:	02f66863          	bltu	a2,a5,3c8 <atoi+0x44>
 39c:	872a                	mv	a4,a0
  n = 0;
 39e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3a0:	0705                	addi	a4,a4,1
 3a2:	0025179b          	slliw	a5,a0,0x2
 3a6:	9fa9                	addw	a5,a5,a0
 3a8:	0017979b          	slliw	a5,a5,0x1
 3ac:	9fb5                	addw	a5,a5,a3
 3ae:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3b2:	00074683          	lbu	a3,0(a4)
 3b6:	fd06879b          	addiw	a5,a3,-48
 3ba:	0ff7f793          	zext.b	a5,a5
 3be:	fef671e3          	bgeu	a2,a5,3a0 <atoi+0x1c>
  return n;
}
 3c2:	6422                	ld	s0,8(sp)
 3c4:	0141                	addi	sp,sp,16
 3c6:	8082                	ret
  n = 0;
 3c8:	4501                	li	a0,0
 3ca:	bfe5                	j	3c2 <atoi+0x3e>

00000000000003cc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3cc:	1141                	addi	sp,sp,-16
 3ce:	e422                	sd	s0,8(sp)
 3d0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3d2:	02b57463          	bgeu	a0,a1,3fa <memmove+0x2e>
    while(n-- > 0)
 3d6:	00c05f63          	blez	a2,3f4 <memmove+0x28>
 3da:	1602                	slli	a2,a2,0x20
 3dc:	9201                	srli	a2,a2,0x20
 3de:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3e2:	872a                	mv	a4,a0
      *dst++ = *src++;
 3e4:	0585                	addi	a1,a1,1
 3e6:	0705                	addi	a4,a4,1
 3e8:	fff5c683          	lbu	a3,-1(a1)
 3ec:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3f0:	fef71ae3          	bne	a4,a5,3e4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3f4:	6422                	ld	s0,8(sp)
 3f6:	0141                	addi	sp,sp,16
 3f8:	8082                	ret
    dst += n;
 3fa:	00c50733          	add	a4,a0,a2
    src += n;
 3fe:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 400:	fec05ae3          	blez	a2,3f4 <memmove+0x28>
 404:	fff6079b          	addiw	a5,a2,-1
 408:	1782                	slli	a5,a5,0x20
 40a:	9381                	srli	a5,a5,0x20
 40c:	fff7c793          	not	a5,a5
 410:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 412:	15fd                	addi	a1,a1,-1
 414:	177d                	addi	a4,a4,-1
 416:	0005c683          	lbu	a3,0(a1)
 41a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 41e:	fee79ae3          	bne	a5,a4,412 <memmove+0x46>
 422:	bfc9                	j	3f4 <memmove+0x28>

0000000000000424 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 424:	1141                	addi	sp,sp,-16
 426:	e422                	sd	s0,8(sp)
 428:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 42a:	ca05                	beqz	a2,45a <memcmp+0x36>
 42c:	fff6069b          	addiw	a3,a2,-1
 430:	1682                	slli	a3,a3,0x20
 432:	9281                	srli	a3,a3,0x20
 434:	0685                	addi	a3,a3,1
 436:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 438:	00054783          	lbu	a5,0(a0)
 43c:	0005c703          	lbu	a4,0(a1)
 440:	00e79863          	bne	a5,a4,450 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 444:	0505                	addi	a0,a0,1
    p2++;
 446:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 448:	fed518e3          	bne	a0,a3,438 <memcmp+0x14>
  }
  return 0;
 44c:	4501                	li	a0,0
 44e:	a019                	j	454 <memcmp+0x30>
      return *p1 - *p2;
 450:	40e7853b          	subw	a0,a5,a4
}
 454:	6422                	ld	s0,8(sp)
 456:	0141                	addi	sp,sp,16
 458:	8082                	ret
  return 0;
 45a:	4501                	li	a0,0
 45c:	bfe5                	j	454 <memcmp+0x30>

000000000000045e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 45e:	1141                	addi	sp,sp,-16
 460:	e406                	sd	ra,8(sp)
 462:	e022                	sd	s0,0(sp)
 464:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 466:	00000097          	auipc	ra,0x0
 46a:	f66080e7          	jalr	-154(ra) # 3cc <memmove>
}
 46e:	60a2                	ld	ra,8(sp)
 470:	6402                	ld	s0,0(sp)
 472:	0141                	addi	sp,sp,16
 474:	8082                	ret

0000000000000476 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 476:	4885                	li	a7,1
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <exit>:
.global exit
exit:
 li a7, SYS_exit
 47e:	4889                	li	a7,2
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <wait>:
.global wait
wait:
 li a7, SYS_wait
 486:	488d                	li	a7,3
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 48e:	4891                	li	a7,4
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <read>:
.global read
read:
 li a7, SYS_read
 496:	4895                	li	a7,5
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <write>:
.global write
write:
 li a7, SYS_write
 49e:	48c1                	li	a7,16
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <close>:
.global close
close:
 li a7, SYS_close
 4a6:	48d5                	li	a7,21
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <kill>:
.global kill
kill:
 li a7, SYS_kill
 4ae:	4899                	li	a7,6
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4b6:	489d                	li	a7,7
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <open>:
.global open
open:
 li a7, SYS_open
 4be:	48bd                	li	a7,15
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4c6:	48c5                	li	a7,17
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4ce:	48c9                	li	a7,18
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4d6:	48a1                	li	a7,8
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <link>:
.global link
link:
 li a7, SYS_link
 4de:	48cd                	li	a7,19
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4e6:	48d1                	li	a7,20
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4ee:	48a5                	li	a7,9
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4f6:	48a9                	li	a7,10
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4fe:	48ad                	li	a7,11
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 506:	48b1                	li	a7,12
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 50e:	48b5                	li	a7,13
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 516:	48b9                	li	a7,14
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <yield>:
.global yield
yield:
 li a7, SYS_yield
 51e:	48d9                	li	a7,22
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <lock>:
.global lock
lock:
 li a7, SYS_lock
 526:	48dd                	li	a7,23
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <unlock>:
.global unlock
unlock:
 li a7, SYS_unlock
 52e:	48e1                	li	a7,24
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 536:	1101                	addi	sp,sp,-32
 538:	ec06                	sd	ra,24(sp)
 53a:	e822                	sd	s0,16(sp)
 53c:	1000                	addi	s0,sp,32
 53e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 542:	4605                	li	a2,1
 544:	fef40593          	addi	a1,s0,-17
 548:	00000097          	auipc	ra,0x0
 54c:	f56080e7          	jalr	-170(ra) # 49e <write>
}
 550:	60e2                	ld	ra,24(sp)
 552:	6442                	ld	s0,16(sp)
 554:	6105                	addi	sp,sp,32
 556:	8082                	ret

0000000000000558 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 558:	7139                	addi	sp,sp,-64
 55a:	fc06                	sd	ra,56(sp)
 55c:	f822                	sd	s0,48(sp)
 55e:	f426                	sd	s1,40(sp)
 560:	0080                	addi	s0,sp,64
 562:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 564:	c299                	beqz	a3,56a <printint+0x12>
 566:	0805cb63          	bltz	a1,5fc <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 56a:	2581                	sext.w	a1,a1
  neg = 0;
 56c:	4881                	li	a7,0
 56e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 572:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 574:	2601                	sext.w	a2,a2
 576:	00000517          	auipc	a0,0x0
 57a:	63a50513          	addi	a0,a0,1594 # bb0 <digits>
 57e:	883a                	mv	a6,a4
 580:	2705                	addiw	a4,a4,1
 582:	02c5f7bb          	remuw	a5,a1,a2
 586:	1782                	slli	a5,a5,0x20
 588:	9381                	srli	a5,a5,0x20
 58a:	97aa                	add	a5,a5,a0
 58c:	0007c783          	lbu	a5,0(a5)
 590:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 594:	0005879b          	sext.w	a5,a1
 598:	02c5d5bb          	divuw	a1,a1,a2
 59c:	0685                	addi	a3,a3,1
 59e:	fec7f0e3          	bgeu	a5,a2,57e <printint+0x26>
  if(neg)
 5a2:	00088c63          	beqz	a7,5ba <printint+0x62>
    buf[i++] = '-';
 5a6:	fd070793          	addi	a5,a4,-48
 5aa:	00878733          	add	a4,a5,s0
 5ae:	02d00793          	li	a5,45
 5b2:	fef70823          	sb	a5,-16(a4)
 5b6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5ba:	02e05c63          	blez	a4,5f2 <printint+0x9a>
 5be:	f04a                	sd	s2,32(sp)
 5c0:	ec4e                	sd	s3,24(sp)
 5c2:	fc040793          	addi	a5,s0,-64
 5c6:	00e78933          	add	s2,a5,a4
 5ca:	fff78993          	addi	s3,a5,-1
 5ce:	99ba                	add	s3,s3,a4
 5d0:	377d                	addiw	a4,a4,-1
 5d2:	1702                	slli	a4,a4,0x20
 5d4:	9301                	srli	a4,a4,0x20
 5d6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5da:	fff94583          	lbu	a1,-1(s2)
 5de:	8526                	mv	a0,s1
 5e0:	00000097          	auipc	ra,0x0
 5e4:	f56080e7          	jalr	-170(ra) # 536 <putc>
  while(--i >= 0)
 5e8:	197d                	addi	s2,s2,-1
 5ea:	ff3918e3          	bne	s2,s3,5da <printint+0x82>
 5ee:	7902                	ld	s2,32(sp)
 5f0:	69e2                	ld	s3,24(sp)
}
 5f2:	70e2                	ld	ra,56(sp)
 5f4:	7442                	ld	s0,48(sp)
 5f6:	74a2                	ld	s1,40(sp)
 5f8:	6121                	addi	sp,sp,64
 5fa:	8082                	ret
    x = -xx;
 5fc:	40b005bb          	negw	a1,a1
    neg = 1;
 600:	4885                	li	a7,1
    x = -xx;
 602:	b7b5                	j	56e <printint+0x16>

0000000000000604 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 604:	715d                	addi	sp,sp,-80
 606:	e486                	sd	ra,72(sp)
 608:	e0a2                	sd	s0,64(sp)
 60a:	f84a                	sd	s2,48(sp)
 60c:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 60e:	0005c903          	lbu	s2,0(a1)
 612:	1a090a63          	beqz	s2,7c6 <vprintf+0x1c2>
 616:	fc26                	sd	s1,56(sp)
 618:	f44e                	sd	s3,40(sp)
 61a:	f052                	sd	s4,32(sp)
 61c:	ec56                	sd	s5,24(sp)
 61e:	e85a                	sd	s6,16(sp)
 620:	e45e                	sd	s7,8(sp)
 622:	8aaa                	mv	s5,a0
 624:	8bb2                	mv	s7,a2
 626:	00158493          	addi	s1,a1,1
  state = 0;
 62a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 62c:	02500a13          	li	s4,37
 630:	4b55                	li	s6,21
 632:	a839                	j	650 <vprintf+0x4c>
        putc(fd, c);
 634:	85ca                	mv	a1,s2
 636:	8556                	mv	a0,s5
 638:	00000097          	auipc	ra,0x0
 63c:	efe080e7          	jalr	-258(ra) # 536 <putc>
 640:	a019                	j	646 <vprintf+0x42>
    } else if(state == '%'){
 642:	01498d63          	beq	s3,s4,65c <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 646:	0485                	addi	s1,s1,1
 648:	fff4c903          	lbu	s2,-1(s1)
 64c:	16090763          	beqz	s2,7ba <vprintf+0x1b6>
    if(state == 0){
 650:	fe0999e3          	bnez	s3,642 <vprintf+0x3e>
      if(c == '%'){
 654:	ff4910e3          	bne	s2,s4,634 <vprintf+0x30>
        state = '%';
 658:	89d2                	mv	s3,s4
 65a:	b7f5                	j	646 <vprintf+0x42>
      if(c == 'd'){
 65c:	13490463          	beq	s2,s4,784 <vprintf+0x180>
 660:	f9d9079b          	addiw	a5,s2,-99
 664:	0ff7f793          	zext.b	a5,a5
 668:	12fb6763          	bltu	s6,a5,796 <vprintf+0x192>
 66c:	f9d9079b          	addiw	a5,s2,-99
 670:	0ff7f713          	zext.b	a4,a5
 674:	12eb6163          	bltu	s6,a4,796 <vprintf+0x192>
 678:	00271793          	slli	a5,a4,0x2
 67c:	00000717          	auipc	a4,0x0
 680:	4dc70713          	addi	a4,a4,1244 # b58 <malloc+0x16c>
 684:	97ba                	add	a5,a5,a4
 686:	439c                	lw	a5,0(a5)
 688:	97ba                	add	a5,a5,a4
 68a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 68c:	008b8913          	addi	s2,s7,8
 690:	4685                	li	a3,1
 692:	4629                	li	a2,10
 694:	000ba583          	lw	a1,0(s7)
 698:	8556                	mv	a0,s5
 69a:	00000097          	auipc	ra,0x0
 69e:	ebe080e7          	jalr	-322(ra) # 558 <printint>
 6a2:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	b745                	j	646 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a8:	008b8913          	addi	s2,s7,8
 6ac:	4681                	li	a3,0
 6ae:	4629                	li	a2,10
 6b0:	000ba583          	lw	a1,0(s7)
 6b4:	8556                	mv	a0,s5
 6b6:	00000097          	auipc	ra,0x0
 6ba:	ea2080e7          	jalr	-350(ra) # 558 <printint>
 6be:	8bca                	mv	s7,s2
      state = 0;
 6c0:	4981                	li	s3,0
 6c2:	b751                	j	646 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 6c4:	008b8913          	addi	s2,s7,8
 6c8:	4681                	li	a3,0
 6ca:	4641                	li	a2,16
 6cc:	000ba583          	lw	a1,0(s7)
 6d0:	8556                	mv	a0,s5
 6d2:	00000097          	auipc	ra,0x0
 6d6:	e86080e7          	jalr	-378(ra) # 558 <printint>
 6da:	8bca                	mv	s7,s2
      state = 0;
 6dc:	4981                	li	s3,0
 6de:	b7a5                	j	646 <vprintf+0x42>
 6e0:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6e2:	008b8c13          	addi	s8,s7,8
 6e6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6ea:	03000593          	li	a1,48
 6ee:	8556                	mv	a0,s5
 6f0:	00000097          	auipc	ra,0x0
 6f4:	e46080e7          	jalr	-442(ra) # 536 <putc>
  putc(fd, 'x');
 6f8:	07800593          	li	a1,120
 6fc:	8556                	mv	a0,s5
 6fe:	00000097          	auipc	ra,0x0
 702:	e38080e7          	jalr	-456(ra) # 536 <putc>
 706:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 708:	00000b97          	auipc	s7,0x0
 70c:	4a8b8b93          	addi	s7,s7,1192 # bb0 <digits>
 710:	03c9d793          	srli	a5,s3,0x3c
 714:	97de                	add	a5,a5,s7
 716:	0007c583          	lbu	a1,0(a5)
 71a:	8556                	mv	a0,s5
 71c:	00000097          	auipc	ra,0x0
 720:	e1a080e7          	jalr	-486(ra) # 536 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 724:	0992                	slli	s3,s3,0x4
 726:	397d                	addiw	s2,s2,-1
 728:	fe0914e3          	bnez	s2,710 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 72c:	8be2                	mv	s7,s8
      state = 0;
 72e:	4981                	li	s3,0
 730:	6c02                	ld	s8,0(sp)
 732:	bf11                	j	646 <vprintf+0x42>
        s = va_arg(ap, char*);
 734:	008b8993          	addi	s3,s7,8
 738:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 73c:	02090163          	beqz	s2,75e <vprintf+0x15a>
        while(*s != 0){
 740:	00094583          	lbu	a1,0(s2)
 744:	c9a5                	beqz	a1,7b4 <vprintf+0x1b0>
          putc(fd, *s);
 746:	8556                	mv	a0,s5
 748:	00000097          	auipc	ra,0x0
 74c:	dee080e7          	jalr	-530(ra) # 536 <putc>
          s++;
 750:	0905                	addi	s2,s2,1
        while(*s != 0){
 752:	00094583          	lbu	a1,0(s2)
 756:	f9e5                	bnez	a1,746 <vprintf+0x142>
        s = va_arg(ap, char*);
 758:	8bce                	mv	s7,s3
      state = 0;
 75a:	4981                	li	s3,0
 75c:	b5ed                	j	646 <vprintf+0x42>
          s = "(null)";
 75e:	00000917          	auipc	s2,0x0
 762:	3f290913          	addi	s2,s2,1010 # b50 <malloc+0x164>
        while(*s != 0){
 766:	02800593          	li	a1,40
 76a:	bff1                	j	746 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 76c:	008b8913          	addi	s2,s7,8
 770:	000bc583          	lbu	a1,0(s7)
 774:	8556                	mv	a0,s5
 776:	00000097          	auipc	ra,0x0
 77a:	dc0080e7          	jalr	-576(ra) # 536 <putc>
 77e:	8bca                	mv	s7,s2
      state = 0;
 780:	4981                	li	s3,0
 782:	b5d1                	j	646 <vprintf+0x42>
        putc(fd, c);
 784:	02500593          	li	a1,37
 788:	8556                	mv	a0,s5
 78a:	00000097          	auipc	ra,0x0
 78e:	dac080e7          	jalr	-596(ra) # 536 <putc>
      state = 0;
 792:	4981                	li	s3,0
 794:	bd4d                	j	646 <vprintf+0x42>
        putc(fd, '%');
 796:	02500593          	li	a1,37
 79a:	8556                	mv	a0,s5
 79c:	00000097          	auipc	ra,0x0
 7a0:	d9a080e7          	jalr	-614(ra) # 536 <putc>
        putc(fd, c);
 7a4:	85ca                	mv	a1,s2
 7a6:	8556                	mv	a0,s5
 7a8:	00000097          	auipc	ra,0x0
 7ac:	d8e080e7          	jalr	-626(ra) # 536 <putc>
      state = 0;
 7b0:	4981                	li	s3,0
 7b2:	bd51                	j	646 <vprintf+0x42>
        s = va_arg(ap, char*);
 7b4:	8bce                	mv	s7,s3
      state = 0;
 7b6:	4981                	li	s3,0
 7b8:	b579                	j	646 <vprintf+0x42>
 7ba:	74e2                	ld	s1,56(sp)
 7bc:	79a2                	ld	s3,40(sp)
 7be:	7a02                	ld	s4,32(sp)
 7c0:	6ae2                	ld	s5,24(sp)
 7c2:	6b42                	ld	s6,16(sp)
 7c4:	6ba2                	ld	s7,8(sp)
    }
  }
}
 7c6:	60a6                	ld	ra,72(sp)
 7c8:	6406                	ld	s0,64(sp)
 7ca:	7942                	ld	s2,48(sp)
 7cc:	6161                	addi	sp,sp,80
 7ce:	8082                	ret

00000000000007d0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7d0:	715d                	addi	sp,sp,-80
 7d2:	ec06                	sd	ra,24(sp)
 7d4:	e822                	sd	s0,16(sp)
 7d6:	1000                	addi	s0,sp,32
 7d8:	e010                	sd	a2,0(s0)
 7da:	e414                	sd	a3,8(s0)
 7dc:	e818                	sd	a4,16(s0)
 7de:	ec1c                	sd	a5,24(s0)
 7e0:	03043023          	sd	a6,32(s0)
 7e4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7e8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7ec:	8622                	mv	a2,s0
 7ee:	00000097          	auipc	ra,0x0
 7f2:	e16080e7          	jalr	-490(ra) # 604 <vprintf>
}
 7f6:	60e2                	ld	ra,24(sp)
 7f8:	6442                	ld	s0,16(sp)
 7fa:	6161                	addi	sp,sp,80
 7fc:	8082                	ret

00000000000007fe <printf>:

void
printf(const char *fmt, ...)
{
 7fe:	7159                	addi	sp,sp,-112
 800:	f406                	sd	ra,40(sp)
 802:	f022                	sd	s0,32(sp)
 804:	ec26                	sd	s1,24(sp)
 806:	1800                	addi	s0,sp,48
 808:	84aa                	mv	s1,a0
 80a:	e40c                	sd	a1,8(s0)
 80c:	e810                	sd	a2,16(s0)
 80e:	ec14                	sd	a3,24(s0)
 810:	f018                	sd	a4,32(s0)
 812:	f41c                	sd	a5,40(s0)
 814:	03043823          	sd	a6,48(s0)
 818:	03143c23          	sd	a7,56(s0)
  va_list ap;

  lock();
 81c:	00000097          	auipc	ra,0x0
 820:	d0a080e7          	jalr	-758(ra) # 526 <lock>
  va_start(ap, fmt);
 824:	00840613          	addi	a2,s0,8
 828:	fcc43c23          	sd	a2,-40(s0)
  vprintf(1, fmt, ap);
 82c:	85a6                	mv	a1,s1
 82e:	4505                	li	a0,1
 830:	00000097          	auipc	ra,0x0
 834:	dd4080e7          	jalr	-556(ra) # 604 <vprintf>
  unlock();
 838:	00000097          	auipc	ra,0x0
 83c:	cf6080e7          	jalr	-778(ra) # 52e <unlock>
}
 840:	70a2                	ld	ra,40(sp)
 842:	7402                	ld	s0,32(sp)
 844:	64e2                	ld	s1,24(sp)
 846:	6165                	addi	sp,sp,112
 848:	8082                	ret

000000000000084a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 84a:	7179                	addi	sp,sp,-48
 84c:	f422                	sd	s0,40(sp)
 84e:	1800                	addi	s0,sp,48
 850:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 854:	fd843783          	ld	a5,-40(s0)
 858:	17c1                	addi	a5,a5,-16
 85a:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 85e:	00001797          	auipc	a5,0x1
 862:	b9278793          	addi	a5,a5,-1134 # 13f0 <freep>
 866:	639c                	ld	a5,0(a5)
 868:	fef43423          	sd	a5,-24(s0)
 86c:	a815                	j	8a0 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 86e:	fe843783          	ld	a5,-24(s0)
 872:	639c                	ld	a5,0(a5)
 874:	fe843703          	ld	a4,-24(s0)
 878:	00f76f63          	bltu	a4,a5,896 <free+0x4c>
 87c:	fe043703          	ld	a4,-32(s0)
 880:	fe843783          	ld	a5,-24(s0)
 884:	02e7eb63          	bltu	a5,a4,8ba <free+0x70>
 888:	fe843783          	ld	a5,-24(s0)
 88c:	639c                	ld	a5,0(a5)
 88e:	fe043703          	ld	a4,-32(s0)
 892:	02f76463          	bltu	a4,a5,8ba <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 896:	fe843783          	ld	a5,-24(s0)
 89a:	639c                	ld	a5,0(a5)
 89c:	fef43423          	sd	a5,-24(s0)
 8a0:	fe043703          	ld	a4,-32(s0)
 8a4:	fe843783          	ld	a5,-24(s0)
 8a8:	fce7f3e3          	bgeu	a5,a4,86e <free+0x24>
 8ac:	fe843783          	ld	a5,-24(s0)
 8b0:	639c                	ld	a5,0(a5)
 8b2:	fe043703          	ld	a4,-32(s0)
 8b6:	faf77ce3          	bgeu	a4,a5,86e <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8ba:	fe043783          	ld	a5,-32(s0)
 8be:	479c                	lw	a5,8(a5)
 8c0:	1782                	slli	a5,a5,0x20
 8c2:	9381                	srli	a5,a5,0x20
 8c4:	0792                	slli	a5,a5,0x4
 8c6:	fe043703          	ld	a4,-32(s0)
 8ca:	973e                	add	a4,a4,a5
 8cc:	fe843783          	ld	a5,-24(s0)
 8d0:	639c                	ld	a5,0(a5)
 8d2:	02f71763          	bne	a4,a5,900 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 8d6:	fe043783          	ld	a5,-32(s0)
 8da:	4798                	lw	a4,8(a5)
 8dc:	fe843783          	ld	a5,-24(s0)
 8e0:	639c                	ld	a5,0(a5)
 8e2:	479c                	lw	a5,8(a5)
 8e4:	9fb9                	addw	a5,a5,a4
 8e6:	0007871b          	sext.w	a4,a5
 8ea:	fe043783          	ld	a5,-32(s0)
 8ee:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 8f0:	fe843783          	ld	a5,-24(s0)
 8f4:	639c                	ld	a5,0(a5)
 8f6:	6398                	ld	a4,0(a5)
 8f8:	fe043783          	ld	a5,-32(s0)
 8fc:	e398                	sd	a4,0(a5)
 8fe:	a039                	j	90c <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 900:	fe843783          	ld	a5,-24(s0)
 904:	6398                	ld	a4,0(a5)
 906:	fe043783          	ld	a5,-32(s0)
 90a:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 90c:	fe843783          	ld	a5,-24(s0)
 910:	479c                	lw	a5,8(a5)
 912:	1782                	slli	a5,a5,0x20
 914:	9381                	srli	a5,a5,0x20
 916:	0792                	slli	a5,a5,0x4
 918:	fe843703          	ld	a4,-24(s0)
 91c:	97ba                	add	a5,a5,a4
 91e:	fe043703          	ld	a4,-32(s0)
 922:	02f71563          	bne	a4,a5,94c <free+0x102>
    p->s.size += bp->s.size;
 926:	fe843783          	ld	a5,-24(s0)
 92a:	4798                	lw	a4,8(a5)
 92c:	fe043783          	ld	a5,-32(s0)
 930:	479c                	lw	a5,8(a5)
 932:	9fb9                	addw	a5,a5,a4
 934:	0007871b          	sext.w	a4,a5
 938:	fe843783          	ld	a5,-24(s0)
 93c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 93e:	fe043783          	ld	a5,-32(s0)
 942:	6398                	ld	a4,0(a5)
 944:	fe843783          	ld	a5,-24(s0)
 948:	e398                	sd	a4,0(a5)
 94a:	a031                	j	956 <free+0x10c>
  } else
    p->s.ptr = bp;
 94c:	fe843783          	ld	a5,-24(s0)
 950:	fe043703          	ld	a4,-32(s0)
 954:	e398                	sd	a4,0(a5)
  freep = p;
 956:	00001797          	auipc	a5,0x1
 95a:	a9a78793          	addi	a5,a5,-1382 # 13f0 <freep>
 95e:	fe843703          	ld	a4,-24(s0)
 962:	e398                	sd	a4,0(a5)
}
 964:	0001                	nop
 966:	7422                	ld	s0,40(sp)
 968:	6145                	addi	sp,sp,48
 96a:	8082                	ret

000000000000096c <morecore>:

static Header*
morecore(uint nu)
{
 96c:	7179                	addi	sp,sp,-48
 96e:	f406                	sd	ra,40(sp)
 970:	f022                	sd	s0,32(sp)
 972:	1800                	addi	s0,sp,48
 974:	87aa                	mv	a5,a0
 976:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 97a:	fdc42783          	lw	a5,-36(s0)
 97e:	0007871b          	sext.w	a4,a5
 982:	6785                	lui	a5,0x1
 984:	00f77563          	bgeu	a4,a5,98e <morecore+0x22>
    nu = 4096;
 988:	6785                	lui	a5,0x1
 98a:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 98e:	fdc42783          	lw	a5,-36(s0)
 992:	0047979b          	slliw	a5,a5,0x4
 996:	2781                	sext.w	a5,a5
 998:	2781                	sext.w	a5,a5
 99a:	853e                	mv	a0,a5
 99c:	00000097          	auipc	ra,0x0
 9a0:	b6a080e7          	jalr	-1174(ra) # 506 <sbrk>
 9a4:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 9a8:	fe843703          	ld	a4,-24(s0)
 9ac:	57fd                	li	a5,-1
 9ae:	00f71463          	bne	a4,a5,9b6 <morecore+0x4a>
    return 0;
 9b2:	4781                	li	a5,0
 9b4:	a03d                	j	9e2 <morecore+0x76>
  hp = (Header*)p;
 9b6:	fe843783          	ld	a5,-24(s0)
 9ba:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 9be:	fe043783          	ld	a5,-32(s0)
 9c2:	fdc42703          	lw	a4,-36(s0)
 9c6:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 9c8:	fe043783          	ld	a5,-32(s0)
 9cc:	07c1                	addi	a5,a5,16 # 1010 <digits+0x460>
 9ce:	853e                	mv	a0,a5
 9d0:	00000097          	auipc	ra,0x0
 9d4:	e7a080e7          	jalr	-390(ra) # 84a <free>
  return freep;
 9d8:	00001797          	auipc	a5,0x1
 9dc:	a1878793          	addi	a5,a5,-1512 # 13f0 <freep>
 9e0:	639c                	ld	a5,0(a5)
}
 9e2:	853e                	mv	a0,a5
 9e4:	70a2                	ld	ra,40(sp)
 9e6:	7402                	ld	s0,32(sp)
 9e8:	6145                	addi	sp,sp,48
 9ea:	8082                	ret

00000000000009ec <malloc>:

void*
malloc(uint nbytes)
{
 9ec:	7139                	addi	sp,sp,-64
 9ee:	fc06                	sd	ra,56(sp)
 9f0:	f822                	sd	s0,48(sp)
 9f2:	0080                	addi	s0,sp,64
 9f4:	87aa                	mv	a5,a0
 9f6:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9fa:	fcc46783          	lwu	a5,-52(s0)
 9fe:	07bd                	addi	a5,a5,15
 a00:	8391                	srli	a5,a5,0x4
 a02:	2781                	sext.w	a5,a5
 a04:	2785                	addiw	a5,a5,1
 a06:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 a0a:	00001797          	auipc	a5,0x1
 a0e:	9e678793          	addi	a5,a5,-1562 # 13f0 <freep>
 a12:	639c                	ld	a5,0(a5)
 a14:	fef43023          	sd	a5,-32(s0)
 a18:	fe043783          	ld	a5,-32(s0)
 a1c:	ef95                	bnez	a5,a58 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 a1e:	00001797          	auipc	a5,0x1
 a22:	9c278793          	addi	a5,a5,-1598 # 13e0 <base>
 a26:	fef43023          	sd	a5,-32(s0)
 a2a:	00001797          	auipc	a5,0x1
 a2e:	9c678793          	addi	a5,a5,-1594 # 13f0 <freep>
 a32:	fe043703          	ld	a4,-32(s0)
 a36:	e398                	sd	a4,0(a5)
 a38:	00001797          	auipc	a5,0x1
 a3c:	9b878793          	addi	a5,a5,-1608 # 13f0 <freep>
 a40:	6398                	ld	a4,0(a5)
 a42:	00001797          	auipc	a5,0x1
 a46:	99e78793          	addi	a5,a5,-1634 # 13e0 <base>
 a4a:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 a4c:	00001797          	auipc	a5,0x1
 a50:	99478793          	addi	a5,a5,-1644 # 13e0 <base>
 a54:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a58:	fe043783          	ld	a5,-32(s0)
 a5c:	639c                	ld	a5,0(a5)
 a5e:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 a62:	fe843783          	ld	a5,-24(s0)
 a66:	4798                	lw	a4,8(a5)
 a68:	fdc42783          	lw	a5,-36(s0)
 a6c:	2781                	sext.w	a5,a5
 a6e:	06f76763          	bltu	a4,a5,adc <malloc+0xf0>
      if(p->s.size == nunits)
 a72:	fe843783          	ld	a5,-24(s0)
 a76:	4798                	lw	a4,8(a5)
 a78:	fdc42783          	lw	a5,-36(s0)
 a7c:	2781                	sext.w	a5,a5
 a7e:	00e79963          	bne	a5,a4,a90 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 a82:	fe843783          	ld	a5,-24(s0)
 a86:	6398                	ld	a4,0(a5)
 a88:	fe043783          	ld	a5,-32(s0)
 a8c:	e398                	sd	a4,0(a5)
 a8e:	a825                	j	ac6 <malloc+0xda>
      else {
        p->s.size -= nunits;
 a90:	fe843783          	ld	a5,-24(s0)
 a94:	479c                	lw	a5,8(a5)
 a96:	fdc42703          	lw	a4,-36(s0)
 a9a:	9f99                	subw	a5,a5,a4
 a9c:	0007871b          	sext.w	a4,a5
 aa0:	fe843783          	ld	a5,-24(s0)
 aa4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 aa6:	fe843783          	ld	a5,-24(s0)
 aaa:	479c                	lw	a5,8(a5)
 aac:	1782                	slli	a5,a5,0x20
 aae:	9381                	srli	a5,a5,0x20
 ab0:	0792                	slli	a5,a5,0x4
 ab2:	fe843703          	ld	a4,-24(s0)
 ab6:	97ba                	add	a5,a5,a4
 ab8:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 abc:	fe843783          	ld	a5,-24(s0)
 ac0:	fdc42703          	lw	a4,-36(s0)
 ac4:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 ac6:	00001797          	auipc	a5,0x1
 aca:	92a78793          	addi	a5,a5,-1750 # 13f0 <freep>
 ace:	fe043703          	ld	a4,-32(s0)
 ad2:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 ad4:	fe843783          	ld	a5,-24(s0)
 ad8:	07c1                	addi	a5,a5,16
 ada:	a091                	j	b1e <malloc+0x132>
    }
    if(p == freep)
 adc:	00001797          	auipc	a5,0x1
 ae0:	91478793          	addi	a5,a5,-1772 # 13f0 <freep>
 ae4:	639c                	ld	a5,0(a5)
 ae6:	fe843703          	ld	a4,-24(s0)
 aea:	02f71063          	bne	a4,a5,b0a <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 aee:	fdc42783          	lw	a5,-36(s0)
 af2:	853e                	mv	a0,a5
 af4:	00000097          	auipc	ra,0x0
 af8:	e78080e7          	jalr	-392(ra) # 96c <morecore>
 afc:	fea43423          	sd	a0,-24(s0)
 b00:	fe843783          	ld	a5,-24(s0)
 b04:	e399                	bnez	a5,b0a <malloc+0x11e>
        return 0;
 b06:	4781                	li	a5,0
 b08:	a819                	j	b1e <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b0a:	fe843783          	ld	a5,-24(s0)
 b0e:	fef43023          	sd	a5,-32(s0)
 b12:	fe843783          	ld	a5,-24(s0)
 b16:	639c                	ld	a5,0(a5)
 b18:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 b1c:	b799                	j	a62 <malloc+0x76>
  }
}
 b1e:	853e                	mv	a0,a5
 b20:	70e2                	ld	ra,56(sp)
 b22:	7442                	ld	s0,48(sp)
 b24:	6121                	addi	sp,sp,64
 b26:	8082                	ret
