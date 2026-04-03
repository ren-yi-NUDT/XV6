
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4901                	li	s2,0
  l = w = c = 0;
  28:	4d01                	li	s10,0
  2a:	4c81                	li	s9,0
  2c:	4c01                	li	s8,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  2e:	00001d97          	auipc	s11,0x1
  32:	3f2d8d93          	addi	s11,s11,1010 # 1420 <buf>
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	a88a0a13          	addi	s4,s4,-1400 # ac0 <malloc+0x13c>
        inword = 0;
  40:	4b81                	li	s7,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a805                	j	72 <wc+0x72>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	00000097          	auipc	ra,0x0
  4a:	1f8080e7          	jalr	504(ra) # 23e <strchr>
  4e:	c919                	beqz	a0,64 <wc+0x64>
        inword = 0;
  50:	895e                	mv	s2,s7
    for(i=0; i<n; i++){
  52:	0485                	addi	s1,s1,1
  54:	01348d63          	beq	s1,s3,6e <wc+0x6e>
      if(buf[i] == '\n')
  58:	0004c583          	lbu	a1,0(s1)
  5c:	ff5594e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  60:	2c05                	addiw	s8,s8,1
  62:	b7cd                	j	44 <wc+0x44>
      else if(!inword){
  64:	fe0917e3          	bnez	s2,52 <wc+0x52>
        w++;
  68:	2c85                	addiw	s9,s9,1
        inword = 1;
  6a:	4905                	li	s2,1
  6c:	b7dd                	j	52 <wc+0x52>
  6e:	01ab0d3b          	addw	s10,s6,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  72:	20000613          	li	a2,512
  76:	85ee                	mv	a1,s11
  78:	f8843503          	ld	a0,-120(s0)
  7c:	00000097          	auipc	ra,0x0
  80:	3b2080e7          	jalr	946(ra) # 42e <read>
  84:	8b2a                	mv	s6,a0
  86:	00a05963          	blez	a0,98 <wc+0x98>
    for(i=0; i<n; i++){
  8a:	00001497          	auipc	s1,0x1
  8e:	39648493          	addi	s1,s1,918 # 1420 <buf>
  92:	009509b3          	add	s3,a0,s1
  96:	b7c9                	j	58 <wc+0x58>
      }
    }
  }
  if(n < 0){
  98:	02054e63          	bltz	a0,d4 <wc+0xd4>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  9c:	f8043703          	ld	a4,-128(s0)
  a0:	86ea                	mv	a3,s10
  a2:	8666                	mv	a2,s9
  a4:	85e2                	mv	a1,s8
  a6:	00001517          	auipc	a0,0x1
  aa:	a3a50513          	addi	a0,a0,-1478 # ae0 <malloc+0x15c>
  ae:	00000097          	auipc	ra,0x0
  b2:	6e8080e7          	jalr	1768(ra) # 796 <printf>
}
  b6:	70e6                	ld	ra,120(sp)
  b8:	7446                	ld	s0,112(sp)
  ba:	74a6                	ld	s1,104(sp)
  bc:	7906                	ld	s2,96(sp)
  be:	69e6                	ld	s3,88(sp)
  c0:	6a46                	ld	s4,80(sp)
  c2:	6aa6                	ld	s5,72(sp)
  c4:	6b06                	ld	s6,64(sp)
  c6:	7be2                	ld	s7,56(sp)
  c8:	7c42                	ld	s8,48(sp)
  ca:	7ca2                	ld	s9,40(sp)
  cc:	7d02                	ld	s10,32(sp)
  ce:	6de2                	ld	s11,24(sp)
  d0:	6109                	addi	sp,sp,128
  d2:	8082                	ret
    printf("wc: read error\n");
  d4:	00001517          	auipc	a0,0x1
  d8:	9fc50513          	addi	a0,a0,-1540 # ad0 <malloc+0x14c>
  dc:	00000097          	auipc	ra,0x0
  e0:	6ba080e7          	jalr	1722(ra) # 796 <printf>
    exit(1);
  e4:	4505                	li	a0,1
  e6:	00000097          	auipc	ra,0x0
  ea:	330080e7          	jalr	816(ra) # 416 <exit>

00000000000000ee <main>:

int
main(int argc, char *argv[])
{
  ee:	7179                	addi	sp,sp,-48
  f0:	f406                	sd	ra,40(sp)
  f2:	f022                	sd	s0,32(sp)
  f4:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  f6:	4785                	li	a5,1
  f8:	04a7dc63          	bge	a5,a0,150 <main+0x62>
  fc:	ec26                	sd	s1,24(sp)
  fe:	e84a                	sd	s2,16(sp)
 100:	e44e                	sd	s3,8(sp)
 102:	00858913          	addi	s2,a1,8
 106:	ffe5099b          	addiw	s3,a0,-2
 10a:	02099793          	slli	a5,s3,0x20
 10e:	01d7d993          	srli	s3,a5,0x1d
 112:	05c1                	addi	a1,a1,16
 114:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
 116:	4581                	li	a1,0
 118:	00093503          	ld	a0,0(s2)
 11c:	00000097          	auipc	ra,0x0
 120:	33a080e7          	jalr	826(ra) # 456 <open>
 124:	84aa                	mv	s1,a0
 126:	04054663          	bltz	a0,172 <main+0x84>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 12a:	00093583          	ld	a1,0(s2)
 12e:	00000097          	auipc	ra,0x0
 132:	ed2080e7          	jalr	-302(ra) # 0 <wc>
    close(fd);
 136:	8526                	mv	a0,s1
 138:	00000097          	auipc	ra,0x0
 13c:	306080e7          	jalr	774(ra) # 43e <close>
  for(i = 1; i < argc; i++){
 140:	0921                	addi	s2,s2,8
 142:	fd391ae3          	bne	s2,s3,116 <main+0x28>
  }
  exit(0);
 146:	4501                	li	a0,0
 148:	00000097          	auipc	ra,0x0
 14c:	2ce080e7          	jalr	718(ra) # 416 <exit>
 150:	ec26                	sd	s1,24(sp)
 152:	e84a                	sd	s2,16(sp)
 154:	e44e                	sd	s3,8(sp)
    wc(0, "");
 156:	00001597          	auipc	a1,0x1
 15a:	97258593          	addi	a1,a1,-1678 # ac8 <malloc+0x144>
 15e:	4501                	li	a0,0
 160:	00000097          	auipc	ra,0x0
 164:	ea0080e7          	jalr	-352(ra) # 0 <wc>
    exit(0);
 168:	4501                	li	a0,0
 16a:	00000097          	auipc	ra,0x0
 16e:	2ac080e7          	jalr	684(ra) # 416 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 172:	00093583          	ld	a1,0(s2)
 176:	00001517          	auipc	a0,0x1
 17a:	97a50513          	addi	a0,a0,-1670 # af0 <malloc+0x16c>
 17e:	00000097          	auipc	ra,0x0
 182:	618080e7          	jalr	1560(ra) # 796 <printf>
      exit(1);
 186:	4505                	li	a0,1
 188:	00000097          	auipc	ra,0x0
 18c:	28e080e7          	jalr	654(ra) # 416 <exit>

0000000000000190 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 190:	1141                	addi	sp,sp,-16
 192:	e406                	sd	ra,8(sp)
 194:	e022                	sd	s0,0(sp)
 196:	0800                	addi	s0,sp,16
  extern int main();
  main();
 198:	00000097          	auipc	ra,0x0
 19c:	f56080e7          	jalr	-170(ra) # ee <main>
  exit(0);
 1a0:	4501                	li	a0,0
 1a2:	00000097          	auipc	ra,0x0
 1a6:	274080e7          	jalr	628(ra) # 416 <exit>

00000000000001aa <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1aa:	1141                	addi	sp,sp,-16
 1ac:	e422                	sd	s0,8(sp)
 1ae:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1b0:	87aa                	mv	a5,a0
 1b2:	0585                	addi	a1,a1,1
 1b4:	0785                	addi	a5,a5,1
 1b6:	fff5c703          	lbu	a4,-1(a1)
 1ba:	fee78fa3          	sb	a4,-1(a5)
 1be:	fb75                	bnez	a4,1b2 <strcpy+0x8>
    ;
  return os;
}
 1c0:	6422                	ld	s0,8(sp)
 1c2:	0141                	addi	sp,sp,16
 1c4:	8082                	ret

00000000000001c6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1c6:	1141                	addi	sp,sp,-16
 1c8:	e422                	sd	s0,8(sp)
 1ca:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1cc:	00054783          	lbu	a5,0(a0)
 1d0:	cb91                	beqz	a5,1e4 <strcmp+0x1e>
 1d2:	0005c703          	lbu	a4,0(a1)
 1d6:	00f71763          	bne	a4,a5,1e4 <strcmp+0x1e>
    p++, q++;
 1da:	0505                	addi	a0,a0,1
 1dc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1de:	00054783          	lbu	a5,0(a0)
 1e2:	fbe5                	bnez	a5,1d2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1e4:	0005c503          	lbu	a0,0(a1)
}
 1e8:	40a7853b          	subw	a0,a5,a0
 1ec:	6422                	ld	s0,8(sp)
 1ee:	0141                	addi	sp,sp,16
 1f0:	8082                	ret

00000000000001f2 <strlen>:

uint
strlen(const char *s)
{
 1f2:	1141                	addi	sp,sp,-16
 1f4:	e422                	sd	s0,8(sp)
 1f6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1f8:	00054783          	lbu	a5,0(a0)
 1fc:	cf91                	beqz	a5,218 <strlen+0x26>
 1fe:	0505                	addi	a0,a0,1
 200:	87aa                	mv	a5,a0
 202:	86be                	mv	a3,a5
 204:	0785                	addi	a5,a5,1
 206:	fff7c703          	lbu	a4,-1(a5)
 20a:	ff65                	bnez	a4,202 <strlen+0x10>
 20c:	40a6853b          	subw	a0,a3,a0
 210:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 212:	6422                	ld	s0,8(sp)
 214:	0141                	addi	sp,sp,16
 216:	8082                	ret
  for(n = 0; s[n]; n++)
 218:	4501                	li	a0,0
 21a:	bfe5                	j	212 <strlen+0x20>

000000000000021c <memset>:

void*
memset(void *dst, int c, uint n)
{
 21c:	1141                	addi	sp,sp,-16
 21e:	e422                	sd	s0,8(sp)
 220:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 222:	ca19                	beqz	a2,238 <memset+0x1c>
 224:	87aa                	mv	a5,a0
 226:	1602                	slli	a2,a2,0x20
 228:	9201                	srli	a2,a2,0x20
 22a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 22e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 232:	0785                	addi	a5,a5,1
 234:	fee79de3          	bne	a5,a4,22e <memset+0x12>
  }
  return dst;
}
 238:	6422                	ld	s0,8(sp)
 23a:	0141                	addi	sp,sp,16
 23c:	8082                	ret

000000000000023e <strchr>:

char*
strchr(const char *s, char c)
{
 23e:	1141                	addi	sp,sp,-16
 240:	e422                	sd	s0,8(sp)
 242:	0800                	addi	s0,sp,16
  for(; *s; s++)
 244:	00054783          	lbu	a5,0(a0)
 248:	cb99                	beqz	a5,25e <strchr+0x20>
    if(*s == c)
 24a:	00f58763          	beq	a1,a5,258 <strchr+0x1a>
  for(; *s; s++)
 24e:	0505                	addi	a0,a0,1
 250:	00054783          	lbu	a5,0(a0)
 254:	fbfd                	bnez	a5,24a <strchr+0xc>
      return (char*)s;
  return 0;
 256:	4501                	li	a0,0
}
 258:	6422                	ld	s0,8(sp)
 25a:	0141                	addi	sp,sp,16
 25c:	8082                	ret
  return 0;
 25e:	4501                	li	a0,0
 260:	bfe5                	j	258 <strchr+0x1a>

0000000000000262 <gets>:

char*
gets(char *buf, int max)
{
 262:	711d                	addi	sp,sp,-96
 264:	ec86                	sd	ra,88(sp)
 266:	e8a2                	sd	s0,80(sp)
 268:	e4a6                	sd	s1,72(sp)
 26a:	e0ca                	sd	s2,64(sp)
 26c:	fc4e                	sd	s3,56(sp)
 26e:	f852                	sd	s4,48(sp)
 270:	f456                	sd	s5,40(sp)
 272:	f05a                	sd	s6,32(sp)
 274:	ec5e                	sd	s7,24(sp)
 276:	1080                	addi	s0,sp,96
 278:	8baa                	mv	s7,a0
 27a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 27c:	892a                	mv	s2,a0
 27e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 280:	4aa9                	li	s5,10
 282:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 284:	89a6                	mv	s3,s1
 286:	2485                	addiw	s1,s1,1
 288:	0344d863          	bge	s1,s4,2b8 <gets+0x56>
    cc = read(0, &c, 1);
 28c:	4605                	li	a2,1
 28e:	faf40593          	addi	a1,s0,-81
 292:	4501                	li	a0,0
 294:	00000097          	auipc	ra,0x0
 298:	19a080e7          	jalr	410(ra) # 42e <read>
    if(cc < 1)
 29c:	00a05e63          	blez	a0,2b8 <gets+0x56>
    buf[i++] = c;
 2a0:	faf44783          	lbu	a5,-81(s0)
 2a4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2a8:	01578763          	beq	a5,s5,2b6 <gets+0x54>
 2ac:	0905                	addi	s2,s2,1
 2ae:	fd679be3          	bne	a5,s6,284 <gets+0x22>
    buf[i++] = c;
 2b2:	89a6                	mv	s3,s1
 2b4:	a011                	j	2b8 <gets+0x56>
 2b6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2b8:	99de                	add	s3,s3,s7
 2ba:	00098023          	sb	zero,0(s3)
  return buf;
}
 2be:	855e                	mv	a0,s7
 2c0:	60e6                	ld	ra,88(sp)
 2c2:	6446                	ld	s0,80(sp)
 2c4:	64a6                	ld	s1,72(sp)
 2c6:	6906                	ld	s2,64(sp)
 2c8:	79e2                	ld	s3,56(sp)
 2ca:	7a42                	ld	s4,48(sp)
 2cc:	7aa2                	ld	s5,40(sp)
 2ce:	7b02                	ld	s6,32(sp)
 2d0:	6be2                	ld	s7,24(sp)
 2d2:	6125                	addi	sp,sp,96
 2d4:	8082                	ret

00000000000002d6 <stat>:

int
stat(const char *n, struct stat *st)
{
 2d6:	1101                	addi	sp,sp,-32
 2d8:	ec06                	sd	ra,24(sp)
 2da:	e822                	sd	s0,16(sp)
 2dc:	e04a                	sd	s2,0(sp)
 2de:	1000                	addi	s0,sp,32
 2e0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2e2:	4581                	li	a1,0
 2e4:	00000097          	auipc	ra,0x0
 2e8:	172080e7          	jalr	370(ra) # 456 <open>
  if(fd < 0)
 2ec:	02054663          	bltz	a0,318 <stat+0x42>
 2f0:	e426                	sd	s1,8(sp)
 2f2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2f4:	85ca                	mv	a1,s2
 2f6:	00000097          	auipc	ra,0x0
 2fa:	178080e7          	jalr	376(ra) # 46e <fstat>
 2fe:	892a                	mv	s2,a0
  close(fd);
 300:	8526                	mv	a0,s1
 302:	00000097          	auipc	ra,0x0
 306:	13c080e7          	jalr	316(ra) # 43e <close>
  return r;
 30a:	64a2                	ld	s1,8(sp)
}
 30c:	854a                	mv	a0,s2
 30e:	60e2                	ld	ra,24(sp)
 310:	6442                	ld	s0,16(sp)
 312:	6902                	ld	s2,0(sp)
 314:	6105                	addi	sp,sp,32
 316:	8082                	ret
    return -1;
 318:	597d                	li	s2,-1
 31a:	bfcd                	j	30c <stat+0x36>

000000000000031c <atoi>:

int
atoi(const char *s)
{
 31c:	1141                	addi	sp,sp,-16
 31e:	e422                	sd	s0,8(sp)
 320:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 322:	00054683          	lbu	a3,0(a0)
 326:	fd06879b          	addiw	a5,a3,-48
 32a:	0ff7f793          	zext.b	a5,a5
 32e:	4625                	li	a2,9
 330:	02f66863          	bltu	a2,a5,360 <atoi+0x44>
 334:	872a                	mv	a4,a0
  n = 0;
 336:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 338:	0705                	addi	a4,a4,1
 33a:	0025179b          	slliw	a5,a0,0x2
 33e:	9fa9                	addw	a5,a5,a0
 340:	0017979b          	slliw	a5,a5,0x1
 344:	9fb5                	addw	a5,a5,a3
 346:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 34a:	00074683          	lbu	a3,0(a4)
 34e:	fd06879b          	addiw	a5,a3,-48
 352:	0ff7f793          	zext.b	a5,a5
 356:	fef671e3          	bgeu	a2,a5,338 <atoi+0x1c>
  return n;
}
 35a:	6422                	ld	s0,8(sp)
 35c:	0141                	addi	sp,sp,16
 35e:	8082                	ret
  n = 0;
 360:	4501                	li	a0,0
 362:	bfe5                	j	35a <atoi+0x3e>

0000000000000364 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 364:	1141                	addi	sp,sp,-16
 366:	e422                	sd	s0,8(sp)
 368:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 36a:	02b57463          	bgeu	a0,a1,392 <memmove+0x2e>
    while(n-- > 0)
 36e:	00c05f63          	blez	a2,38c <memmove+0x28>
 372:	1602                	slli	a2,a2,0x20
 374:	9201                	srli	a2,a2,0x20
 376:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 37a:	872a                	mv	a4,a0
      *dst++ = *src++;
 37c:	0585                	addi	a1,a1,1
 37e:	0705                	addi	a4,a4,1
 380:	fff5c683          	lbu	a3,-1(a1)
 384:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 388:	fef71ae3          	bne	a4,a5,37c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 38c:	6422                	ld	s0,8(sp)
 38e:	0141                	addi	sp,sp,16
 390:	8082                	ret
    dst += n;
 392:	00c50733          	add	a4,a0,a2
    src += n;
 396:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 398:	fec05ae3          	blez	a2,38c <memmove+0x28>
 39c:	fff6079b          	addiw	a5,a2,-1
 3a0:	1782                	slli	a5,a5,0x20
 3a2:	9381                	srli	a5,a5,0x20
 3a4:	fff7c793          	not	a5,a5
 3a8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3aa:	15fd                	addi	a1,a1,-1
 3ac:	177d                	addi	a4,a4,-1
 3ae:	0005c683          	lbu	a3,0(a1)
 3b2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3b6:	fee79ae3          	bne	a5,a4,3aa <memmove+0x46>
 3ba:	bfc9                	j	38c <memmove+0x28>

00000000000003bc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3bc:	1141                	addi	sp,sp,-16
 3be:	e422                	sd	s0,8(sp)
 3c0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3c2:	ca05                	beqz	a2,3f2 <memcmp+0x36>
 3c4:	fff6069b          	addiw	a3,a2,-1
 3c8:	1682                	slli	a3,a3,0x20
 3ca:	9281                	srli	a3,a3,0x20
 3cc:	0685                	addi	a3,a3,1
 3ce:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3d0:	00054783          	lbu	a5,0(a0)
 3d4:	0005c703          	lbu	a4,0(a1)
 3d8:	00e79863          	bne	a5,a4,3e8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3dc:	0505                	addi	a0,a0,1
    p2++;
 3de:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3e0:	fed518e3          	bne	a0,a3,3d0 <memcmp+0x14>
  }
  return 0;
 3e4:	4501                	li	a0,0
 3e6:	a019                	j	3ec <memcmp+0x30>
      return *p1 - *p2;
 3e8:	40e7853b          	subw	a0,a5,a4
}
 3ec:	6422                	ld	s0,8(sp)
 3ee:	0141                	addi	sp,sp,16
 3f0:	8082                	ret
  return 0;
 3f2:	4501                	li	a0,0
 3f4:	bfe5                	j	3ec <memcmp+0x30>

00000000000003f6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3f6:	1141                	addi	sp,sp,-16
 3f8:	e406                	sd	ra,8(sp)
 3fa:	e022                	sd	s0,0(sp)
 3fc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3fe:	00000097          	auipc	ra,0x0
 402:	f66080e7          	jalr	-154(ra) # 364 <memmove>
}
 406:	60a2                	ld	ra,8(sp)
 408:	6402                	ld	s0,0(sp)
 40a:	0141                	addi	sp,sp,16
 40c:	8082                	ret

000000000000040e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 40e:	4885                	li	a7,1
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <exit>:
.global exit
exit:
 li a7, SYS_exit
 416:	4889                	li	a7,2
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <wait>:
.global wait
wait:
 li a7, SYS_wait
 41e:	488d                	li	a7,3
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 426:	4891                	li	a7,4
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <read>:
.global read
read:
 li a7, SYS_read
 42e:	4895                	li	a7,5
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <write>:
.global write
write:
 li a7, SYS_write
 436:	48c1                	li	a7,16
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <close>:
.global close
close:
 li a7, SYS_close
 43e:	48d5                	li	a7,21
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <kill>:
.global kill
kill:
 li a7, SYS_kill
 446:	4899                	li	a7,6
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <exec>:
.global exec
exec:
 li a7, SYS_exec
 44e:	489d                	li	a7,7
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <open>:
.global open
open:
 li a7, SYS_open
 456:	48bd                	li	a7,15
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 45e:	48c5                	li	a7,17
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 466:	48c9                	li	a7,18
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 46e:	48a1                	li	a7,8
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <link>:
.global link
link:
 li a7, SYS_link
 476:	48cd                	li	a7,19
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 47e:	48d1                	li	a7,20
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 486:	48a5                	li	a7,9
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <dup>:
.global dup
dup:
 li a7, SYS_dup
 48e:	48a9                	li	a7,10
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 496:	48ad                	li	a7,11
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 49e:	48b1                	li	a7,12
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4a6:	48b5                	li	a7,13
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4ae:	48b9                	li	a7,14
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <yield>:
.global yield
yield:
 li a7, SYS_yield
 4b6:	48d9                	li	a7,22
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <lock>:
.global lock
lock:
 li a7, SYS_lock
 4be:	48dd                	li	a7,23
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <unlock>:
.global unlock
unlock:
 li a7, SYS_unlock
 4c6:	48e1                	li	a7,24
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4ce:	1101                	addi	sp,sp,-32
 4d0:	ec06                	sd	ra,24(sp)
 4d2:	e822                	sd	s0,16(sp)
 4d4:	1000                	addi	s0,sp,32
 4d6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4da:	4605                	li	a2,1
 4dc:	fef40593          	addi	a1,s0,-17
 4e0:	00000097          	auipc	ra,0x0
 4e4:	f56080e7          	jalr	-170(ra) # 436 <write>
}
 4e8:	60e2                	ld	ra,24(sp)
 4ea:	6442                	ld	s0,16(sp)
 4ec:	6105                	addi	sp,sp,32
 4ee:	8082                	ret

00000000000004f0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4f0:	7139                	addi	sp,sp,-64
 4f2:	fc06                	sd	ra,56(sp)
 4f4:	f822                	sd	s0,48(sp)
 4f6:	f426                	sd	s1,40(sp)
 4f8:	0080                	addi	s0,sp,64
 4fa:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4fc:	c299                	beqz	a3,502 <printint+0x12>
 4fe:	0805cb63          	bltz	a1,594 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 502:	2581                	sext.w	a1,a1
  neg = 0;
 504:	4881                	li	a7,0
 506:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 50a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 50c:	2601                	sext.w	a2,a2
 50e:	00000517          	auipc	a0,0x0
 512:	65a50513          	addi	a0,a0,1626 # b68 <digits>
 516:	883a                	mv	a6,a4
 518:	2705                	addiw	a4,a4,1
 51a:	02c5f7bb          	remuw	a5,a1,a2
 51e:	1782                	slli	a5,a5,0x20
 520:	9381                	srli	a5,a5,0x20
 522:	97aa                	add	a5,a5,a0
 524:	0007c783          	lbu	a5,0(a5)
 528:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 52c:	0005879b          	sext.w	a5,a1
 530:	02c5d5bb          	divuw	a1,a1,a2
 534:	0685                	addi	a3,a3,1
 536:	fec7f0e3          	bgeu	a5,a2,516 <printint+0x26>
  if(neg)
 53a:	00088c63          	beqz	a7,552 <printint+0x62>
    buf[i++] = '-';
 53e:	fd070793          	addi	a5,a4,-48
 542:	00878733          	add	a4,a5,s0
 546:	02d00793          	li	a5,45
 54a:	fef70823          	sb	a5,-16(a4)
 54e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 552:	02e05c63          	blez	a4,58a <printint+0x9a>
 556:	f04a                	sd	s2,32(sp)
 558:	ec4e                	sd	s3,24(sp)
 55a:	fc040793          	addi	a5,s0,-64
 55e:	00e78933          	add	s2,a5,a4
 562:	fff78993          	addi	s3,a5,-1
 566:	99ba                	add	s3,s3,a4
 568:	377d                	addiw	a4,a4,-1
 56a:	1702                	slli	a4,a4,0x20
 56c:	9301                	srli	a4,a4,0x20
 56e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 572:	fff94583          	lbu	a1,-1(s2)
 576:	8526                	mv	a0,s1
 578:	00000097          	auipc	ra,0x0
 57c:	f56080e7          	jalr	-170(ra) # 4ce <putc>
  while(--i >= 0)
 580:	197d                	addi	s2,s2,-1
 582:	ff3918e3          	bne	s2,s3,572 <printint+0x82>
 586:	7902                	ld	s2,32(sp)
 588:	69e2                	ld	s3,24(sp)
}
 58a:	70e2                	ld	ra,56(sp)
 58c:	7442                	ld	s0,48(sp)
 58e:	74a2                	ld	s1,40(sp)
 590:	6121                	addi	sp,sp,64
 592:	8082                	ret
    x = -xx;
 594:	40b005bb          	negw	a1,a1
    neg = 1;
 598:	4885                	li	a7,1
    x = -xx;
 59a:	b7b5                	j	506 <printint+0x16>

000000000000059c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 59c:	715d                	addi	sp,sp,-80
 59e:	e486                	sd	ra,72(sp)
 5a0:	e0a2                	sd	s0,64(sp)
 5a2:	f84a                	sd	s2,48(sp)
 5a4:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5a6:	0005c903          	lbu	s2,0(a1)
 5aa:	1a090a63          	beqz	s2,75e <vprintf+0x1c2>
 5ae:	fc26                	sd	s1,56(sp)
 5b0:	f44e                	sd	s3,40(sp)
 5b2:	f052                	sd	s4,32(sp)
 5b4:	ec56                	sd	s5,24(sp)
 5b6:	e85a                	sd	s6,16(sp)
 5b8:	e45e                	sd	s7,8(sp)
 5ba:	8aaa                	mv	s5,a0
 5bc:	8bb2                	mv	s7,a2
 5be:	00158493          	addi	s1,a1,1
  state = 0;
 5c2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5c4:	02500a13          	li	s4,37
 5c8:	4b55                	li	s6,21
 5ca:	a839                	j	5e8 <vprintf+0x4c>
        putc(fd, c);
 5cc:	85ca                	mv	a1,s2
 5ce:	8556                	mv	a0,s5
 5d0:	00000097          	auipc	ra,0x0
 5d4:	efe080e7          	jalr	-258(ra) # 4ce <putc>
 5d8:	a019                	j	5de <vprintf+0x42>
    } else if(state == '%'){
 5da:	01498d63          	beq	s3,s4,5f4 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 5de:	0485                	addi	s1,s1,1
 5e0:	fff4c903          	lbu	s2,-1(s1)
 5e4:	16090763          	beqz	s2,752 <vprintf+0x1b6>
    if(state == 0){
 5e8:	fe0999e3          	bnez	s3,5da <vprintf+0x3e>
      if(c == '%'){
 5ec:	ff4910e3          	bne	s2,s4,5cc <vprintf+0x30>
        state = '%';
 5f0:	89d2                	mv	s3,s4
 5f2:	b7f5                	j	5de <vprintf+0x42>
      if(c == 'd'){
 5f4:	13490463          	beq	s2,s4,71c <vprintf+0x180>
 5f8:	f9d9079b          	addiw	a5,s2,-99
 5fc:	0ff7f793          	zext.b	a5,a5
 600:	12fb6763          	bltu	s6,a5,72e <vprintf+0x192>
 604:	f9d9079b          	addiw	a5,s2,-99
 608:	0ff7f713          	zext.b	a4,a5
 60c:	12eb6163          	bltu	s6,a4,72e <vprintf+0x192>
 610:	00271793          	slli	a5,a4,0x2
 614:	00000717          	auipc	a4,0x0
 618:	4fc70713          	addi	a4,a4,1276 # b10 <malloc+0x18c>
 61c:	97ba                	add	a5,a5,a4
 61e:	439c                	lw	a5,0(a5)
 620:	97ba                	add	a5,a5,a4
 622:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 624:	008b8913          	addi	s2,s7,8
 628:	4685                	li	a3,1
 62a:	4629                	li	a2,10
 62c:	000ba583          	lw	a1,0(s7)
 630:	8556                	mv	a0,s5
 632:	00000097          	auipc	ra,0x0
 636:	ebe080e7          	jalr	-322(ra) # 4f0 <printint>
 63a:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 63c:	4981                	li	s3,0
 63e:	b745                	j	5de <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 640:	008b8913          	addi	s2,s7,8
 644:	4681                	li	a3,0
 646:	4629                	li	a2,10
 648:	000ba583          	lw	a1,0(s7)
 64c:	8556                	mv	a0,s5
 64e:	00000097          	auipc	ra,0x0
 652:	ea2080e7          	jalr	-350(ra) # 4f0 <printint>
 656:	8bca                	mv	s7,s2
      state = 0;
 658:	4981                	li	s3,0
 65a:	b751                	j	5de <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 65c:	008b8913          	addi	s2,s7,8
 660:	4681                	li	a3,0
 662:	4641                	li	a2,16
 664:	000ba583          	lw	a1,0(s7)
 668:	8556                	mv	a0,s5
 66a:	00000097          	auipc	ra,0x0
 66e:	e86080e7          	jalr	-378(ra) # 4f0 <printint>
 672:	8bca                	mv	s7,s2
      state = 0;
 674:	4981                	li	s3,0
 676:	b7a5                	j	5de <vprintf+0x42>
 678:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 67a:	008b8c13          	addi	s8,s7,8
 67e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 682:	03000593          	li	a1,48
 686:	8556                	mv	a0,s5
 688:	00000097          	auipc	ra,0x0
 68c:	e46080e7          	jalr	-442(ra) # 4ce <putc>
  putc(fd, 'x');
 690:	07800593          	li	a1,120
 694:	8556                	mv	a0,s5
 696:	00000097          	auipc	ra,0x0
 69a:	e38080e7          	jalr	-456(ra) # 4ce <putc>
 69e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6a0:	00000b97          	auipc	s7,0x0
 6a4:	4c8b8b93          	addi	s7,s7,1224 # b68 <digits>
 6a8:	03c9d793          	srli	a5,s3,0x3c
 6ac:	97de                	add	a5,a5,s7
 6ae:	0007c583          	lbu	a1,0(a5)
 6b2:	8556                	mv	a0,s5
 6b4:	00000097          	auipc	ra,0x0
 6b8:	e1a080e7          	jalr	-486(ra) # 4ce <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6bc:	0992                	slli	s3,s3,0x4
 6be:	397d                	addiw	s2,s2,-1
 6c0:	fe0914e3          	bnez	s2,6a8 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 6c4:	8be2                	mv	s7,s8
      state = 0;
 6c6:	4981                	li	s3,0
 6c8:	6c02                	ld	s8,0(sp)
 6ca:	bf11                	j	5de <vprintf+0x42>
        s = va_arg(ap, char*);
 6cc:	008b8993          	addi	s3,s7,8
 6d0:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 6d4:	02090163          	beqz	s2,6f6 <vprintf+0x15a>
        while(*s != 0){
 6d8:	00094583          	lbu	a1,0(s2)
 6dc:	c9a5                	beqz	a1,74c <vprintf+0x1b0>
          putc(fd, *s);
 6de:	8556                	mv	a0,s5
 6e0:	00000097          	auipc	ra,0x0
 6e4:	dee080e7          	jalr	-530(ra) # 4ce <putc>
          s++;
 6e8:	0905                	addi	s2,s2,1
        while(*s != 0){
 6ea:	00094583          	lbu	a1,0(s2)
 6ee:	f9e5                	bnez	a1,6de <vprintf+0x142>
        s = va_arg(ap, char*);
 6f0:	8bce                	mv	s7,s3
      state = 0;
 6f2:	4981                	li	s3,0
 6f4:	b5ed                	j	5de <vprintf+0x42>
          s = "(null)";
 6f6:	00000917          	auipc	s2,0x0
 6fa:	41290913          	addi	s2,s2,1042 # b08 <malloc+0x184>
        while(*s != 0){
 6fe:	02800593          	li	a1,40
 702:	bff1                	j	6de <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 704:	008b8913          	addi	s2,s7,8
 708:	000bc583          	lbu	a1,0(s7)
 70c:	8556                	mv	a0,s5
 70e:	00000097          	auipc	ra,0x0
 712:	dc0080e7          	jalr	-576(ra) # 4ce <putc>
 716:	8bca                	mv	s7,s2
      state = 0;
 718:	4981                	li	s3,0
 71a:	b5d1                	j	5de <vprintf+0x42>
        putc(fd, c);
 71c:	02500593          	li	a1,37
 720:	8556                	mv	a0,s5
 722:	00000097          	auipc	ra,0x0
 726:	dac080e7          	jalr	-596(ra) # 4ce <putc>
      state = 0;
 72a:	4981                	li	s3,0
 72c:	bd4d                	j	5de <vprintf+0x42>
        putc(fd, '%');
 72e:	02500593          	li	a1,37
 732:	8556                	mv	a0,s5
 734:	00000097          	auipc	ra,0x0
 738:	d9a080e7          	jalr	-614(ra) # 4ce <putc>
        putc(fd, c);
 73c:	85ca                	mv	a1,s2
 73e:	8556                	mv	a0,s5
 740:	00000097          	auipc	ra,0x0
 744:	d8e080e7          	jalr	-626(ra) # 4ce <putc>
      state = 0;
 748:	4981                	li	s3,0
 74a:	bd51                	j	5de <vprintf+0x42>
        s = va_arg(ap, char*);
 74c:	8bce                	mv	s7,s3
      state = 0;
 74e:	4981                	li	s3,0
 750:	b579                	j	5de <vprintf+0x42>
 752:	74e2                	ld	s1,56(sp)
 754:	79a2                	ld	s3,40(sp)
 756:	7a02                	ld	s4,32(sp)
 758:	6ae2                	ld	s5,24(sp)
 75a:	6b42                	ld	s6,16(sp)
 75c:	6ba2                	ld	s7,8(sp)
    }
  }
}
 75e:	60a6                	ld	ra,72(sp)
 760:	6406                	ld	s0,64(sp)
 762:	7942                	ld	s2,48(sp)
 764:	6161                	addi	sp,sp,80
 766:	8082                	ret

0000000000000768 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 768:	715d                	addi	sp,sp,-80
 76a:	ec06                	sd	ra,24(sp)
 76c:	e822                	sd	s0,16(sp)
 76e:	1000                	addi	s0,sp,32
 770:	e010                	sd	a2,0(s0)
 772:	e414                	sd	a3,8(s0)
 774:	e818                	sd	a4,16(s0)
 776:	ec1c                	sd	a5,24(s0)
 778:	03043023          	sd	a6,32(s0)
 77c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 780:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 784:	8622                	mv	a2,s0
 786:	00000097          	auipc	ra,0x0
 78a:	e16080e7          	jalr	-490(ra) # 59c <vprintf>
}
 78e:	60e2                	ld	ra,24(sp)
 790:	6442                	ld	s0,16(sp)
 792:	6161                	addi	sp,sp,80
 794:	8082                	ret

0000000000000796 <printf>:

void
printf(const char *fmt, ...)
{
 796:	7159                	addi	sp,sp,-112
 798:	f406                	sd	ra,40(sp)
 79a:	f022                	sd	s0,32(sp)
 79c:	ec26                	sd	s1,24(sp)
 79e:	1800                	addi	s0,sp,48
 7a0:	84aa                	mv	s1,a0
 7a2:	e40c                	sd	a1,8(s0)
 7a4:	e810                	sd	a2,16(s0)
 7a6:	ec14                	sd	a3,24(s0)
 7a8:	f018                	sd	a4,32(s0)
 7aa:	f41c                	sd	a5,40(s0)
 7ac:	03043823          	sd	a6,48(s0)
 7b0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  lock();
 7b4:	00000097          	auipc	ra,0x0
 7b8:	d0a080e7          	jalr	-758(ra) # 4be <lock>
  va_start(ap, fmt);
 7bc:	00840613          	addi	a2,s0,8
 7c0:	fcc43c23          	sd	a2,-40(s0)
  vprintf(1, fmt, ap);
 7c4:	85a6                	mv	a1,s1
 7c6:	4505                	li	a0,1
 7c8:	00000097          	auipc	ra,0x0
 7cc:	dd4080e7          	jalr	-556(ra) # 59c <vprintf>
  unlock();
 7d0:	00000097          	auipc	ra,0x0
 7d4:	cf6080e7          	jalr	-778(ra) # 4c6 <unlock>
}
 7d8:	70a2                	ld	ra,40(sp)
 7da:	7402                	ld	s0,32(sp)
 7dc:	64e2                	ld	s1,24(sp)
 7de:	6165                	addi	sp,sp,112
 7e0:	8082                	ret

00000000000007e2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e2:	7179                	addi	sp,sp,-48
 7e4:	f422                	sd	s0,40(sp)
 7e6:	1800                	addi	s0,sp,48
 7e8:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ec:	fd843783          	ld	a5,-40(s0)
 7f0:	17c1                	addi	a5,a5,-16
 7f2:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f6:	00001797          	auipc	a5,0x1
 7fa:	e3a78793          	addi	a5,a5,-454 # 1630 <freep>
 7fe:	639c                	ld	a5,0(a5)
 800:	fef43423          	sd	a5,-24(s0)
 804:	a815                	j	838 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 806:	fe843783          	ld	a5,-24(s0)
 80a:	639c                	ld	a5,0(a5)
 80c:	fe843703          	ld	a4,-24(s0)
 810:	00f76f63          	bltu	a4,a5,82e <free+0x4c>
 814:	fe043703          	ld	a4,-32(s0)
 818:	fe843783          	ld	a5,-24(s0)
 81c:	02e7eb63          	bltu	a5,a4,852 <free+0x70>
 820:	fe843783          	ld	a5,-24(s0)
 824:	639c                	ld	a5,0(a5)
 826:	fe043703          	ld	a4,-32(s0)
 82a:	02f76463          	bltu	a4,a5,852 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 82e:	fe843783          	ld	a5,-24(s0)
 832:	639c                	ld	a5,0(a5)
 834:	fef43423          	sd	a5,-24(s0)
 838:	fe043703          	ld	a4,-32(s0)
 83c:	fe843783          	ld	a5,-24(s0)
 840:	fce7f3e3          	bgeu	a5,a4,806 <free+0x24>
 844:	fe843783          	ld	a5,-24(s0)
 848:	639c                	ld	a5,0(a5)
 84a:	fe043703          	ld	a4,-32(s0)
 84e:	faf77ce3          	bgeu	a4,a5,806 <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 852:	fe043783          	ld	a5,-32(s0)
 856:	479c                	lw	a5,8(a5)
 858:	1782                	slli	a5,a5,0x20
 85a:	9381                	srli	a5,a5,0x20
 85c:	0792                	slli	a5,a5,0x4
 85e:	fe043703          	ld	a4,-32(s0)
 862:	973e                	add	a4,a4,a5
 864:	fe843783          	ld	a5,-24(s0)
 868:	639c                	ld	a5,0(a5)
 86a:	02f71763          	bne	a4,a5,898 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 86e:	fe043783          	ld	a5,-32(s0)
 872:	4798                	lw	a4,8(a5)
 874:	fe843783          	ld	a5,-24(s0)
 878:	639c                	ld	a5,0(a5)
 87a:	479c                	lw	a5,8(a5)
 87c:	9fb9                	addw	a5,a5,a4
 87e:	0007871b          	sext.w	a4,a5
 882:	fe043783          	ld	a5,-32(s0)
 886:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 888:	fe843783          	ld	a5,-24(s0)
 88c:	639c                	ld	a5,0(a5)
 88e:	6398                	ld	a4,0(a5)
 890:	fe043783          	ld	a5,-32(s0)
 894:	e398                	sd	a4,0(a5)
 896:	a039                	j	8a4 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 898:	fe843783          	ld	a5,-24(s0)
 89c:	6398                	ld	a4,0(a5)
 89e:	fe043783          	ld	a5,-32(s0)
 8a2:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 8a4:	fe843783          	ld	a5,-24(s0)
 8a8:	479c                	lw	a5,8(a5)
 8aa:	1782                	slli	a5,a5,0x20
 8ac:	9381                	srli	a5,a5,0x20
 8ae:	0792                	slli	a5,a5,0x4
 8b0:	fe843703          	ld	a4,-24(s0)
 8b4:	97ba                	add	a5,a5,a4
 8b6:	fe043703          	ld	a4,-32(s0)
 8ba:	02f71563          	bne	a4,a5,8e4 <free+0x102>
    p->s.size += bp->s.size;
 8be:	fe843783          	ld	a5,-24(s0)
 8c2:	4798                	lw	a4,8(a5)
 8c4:	fe043783          	ld	a5,-32(s0)
 8c8:	479c                	lw	a5,8(a5)
 8ca:	9fb9                	addw	a5,a5,a4
 8cc:	0007871b          	sext.w	a4,a5
 8d0:	fe843783          	ld	a5,-24(s0)
 8d4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8d6:	fe043783          	ld	a5,-32(s0)
 8da:	6398                	ld	a4,0(a5)
 8dc:	fe843783          	ld	a5,-24(s0)
 8e0:	e398                	sd	a4,0(a5)
 8e2:	a031                	j	8ee <free+0x10c>
  } else
    p->s.ptr = bp;
 8e4:	fe843783          	ld	a5,-24(s0)
 8e8:	fe043703          	ld	a4,-32(s0)
 8ec:	e398                	sd	a4,0(a5)
  freep = p;
 8ee:	00001797          	auipc	a5,0x1
 8f2:	d4278793          	addi	a5,a5,-702 # 1630 <freep>
 8f6:	fe843703          	ld	a4,-24(s0)
 8fa:	e398                	sd	a4,0(a5)
}
 8fc:	0001                	nop
 8fe:	7422                	ld	s0,40(sp)
 900:	6145                	addi	sp,sp,48
 902:	8082                	ret

0000000000000904 <morecore>:

static Header*
morecore(uint nu)
{
 904:	7179                	addi	sp,sp,-48
 906:	f406                	sd	ra,40(sp)
 908:	f022                	sd	s0,32(sp)
 90a:	1800                	addi	s0,sp,48
 90c:	87aa                	mv	a5,a0
 90e:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 912:	fdc42783          	lw	a5,-36(s0)
 916:	0007871b          	sext.w	a4,a5
 91a:	6785                	lui	a5,0x1
 91c:	00f77563          	bgeu	a4,a5,926 <morecore+0x22>
    nu = 4096;
 920:	6785                	lui	a5,0x1
 922:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 926:	fdc42783          	lw	a5,-36(s0)
 92a:	0047979b          	slliw	a5,a5,0x4
 92e:	2781                	sext.w	a5,a5
 930:	2781                	sext.w	a5,a5
 932:	853e                	mv	a0,a5
 934:	00000097          	auipc	ra,0x0
 938:	b6a080e7          	jalr	-1174(ra) # 49e <sbrk>
 93c:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 940:	fe843703          	ld	a4,-24(s0)
 944:	57fd                	li	a5,-1
 946:	00f71463          	bne	a4,a5,94e <morecore+0x4a>
    return 0;
 94a:	4781                	li	a5,0
 94c:	a03d                	j	97a <morecore+0x76>
  hp = (Header*)p;
 94e:	fe843783          	ld	a5,-24(s0)
 952:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 956:	fe043783          	ld	a5,-32(s0)
 95a:	fdc42703          	lw	a4,-36(s0)
 95e:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 960:	fe043783          	ld	a5,-32(s0)
 964:	07c1                	addi	a5,a5,16 # 1010 <digits+0x4a8>
 966:	853e                	mv	a0,a5
 968:	00000097          	auipc	ra,0x0
 96c:	e7a080e7          	jalr	-390(ra) # 7e2 <free>
  return freep;
 970:	00001797          	auipc	a5,0x1
 974:	cc078793          	addi	a5,a5,-832 # 1630 <freep>
 978:	639c                	ld	a5,0(a5)
}
 97a:	853e                	mv	a0,a5
 97c:	70a2                	ld	ra,40(sp)
 97e:	7402                	ld	s0,32(sp)
 980:	6145                	addi	sp,sp,48
 982:	8082                	ret

0000000000000984 <malloc>:

void*
malloc(uint nbytes)
{
 984:	7139                	addi	sp,sp,-64
 986:	fc06                	sd	ra,56(sp)
 988:	f822                	sd	s0,48(sp)
 98a:	0080                	addi	s0,sp,64
 98c:	87aa                	mv	a5,a0
 98e:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 992:	fcc46783          	lwu	a5,-52(s0)
 996:	07bd                	addi	a5,a5,15
 998:	8391                	srli	a5,a5,0x4
 99a:	2781                	sext.w	a5,a5
 99c:	2785                	addiw	a5,a5,1
 99e:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 9a2:	00001797          	auipc	a5,0x1
 9a6:	c8e78793          	addi	a5,a5,-882 # 1630 <freep>
 9aa:	639c                	ld	a5,0(a5)
 9ac:	fef43023          	sd	a5,-32(s0)
 9b0:	fe043783          	ld	a5,-32(s0)
 9b4:	ef95                	bnez	a5,9f0 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 9b6:	00001797          	auipc	a5,0x1
 9ba:	c6a78793          	addi	a5,a5,-918 # 1620 <base>
 9be:	fef43023          	sd	a5,-32(s0)
 9c2:	00001797          	auipc	a5,0x1
 9c6:	c6e78793          	addi	a5,a5,-914 # 1630 <freep>
 9ca:	fe043703          	ld	a4,-32(s0)
 9ce:	e398                	sd	a4,0(a5)
 9d0:	00001797          	auipc	a5,0x1
 9d4:	c6078793          	addi	a5,a5,-928 # 1630 <freep>
 9d8:	6398                	ld	a4,0(a5)
 9da:	00001797          	auipc	a5,0x1
 9de:	c4678793          	addi	a5,a5,-954 # 1620 <base>
 9e2:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 9e4:	00001797          	auipc	a5,0x1
 9e8:	c3c78793          	addi	a5,a5,-964 # 1620 <base>
 9ec:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f0:	fe043783          	ld	a5,-32(s0)
 9f4:	639c                	ld	a5,0(a5)
 9f6:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 9fa:	fe843783          	ld	a5,-24(s0)
 9fe:	4798                	lw	a4,8(a5)
 a00:	fdc42783          	lw	a5,-36(s0)
 a04:	2781                	sext.w	a5,a5
 a06:	06f76763          	bltu	a4,a5,a74 <malloc+0xf0>
      if(p->s.size == nunits)
 a0a:	fe843783          	ld	a5,-24(s0)
 a0e:	4798                	lw	a4,8(a5)
 a10:	fdc42783          	lw	a5,-36(s0)
 a14:	2781                	sext.w	a5,a5
 a16:	00e79963          	bne	a5,a4,a28 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 a1a:	fe843783          	ld	a5,-24(s0)
 a1e:	6398                	ld	a4,0(a5)
 a20:	fe043783          	ld	a5,-32(s0)
 a24:	e398                	sd	a4,0(a5)
 a26:	a825                	j	a5e <malloc+0xda>
      else {
        p->s.size -= nunits;
 a28:	fe843783          	ld	a5,-24(s0)
 a2c:	479c                	lw	a5,8(a5)
 a2e:	fdc42703          	lw	a4,-36(s0)
 a32:	9f99                	subw	a5,a5,a4
 a34:	0007871b          	sext.w	a4,a5
 a38:	fe843783          	ld	a5,-24(s0)
 a3c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a3e:	fe843783          	ld	a5,-24(s0)
 a42:	479c                	lw	a5,8(a5)
 a44:	1782                	slli	a5,a5,0x20
 a46:	9381                	srli	a5,a5,0x20
 a48:	0792                	slli	a5,a5,0x4
 a4a:	fe843703          	ld	a4,-24(s0)
 a4e:	97ba                	add	a5,a5,a4
 a50:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 a54:	fe843783          	ld	a5,-24(s0)
 a58:	fdc42703          	lw	a4,-36(s0)
 a5c:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 a5e:	00001797          	auipc	a5,0x1
 a62:	bd278793          	addi	a5,a5,-1070 # 1630 <freep>
 a66:	fe043703          	ld	a4,-32(s0)
 a6a:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 a6c:	fe843783          	ld	a5,-24(s0)
 a70:	07c1                	addi	a5,a5,16
 a72:	a091                	j	ab6 <malloc+0x132>
    }
    if(p == freep)
 a74:	00001797          	auipc	a5,0x1
 a78:	bbc78793          	addi	a5,a5,-1092 # 1630 <freep>
 a7c:	639c                	ld	a5,0(a5)
 a7e:	fe843703          	ld	a4,-24(s0)
 a82:	02f71063          	bne	a4,a5,aa2 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 a86:	fdc42783          	lw	a5,-36(s0)
 a8a:	853e                	mv	a0,a5
 a8c:	00000097          	auipc	ra,0x0
 a90:	e78080e7          	jalr	-392(ra) # 904 <morecore>
 a94:	fea43423          	sd	a0,-24(s0)
 a98:	fe843783          	ld	a5,-24(s0)
 a9c:	e399                	bnez	a5,aa2 <malloc+0x11e>
        return 0;
 a9e:	4781                	li	a5,0
 aa0:	a819                	j	ab6 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aa2:	fe843783          	ld	a5,-24(s0)
 aa6:	fef43023          	sd	a5,-32(s0)
 aaa:	fe843783          	ld	a5,-24(s0)
 aae:	639c                	ld	a5,0(a5)
 ab0:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 ab4:	b799                	j	9fa <malloc+0x76>
  }
}
 ab6:	853e                	mv	a0,a5
 ab8:	70e2                	ld	ra,56(sp)
 aba:	7442                	ld	s0,48(sp)
 abc:	6121                	addi	sp,sp,64
 abe:	8082                	ret
