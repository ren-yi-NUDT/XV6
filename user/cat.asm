
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  10:	00001917          	auipc	s2,0x1
  14:	3f090913          	addi	s2,s2,1008 # 1400 <buf>
  18:	20000613          	li	a2,512
  1c:	85ca                	mv	a1,s2
  1e:	854e                	mv	a0,s3
  20:	00000097          	auipc	ra,0x0
  24:	3a0080e7          	jalr	928(ra) # 3c0 <read>
  28:	84aa                	mv	s1,a0
  2a:	02a05963          	blez	a0,5c <cat+0x5c>
    if (write(1, buf, n) != n) {
  2e:	8626                	mv	a2,s1
  30:	85ca                	mv	a1,s2
  32:	4505                	li	a0,1
  34:	00000097          	auipc	ra,0x0
  38:	394080e7          	jalr	916(ra) # 3c8 <write>
  3c:	fc950ee3          	beq	a0,s1,18 <cat+0x18>
      fprintf(2, "cat: write error\n");
  40:	00001597          	auipc	a1,0x1
  44:	a2058593          	addi	a1,a1,-1504 # a60 <malloc+0x14a>
  48:	4509                	li	a0,2
  4a:	00000097          	auipc	ra,0x0
  4e:	6b0080e7          	jalr	1712(ra) # 6fa <fprintf>
      exit(1);
  52:	4505                	li	a0,1
  54:	00000097          	auipc	ra,0x0
  58:	354080e7          	jalr	852(ra) # 3a8 <exit>
    }
  }
  if(n < 0){
  5c:	00054963          	bltz	a0,6e <cat+0x6e>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  60:	70a2                	ld	ra,40(sp)
  62:	7402                	ld	s0,32(sp)
  64:	64e2                	ld	s1,24(sp)
  66:	6942                	ld	s2,16(sp)
  68:	69a2                	ld	s3,8(sp)
  6a:	6145                	addi	sp,sp,48
  6c:	8082                	ret
    fprintf(2, "cat: read error\n");
  6e:	00001597          	auipc	a1,0x1
  72:	a0a58593          	addi	a1,a1,-1526 # a78 <malloc+0x162>
  76:	4509                	li	a0,2
  78:	00000097          	auipc	ra,0x0
  7c:	682080e7          	jalr	1666(ra) # 6fa <fprintf>
    exit(1);
  80:	4505                	li	a0,1
  82:	00000097          	auipc	ra,0x0
  86:	326080e7          	jalr	806(ra) # 3a8 <exit>

000000000000008a <main>:

int
main(int argc, char *argv[])
{
  8a:	7179                	addi	sp,sp,-48
  8c:	f406                	sd	ra,40(sp)
  8e:	f022                	sd	s0,32(sp)
  90:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  92:	4785                	li	a5,1
  94:	04a7da63          	bge	a5,a0,e8 <main+0x5e>
  98:	ec26                	sd	s1,24(sp)
  9a:	e84a                	sd	s2,16(sp)
  9c:	e44e                	sd	s3,8(sp)
  9e:	00858913          	addi	s2,a1,8
  a2:	ffe5099b          	addiw	s3,a0,-2
  a6:	02099793          	slli	a5,s3,0x20
  aa:	01d7d993          	srli	s3,a5,0x1d
  ae:	05c1                	addi	a1,a1,16
  b0:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  b2:	4581                	li	a1,0
  b4:	00093503          	ld	a0,0(s2)
  b8:	00000097          	auipc	ra,0x0
  bc:	330080e7          	jalr	816(ra) # 3e8 <open>
  c0:	84aa                	mv	s1,a0
  c2:	04054063          	bltz	a0,102 <main+0x78>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  c6:	00000097          	auipc	ra,0x0
  ca:	f3a080e7          	jalr	-198(ra) # 0 <cat>
    close(fd);
  ce:	8526                	mv	a0,s1
  d0:	00000097          	auipc	ra,0x0
  d4:	300080e7          	jalr	768(ra) # 3d0 <close>
  for(i = 1; i < argc; i++){
  d8:	0921                	addi	s2,s2,8
  da:	fd391ce3          	bne	s2,s3,b2 <main+0x28>
  }
  exit(0);
  de:	4501                	li	a0,0
  e0:	00000097          	auipc	ra,0x0
  e4:	2c8080e7          	jalr	712(ra) # 3a8 <exit>
  e8:	ec26                	sd	s1,24(sp)
  ea:	e84a                	sd	s2,16(sp)
  ec:	e44e                	sd	s3,8(sp)
    cat(0);
  ee:	4501                	li	a0,0
  f0:	00000097          	auipc	ra,0x0
  f4:	f10080e7          	jalr	-240(ra) # 0 <cat>
    exit(0);
  f8:	4501                	li	a0,0
  fa:	00000097          	auipc	ra,0x0
  fe:	2ae080e7          	jalr	686(ra) # 3a8 <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
 102:	00093603          	ld	a2,0(s2)
 106:	00001597          	auipc	a1,0x1
 10a:	98a58593          	addi	a1,a1,-1654 # a90 <malloc+0x17a>
 10e:	4509                	li	a0,2
 110:	00000097          	auipc	ra,0x0
 114:	5ea080e7          	jalr	1514(ra) # 6fa <fprintf>
      exit(1);
 118:	4505                	li	a0,1
 11a:	00000097          	auipc	ra,0x0
 11e:	28e080e7          	jalr	654(ra) # 3a8 <exit>

0000000000000122 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 122:	1141                	addi	sp,sp,-16
 124:	e406                	sd	ra,8(sp)
 126:	e022                	sd	s0,0(sp)
 128:	0800                	addi	s0,sp,16
  extern int main();
  main();
 12a:	00000097          	auipc	ra,0x0
 12e:	f60080e7          	jalr	-160(ra) # 8a <main>
  exit(0);
 132:	4501                	li	a0,0
 134:	00000097          	auipc	ra,0x0
 138:	274080e7          	jalr	628(ra) # 3a8 <exit>

000000000000013c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 13c:	1141                	addi	sp,sp,-16
 13e:	e422                	sd	s0,8(sp)
 140:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 142:	87aa                	mv	a5,a0
 144:	0585                	addi	a1,a1,1
 146:	0785                	addi	a5,a5,1
 148:	fff5c703          	lbu	a4,-1(a1)
 14c:	fee78fa3          	sb	a4,-1(a5)
 150:	fb75                	bnez	a4,144 <strcpy+0x8>
    ;
  return os;
}
 152:	6422                	ld	s0,8(sp)
 154:	0141                	addi	sp,sp,16
 156:	8082                	ret

0000000000000158 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 158:	1141                	addi	sp,sp,-16
 15a:	e422                	sd	s0,8(sp)
 15c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 15e:	00054783          	lbu	a5,0(a0)
 162:	cb91                	beqz	a5,176 <strcmp+0x1e>
 164:	0005c703          	lbu	a4,0(a1)
 168:	00f71763          	bne	a4,a5,176 <strcmp+0x1e>
    p++, q++;
 16c:	0505                	addi	a0,a0,1
 16e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 170:	00054783          	lbu	a5,0(a0)
 174:	fbe5                	bnez	a5,164 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 176:	0005c503          	lbu	a0,0(a1)
}
 17a:	40a7853b          	subw	a0,a5,a0
 17e:	6422                	ld	s0,8(sp)
 180:	0141                	addi	sp,sp,16
 182:	8082                	ret

0000000000000184 <strlen>:

uint
strlen(const char *s)
{
 184:	1141                	addi	sp,sp,-16
 186:	e422                	sd	s0,8(sp)
 188:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 18a:	00054783          	lbu	a5,0(a0)
 18e:	cf91                	beqz	a5,1aa <strlen+0x26>
 190:	0505                	addi	a0,a0,1
 192:	87aa                	mv	a5,a0
 194:	86be                	mv	a3,a5
 196:	0785                	addi	a5,a5,1
 198:	fff7c703          	lbu	a4,-1(a5)
 19c:	ff65                	bnez	a4,194 <strlen+0x10>
 19e:	40a6853b          	subw	a0,a3,a0
 1a2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1a4:	6422                	ld	s0,8(sp)
 1a6:	0141                	addi	sp,sp,16
 1a8:	8082                	ret
  for(n = 0; s[n]; n++)
 1aa:	4501                	li	a0,0
 1ac:	bfe5                	j	1a4 <strlen+0x20>

00000000000001ae <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ae:	1141                	addi	sp,sp,-16
 1b0:	e422                	sd	s0,8(sp)
 1b2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1b4:	ca19                	beqz	a2,1ca <memset+0x1c>
 1b6:	87aa                	mv	a5,a0
 1b8:	1602                	slli	a2,a2,0x20
 1ba:	9201                	srli	a2,a2,0x20
 1bc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1c0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1c4:	0785                	addi	a5,a5,1
 1c6:	fee79de3          	bne	a5,a4,1c0 <memset+0x12>
  }
  return dst;
}
 1ca:	6422                	ld	s0,8(sp)
 1cc:	0141                	addi	sp,sp,16
 1ce:	8082                	ret

00000000000001d0 <strchr>:

char*
strchr(const char *s, char c)
{
 1d0:	1141                	addi	sp,sp,-16
 1d2:	e422                	sd	s0,8(sp)
 1d4:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1d6:	00054783          	lbu	a5,0(a0)
 1da:	cb99                	beqz	a5,1f0 <strchr+0x20>
    if(*s == c)
 1dc:	00f58763          	beq	a1,a5,1ea <strchr+0x1a>
  for(; *s; s++)
 1e0:	0505                	addi	a0,a0,1
 1e2:	00054783          	lbu	a5,0(a0)
 1e6:	fbfd                	bnez	a5,1dc <strchr+0xc>
      return (char*)s;
  return 0;
 1e8:	4501                	li	a0,0
}
 1ea:	6422                	ld	s0,8(sp)
 1ec:	0141                	addi	sp,sp,16
 1ee:	8082                	ret
  return 0;
 1f0:	4501                	li	a0,0
 1f2:	bfe5                	j	1ea <strchr+0x1a>

00000000000001f4 <gets>:

char*
gets(char *buf, int max)
{
 1f4:	711d                	addi	sp,sp,-96
 1f6:	ec86                	sd	ra,88(sp)
 1f8:	e8a2                	sd	s0,80(sp)
 1fa:	e4a6                	sd	s1,72(sp)
 1fc:	e0ca                	sd	s2,64(sp)
 1fe:	fc4e                	sd	s3,56(sp)
 200:	f852                	sd	s4,48(sp)
 202:	f456                	sd	s5,40(sp)
 204:	f05a                	sd	s6,32(sp)
 206:	ec5e                	sd	s7,24(sp)
 208:	1080                	addi	s0,sp,96
 20a:	8baa                	mv	s7,a0
 20c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 20e:	892a                	mv	s2,a0
 210:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 212:	4aa9                	li	s5,10
 214:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 216:	89a6                	mv	s3,s1
 218:	2485                	addiw	s1,s1,1
 21a:	0344d863          	bge	s1,s4,24a <gets+0x56>
    cc = read(0, &c, 1);
 21e:	4605                	li	a2,1
 220:	faf40593          	addi	a1,s0,-81
 224:	4501                	li	a0,0
 226:	00000097          	auipc	ra,0x0
 22a:	19a080e7          	jalr	410(ra) # 3c0 <read>
    if(cc < 1)
 22e:	00a05e63          	blez	a0,24a <gets+0x56>
    buf[i++] = c;
 232:	faf44783          	lbu	a5,-81(s0)
 236:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 23a:	01578763          	beq	a5,s5,248 <gets+0x54>
 23e:	0905                	addi	s2,s2,1
 240:	fd679be3          	bne	a5,s6,216 <gets+0x22>
    buf[i++] = c;
 244:	89a6                	mv	s3,s1
 246:	a011                	j	24a <gets+0x56>
 248:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 24a:	99de                	add	s3,s3,s7
 24c:	00098023          	sb	zero,0(s3)
  return buf;
}
 250:	855e                	mv	a0,s7
 252:	60e6                	ld	ra,88(sp)
 254:	6446                	ld	s0,80(sp)
 256:	64a6                	ld	s1,72(sp)
 258:	6906                	ld	s2,64(sp)
 25a:	79e2                	ld	s3,56(sp)
 25c:	7a42                	ld	s4,48(sp)
 25e:	7aa2                	ld	s5,40(sp)
 260:	7b02                	ld	s6,32(sp)
 262:	6be2                	ld	s7,24(sp)
 264:	6125                	addi	sp,sp,96
 266:	8082                	ret

0000000000000268 <stat>:

int
stat(const char *n, struct stat *st)
{
 268:	1101                	addi	sp,sp,-32
 26a:	ec06                	sd	ra,24(sp)
 26c:	e822                	sd	s0,16(sp)
 26e:	e04a                	sd	s2,0(sp)
 270:	1000                	addi	s0,sp,32
 272:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 274:	4581                	li	a1,0
 276:	00000097          	auipc	ra,0x0
 27a:	172080e7          	jalr	370(ra) # 3e8 <open>
  if(fd < 0)
 27e:	02054663          	bltz	a0,2aa <stat+0x42>
 282:	e426                	sd	s1,8(sp)
 284:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 286:	85ca                	mv	a1,s2
 288:	00000097          	auipc	ra,0x0
 28c:	178080e7          	jalr	376(ra) # 400 <fstat>
 290:	892a                	mv	s2,a0
  close(fd);
 292:	8526                	mv	a0,s1
 294:	00000097          	auipc	ra,0x0
 298:	13c080e7          	jalr	316(ra) # 3d0 <close>
  return r;
 29c:	64a2                	ld	s1,8(sp)
}
 29e:	854a                	mv	a0,s2
 2a0:	60e2                	ld	ra,24(sp)
 2a2:	6442                	ld	s0,16(sp)
 2a4:	6902                	ld	s2,0(sp)
 2a6:	6105                	addi	sp,sp,32
 2a8:	8082                	ret
    return -1;
 2aa:	597d                	li	s2,-1
 2ac:	bfcd                	j	29e <stat+0x36>

00000000000002ae <atoi>:

int
atoi(const char *s)
{
 2ae:	1141                	addi	sp,sp,-16
 2b0:	e422                	sd	s0,8(sp)
 2b2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2b4:	00054683          	lbu	a3,0(a0)
 2b8:	fd06879b          	addiw	a5,a3,-48
 2bc:	0ff7f793          	zext.b	a5,a5
 2c0:	4625                	li	a2,9
 2c2:	02f66863          	bltu	a2,a5,2f2 <atoi+0x44>
 2c6:	872a                	mv	a4,a0
  n = 0;
 2c8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2ca:	0705                	addi	a4,a4,1
 2cc:	0025179b          	slliw	a5,a0,0x2
 2d0:	9fa9                	addw	a5,a5,a0
 2d2:	0017979b          	slliw	a5,a5,0x1
 2d6:	9fb5                	addw	a5,a5,a3
 2d8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2dc:	00074683          	lbu	a3,0(a4)
 2e0:	fd06879b          	addiw	a5,a3,-48
 2e4:	0ff7f793          	zext.b	a5,a5
 2e8:	fef671e3          	bgeu	a2,a5,2ca <atoi+0x1c>
  return n;
}
 2ec:	6422                	ld	s0,8(sp)
 2ee:	0141                	addi	sp,sp,16
 2f0:	8082                	ret
  n = 0;
 2f2:	4501                	li	a0,0
 2f4:	bfe5                	j	2ec <atoi+0x3e>

00000000000002f6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2f6:	1141                	addi	sp,sp,-16
 2f8:	e422                	sd	s0,8(sp)
 2fa:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2fc:	02b57463          	bgeu	a0,a1,324 <memmove+0x2e>
    while(n-- > 0)
 300:	00c05f63          	blez	a2,31e <memmove+0x28>
 304:	1602                	slli	a2,a2,0x20
 306:	9201                	srli	a2,a2,0x20
 308:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 30c:	872a                	mv	a4,a0
      *dst++ = *src++;
 30e:	0585                	addi	a1,a1,1
 310:	0705                	addi	a4,a4,1
 312:	fff5c683          	lbu	a3,-1(a1)
 316:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 31a:	fef71ae3          	bne	a4,a5,30e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 31e:	6422                	ld	s0,8(sp)
 320:	0141                	addi	sp,sp,16
 322:	8082                	ret
    dst += n;
 324:	00c50733          	add	a4,a0,a2
    src += n;
 328:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 32a:	fec05ae3          	blez	a2,31e <memmove+0x28>
 32e:	fff6079b          	addiw	a5,a2,-1
 332:	1782                	slli	a5,a5,0x20
 334:	9381                	srli	a5,a5,0x20
 336:	fff7c793          	not	a5,a5
 33a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 33c:	15fd                	addi	a1,a1,-1
 33e:	177d                	addi	a4,a4,-1
 340:	0005c683          	lbu	a3,0(a1)
 344:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 348:	fee79ae3          	bne	a5,a4,33c <memmove+0x46>
 34c:	bfc9                	j	31e <memmove+0x28>

000000000000034e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 34e:	1141                	addi	sp,sp,-16
 350:	e422                	sd	s0,8(sp)
 352:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 354:	ca05                	beqz	a2,384 <memcmp+0x36>
 356:	fff6069b          	addiw	a3,a2,-1
 35a:	1682                	slli	a3,a3,0x20
 35c:	9281                	srli	a3,a3,0x20
 35e:	0685                	addi	a3,a3,1
 360:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 362:	00054783          	lbu	a5,0(a0)
 366:	0005c703          	lbu	a4,0(a1)
 36a:	00e79863          	bne	a5,a4,37a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 36e:	0505                	addi	a0,a0,1
    p2++;
 370:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 372:	fed518e3          	bne	a0,a3,362 <memcmp+0x14>
  }
  return 0;
 376:	4501                	li	a0,0
 378:	a019                	j	37e <memcmp+0x30>
      return *p1 - *p2;
 37a:	40e7853b          	subw	a0,a5,a4
}
 37e:	6422                	ld	s0,8(sp)
 380:	0141                	addi	sp,sp,16
 382:	8082                	ret
  return 0;
 384:	4501                	li	a0,0
 386:	bfe5                	j	37e <memcmp+0x30>

0000000000000388 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 388:	1141                	addi	sp,sp,-16
 38a:	e406                	sd	ra,8(sp)
 38c:	e022                	sd	s0,0(sp)
 38e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 390:	00000097          	auipc	ra,0x0
 394:	f66080e7          	jalr	-154(ra) # 2f6 <memmove>
}
 398:	60a2                	ld	ra,8(sp)
 39a:	6402                	ld	s0,0(sp)
 39c:	0141                	addi	sp,sp,16
 39e:	8082                	ret

00000000000003a0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3a0:	4885                	li	a7,1
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3a8:	4889                	li	a7,2
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3b0:	488d                	li	a7,3
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3b8:	4891                	li	a7,4
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <read>:
.global read
read:
 li a7, SYS_read
 3c0:	4895                	li	a7,5
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <write>:
.global write
write:
 li a7, SYS_write
 3c8:	48c1                	li	a7,16
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <close>:
.global close
close:
 li a7, SYS_close
 3d0:	48d5                	li	a7,21
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3d8:	4899                	li	a7,6
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3e0:	489d                	li	a7,7
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <open>:
.global open
open:
 li a7, SYS_open
 3e8:	48bd                	li	a7,15
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3f0:	48c5                	li	a7,17
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3f8:	48c9                	li	a7,18
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 400:	48a1                	li	a7,8
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <link>:
.global link
link:
 li a7, SYS_link
 408:	48cd                	li	a7,19
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 410:	48d1                	li	a7,20
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 418:	48a5                	li	a7,9
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <dup>:
.global dup
dup:
 li a7, SYS_dup
 420:	48a9                	li	a7,10
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 428:	48ad                	li	a7,11
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 430:	48b1                	li	a7,12
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 438:	48b5                	li	a7,13
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 440:	48b9                	li	a7,14
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <yield>:
.global yield
yield:
 li a7, SYS_yield
 448:	48d9                	li	a7,22
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <lock>:
.global lock
lock:
 li a7, SYS_lock
 450:	48dd                	li	a7,23
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <unlock>:
.global unlock
unlock:
 li a7, SYS_unlock
 458:	48e1                	li	a7,24
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 460:	1101                	addi	sp,sp,-32
 462:	ec06                	sd	ra,24(sp)
 464:	e822                	sd	s0,16(sp)
 466:	1000                	addi	s0,sp,32
 468:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 46c:	4605                	li	a2,1
 46e:	fef40593          	addi	a1,s0,-17
 472:	00000097          	auipc	ra,0x0
 476:	f56080e7          	jalr	-170(ra) # 3c8 <write>
}
 47a:	60e2                	ld	ra,24(sp)
 47c:	6442                	ld	s0,16(sp)
 47e:	6105                	addi	sp,sp,32
 480:	8082                	ret

0000000000000482 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 482:	7139                	addi	sp,sp,-64
 484:	fc06                	sd	ra,56(sp)
 486:	f822                	sd	s0,48(sp)
 488:	f426                	sd	s1,40(sp)
 48a:	0080                	addi	s0,sp,64
 48c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 48e:	c299                	beqz	a3,494 <printint+0x12>
 490:	0805cb63          	bltz	a1,526 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 494:	2581                	sext.w	a1,a1
  neg = 0;
 496:	4881                	li	a7,0
 498:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 49c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 49e:	2601                	sext.w	a2,a2
 4a0:	00000517          	auipc	a0,0x0
 4a4:	66850513          	addi	a0,a0,1640 # b08 <digits>
 4a8:	883a                	mv	a6,a4
 4aa:	2705                	addiw	a4,a4,1
 4ac:	02c5f7bb          	remuw	a5,a1,a2
 4b0:	1782                	slli	a5,a5,0x20
 4b2:	9381                	srli	a5,a5,0x20
 4b4:	97aa                	add	a5,a5,a0
 4b6:	0007c783          	lbu	a5,0(a5)
 4ba:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4be:	0005879b          	sext.w	a5,a1
 4c2:	02c5d5bb          	divuw	a1,a1,a2
 4c6:	0685                	addi	a3,a3,1
 4c8:	fec7f0e3          	bgeu	a5,a2,4a8 <printint+0x26>
  if(neg)
 4cc:	00088c63          	beqz	a7,4e4 <printint+0x62>
    buf[i++] = '-';
 4d0:	fd070793          	addi	a5,a4,-48
 4d4:	00878733          	add	a4,a5,s0
 4d8:	02d00793          	li	a5,45
 4dc:	fef70823          	sb	a5,-16(a4)
 4e0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4e4:	02e05c63          	blez	a4,51c <printint+0x9a>
 4e8:	f04a                	sd	s2,32(sp)
 4ea:	ec4e                	sd	s3,24(sp)
 4ec:	fc040793          	addi	a5,s0,-64
 4f0:	00e78933          	add	s2,a5,a4
 4f4:	fff78993          	addi	s3,a5,-1
 4f8:	99ba                	add	s3,s3,a4
 4fa:	377d                	addiw	a4,a4,-1
 4fc:	1702                	slli	a4,a4,0x20
 4fe:	9301                	srli	a4,a4,0x20
 500:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 504:	fff94583          	lbu	a1,-1(s2)
 508:	8526                	mv	a0,s1
 50a:	00000097          	auipc	ra,0x0
 50e:	f56080e7          	jalr	-170(ra) # 460 <putc>
  while(--i >= 0)
 512:	197d                	addi	s2,s2,-1
 514:	ff3918e3          	bne	s2,s3,504 <printint+0x82>
 518:	7902                	ld	s2,32(sp)
 51a:	69e2                	ld	s3,24(sp)
}
 51c:	70e2                	ld	ra,56(sp)
 51e:	7442                	ld	s0,48(sp)
 520:	74a2                	ld	s1,40(sp)
 522:	6121                	addi	sp,sp,64
 524:	8082                	ret
    x = -xx;
 526:	40b005bb          	negw	a1,a1
    neg = 1;
 52a:	4885                	li	a7,1
    x = -xx;
 52c:	b7b5                	j	498 <printint+0x16>

000000000000052e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 52e:	715d                	addi	sp,sp,-80
 530:	e486                	sd	ra,72(sp)
 532:	e0a2                	sd	s0,64(sp)
 534:	f84a                	sd	s2,48(sp)
 536:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 538:	0005c903          	lbu	s2,0(a1)
 53c:	1a090a63          	beqz	s2,6f0 <vprintf+0x1c2>
 540:	fc26                	sd	s1,56(sp)
 542:	f44e                	sd	s3,40(sp)
 544:	f052                	sd	s4,32(sp)
 546:	ec56                	sd	s5,24(sp)
 548:	e85a                	sd	s6,16(sp)
 54a:	e45e                	sd	s7,8(sp)
 54c:	8aaa                	mv	s5,a0
 54e:	8bb2                	mv	s7,a2
 550:	00158493          	addi	s1,a1,1
  state = 0;
 554:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 556:	02500a13          	li	s4,37
 55a:	4b55                	li	s6,21
 55c:	a839                	j	57a <vprintf+0x4c>
        putc(fd, c);
 55e:	85ca                	mv	a1,s2
 560:	8556                	mv	a0,s5
 562:	00000097          	auipc	ra,0x0
 566:	efe080e7          	jalr	-258(ra) # 460 <putc>
 56a:	a019                	j	570 <vprintf+0x42>
    } else if(state == '%'){
 56c:	01498d63          	beq	s3,s4,586 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 570:	0485                	addi	s1,s1,1
 572:	fff4c903          	lbu	s2,-1(s1)
 576:	16090763          	beqz	s2,6e4 <vprintf+0x1b6>
    if(state == 0){
 57a:	fe0999e3          	bnez	s3,56c <vprintf+0x3e>
      if(c == '%'){
 57e:	ff4910e3          	bne	s2,s4,55e <vprintf+0x30>
        state = '%';
 582:	89d2                	mv	s3,s4
 584:	b7f5                	j	570 <vprintf+0x42>
      if(c == 'd'){
 586:	13490463          	beq	s2,s4,6ae <vprintf+0x180>
 58a:	f9d9079b          	addiw	a5,s2,-99
 58e:	0ff7f793          	zext.b	a5,a5
 592:	12fb6763          	bltu	s6,a5,6c0 <vprintf+0x192>
 596:	f9d9079b          	addiw	a5,s2,-99
 59a:	0ff7f713          	zext.b	a4,a5
 59e:	12eb6163          	bltu	s6,a4,6c0 <vprintf+0x192>
 5a2:	00271793          	slli	a5,a4,0x2
 5a6:	00000717          	auipc	a4,0x0
 5aa:	50a70713          	addi	a4,a4,1290 # ab0 <malloc+0x19a>
 5ae:	97ba                	add	a5,a5,a4
 5b0:	439c                	lw	a5,0(a5)
 5b2:	97ba                	add	a5,a5,a4
 5b4:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5b6:	008b8913          	addi	s2,s7,8
 5ba:	4685                	li	a3,1
 5bc:	4629                	li	a2,10
 5be:	000ba583          	lw	a1,0(s7)
 5c2:	8556                	mv	a0,s5
 5c4:	00000097          	auipc	ra,0x0
 5c8:	ebe080e7          	jalr	-322(ra) # 482 <printint>
 5cc:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5ce:	4981                	li	s3,0
 5d0:	b745                	j	570 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d2:	008b8913          	addi	s2,s7,8
 5d6:	4681                	li	a3,0
 5d8:	4629                	li	a2,10
 5da:	000ba583          	lw	a1,0(s7)
 5de:	8556                	mv	a0,s5
 5e0:	00000097          	auipc	ra,0x0
 5e4:	ea2080e7          	jalr	-350(ra) # 482 <printint>
 5e8:	8bca                	mv	s7,s2
      state = 0;
 5ea:	4981                	li	s3,0
 5ec:	b751                	j	570 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5ee:	008b8913          	addi	s2,s7,8
 5f2:	4681                	li	a3,0
 5f4:	4641                	li	a2,16
 5f6:	000ba583          	lw	a1,0(s7)
 5fa:	8556                	mv	a0,s5
 5fc:	00000097          	auipc	ra,0x0
 600:	e86080e7          	jalr	-378(ra) # 482 <printint>
 604:	8bca                	mv	s7,s2
      state = 0;
 606:	4981                	li	s3,0
 608:	b7a5                	j	570 <vprintf+0x42>
 60a:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 60c:	008b8c13          	addi	s8,s7,8
 610:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 614:	03000593          	li	a1,48
 618:	8556                	mv	a0,s5
 61a:	00000097          	auipc	ra,0x0
 61e:	e46080e7          	jalr	-442(ra) # 460 <putc>
  putc(fd, 'x');
 622:	07800593          	li	a1,120
 626:	8556                	mv	a0,s5
 628:	00000097          	auipc	ra,0x0
 62c:	e38080e7          	jalr	-456(ra) # 460 <putc>
 630:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 632:	00000b97          	auipc	s7,0x0
 636:	4d6b8b93          	addi	s7,s7,1238 # b08 <digits>
 63a:	03c9d793          	srli	a5,s3,0x3c
 63e:	97de                	add	a5,a5,s7
 640:	0007c583          	lbu	a1,0(a5)
 644:	8556                	mv	a0,s5
 646:	00000097          	auipc	ra,0x0
 64a:	e1a080e7          	jalr	-486(ra) # 460 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 64e:	0992                	slli	s3,s3,0x4
 650:	397d                	addiw	s2,s2,-1
 652:	fe0914e3          	bnez	s2,63a <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 656:	8be2                	mv	s7,s8
      state = 0;
 658:	4981                	li	s3,0
 65a:	6c02                	ld	s8,0(sp)
 65c:	bf11                	j	570 <vprintf+0x42>
        s = va_arg(ap, char*);
 65e:	008b8993          	addi	s3,s7,8
 662:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 666:	02090163          	beqz	s2,688 <vprintf+0x15a>
        while(*s != 0){
 66a:	00094583          	lbu	a1,0(s2)
 66e:	c9a5                	beqz	a1,6de <vprintf+0x1b0>
          putc(fd, *s);
 670:	8556                	mv	a0,s5
 672:	00000097          	auipc	ra,0x0
 676:	dee080e7          	jalr	-530(ra) # 460 <putc>
          s++;
 67a:	0905                	addi	s2,s2,1
        while(*s != 0){
 67c:	00094583          	lbu	a1,0(s2)
 680:	f9e5                	bnez	a1,670 <vprintf+0x142>
        s = va_arg(ap, char*);
 682:	8bce                	mv	s7,s3
      state = 0;
 684:	4981                	li	s3,0
 686:	b5ed                	j	570 <vprintf+0x42>
          s = "(null)";
 688:	00000917          	auipc	s2,0x0
 68c:	42090913          	addi	s2,s2,1056 # aa8 <malloc+0x192>
        while(*s != 0){
 690:	02800593          	li	a1,40
 694:	bff1                	j	670 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 696:	008b8913          	addi	s2,s7,8
 69a:	000bc583          	lbu	a1,0(s7)
 69e:	8556                	mv	a0,s5
 6a0:	00000097          	auipc	ra,0x0
 6a4:	dc0080e7          	jalr	-576(ra) # 460 <putc>
 6a8:	8bca                	mv	s7,s2
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	b5d1                	j	570 <vprintf+0x42>
        putc(fd, c);
 6ae:	02500593          	li	a1,37
 6b2:	8556                	mv	a0,s5
 6b4:	00000097          	auipc	ra,0x0
 6b8:	dac080e7          	jalr	-596(ra) # 460 <putc>
      state = 0;
 6bc:	4981                	li	s3,0
 6be:	bd4d                	j	570 <vprintf+0x42>
        putc(fd, '%');
 6c0:	02500593          	li	a1,37
 6c4:	8556                	mv	a0,s5
 6c6:	00000097          	auipc	ra,0x0
 6ca:	d9a080e7          	jalr	-614(ra) # 460 <putc>
        putc(fd, c);
 6ce:	85ca                	mv	a1,s2
 6d0:	8556                	mv	a0,s5
 6d2:	00000097          	auipc	ra,0x0
 6d6:	d8e080e7          	jalr	-626(ra) # 460 <putc>
      state = 0;
 6da:	4981                	li	s3,0
 6dc:	bd51                	j	570 <vprintf+0x42>
        s = va_arg(ap, char*);
 6de:	8bce                	mv	s7,s3
      state = 0;
 6e0:	4981                	li	s3,0
 6e2:	b579                	j	570 <vprintf+0x42>
 6e4:	74e2                	ld	s1,56(sp)
 6e6:	79a2                	ld	s3,40(sp)
 6e8:	7a02                	ld	s4,32(sp)
 6ea:	6ae2                	ld	s5,24(sp)
 6ec:	6b42                	ld	s6,16(sp)
 6ee:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6f0:	60a6                	ld	ra,72(sp)
 6f2:	6406                	ld	s0,64(sp)
 6f4:	7942                	ld	s2,48(sp)
 6f6:	6161                	addi	sp,sp,80
 6f8:	8082                	ret

00000000000006fa <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6fa:	715d                	addi	sp,sp,-80
 6fc:	ec06                	sd	ra,24(sp)
 6fe:	e822                	sd	s0,16(sp)
 700:	1000                	addi	s0,sp,32
 702:	e010                	sd	a2,0(s0)
 704:	e414                	sd	a3,8(s0)
 706:	e818                	sd	a4,16(s0)
 708:	ec1c                	sd	a5,24(s0)
 70a:	03043023          	sd	a6,32(s0)
 70e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 712:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 716:	8622                	mv	a2,s0
 718:	00000097          	auipc	ra,0x0
 71c:	e16080e7          	jalr	-490(ra) # 52e <vprintf>
}
 720:	60e2                	ld	ra,24(sp)
 722:	6442                	ld	s0,16(sp)
 724:	6161                	addi	sp,sp,80
 726:	8082                	ret

0000000000000728 <printf>:

void
printf(const char *fmt, ...)
{
 728:	7159                	addi	sp,sp,-112
 72a:	f406                	sd	ra,40(sp)
 72c:	f022                	sd	s0,32(sp)
 72e:	ec26                	sd	s1,24(sp)
 730:	1800                	addi	s0,sp,48
 732:	84aa                	mv	s1,a0
 734:	e40c                	sd	a1,8(s0)
 736:	e810                	sd	a2,16(s0)
 738:	ec14                	sd	a3,24(s0)
 73a:	f018                	sd	a4,32(s0)
 73c:	f41c                	sd	a5,40(s0)
 73e:	03043823          	sd	a6,48(s0)
 742:	03143c23          	sd	a7,56(s0)
  va_list ap;

  lock();
 746:	00000097          	auipc	ra,0x0
 74a:	d0a080e7          	jalr	-758(ra) # 450 <lock>
  va_start(ap, fmt);
 74e:	00840613          	addi	a2,s0,8
 752:	fcc43c23          	sd	a2,-40(s0)
  vprintf(1, fmt, ap);
 756:	85a6                	mv	a1,s1
 758:	4505                	li	a0,1
 75a:	00000097          	auipc	ra,0x0
 75e:	dd4080e7          	jalr	-556(ra) # 52e <vprintf>
  unlock();
 762:	00000097          	auipc	ra,0x0
 766:	cf6080e7          	jalr	-778(ra) # 458 <unlock>
}
 76a:	70a2                	ld	ra,40(sp)
 76c:	7402                	ld	s0,32(sp)
 76e:	64e2                	ld	s1,24(sp)
 770:	6165                	addi	sp,sp,112
 772:	8082                	ret

0000000000000774 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 774:	7179                	addi	sp,sp,-48
 776:	f422                	sd	s0,40(sp)
 778:	1800                	addi	s0,sp,48
 77a:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 77e:	fd843783          	ld	a5,-40(s0)
 782:	17c1                	addi	a5,a5,-16
 784:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 788:	00001797          	auipc	a5,0x1
 78c:	e8878793          	addi	a5,a5,-376 # 1610 <freep>
 790:	639c                	ld	a5,0(a5)
 792:	fef43423          	sd	a5,-24(s0)
 796:	a815                	j	7ca <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 798:	fe843783          	ld	a5,-24(s0)
 79c:	639c                	ld	a5,0(a5)
 79e:	fe843703          	ld	a4,-24(s0)
 7a2:	00f76f63          	bltu	a4,a5,7c0 <free+0x4c>
 7a6:	fe043703          	ld	a4,-32(s0)
 7aa:	fe843783          	ld	a5,-24(s0)
 7ae:	02e7eb63          	bltu	a5,a4,7e4 <free+0x70>
 7b2:	fe843783          	ld	a5,-24(s0)
 7b6:	639c                	ld	a5,0(a5)
 7b8:	fe043703          	ld	a4,-32(s0)
 7bc:	02f76463          	bltu	a4,a5,7e4 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c0:	fe843783          	ld	a5,-24(s0)
 7c4:	639c                	ld	a5,0(a5)
 7c6:	fef43423          	sd	a5,-24(s0)
 7ca:	fe043703          	ld	a4,-32(s0)
 7ce:	fe843783          	ld	a5,-24(s0)
 7d2:	fce7f3e3          	bgeu	a5,a4,798 <free+0x24>
 7d6:	fe843783          	ld	a5,-24(s0)
 7da:	639c                	ld	a5,0(a5)
 7dc:	fe043703          	ld	a4,-32(s0)
 7e0:	faf77ce3          	bgeu	a4,a5,798 <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7e4:	fe043783          	ld	a5,-32(s0)
 7e8:	479c                	lw	a5,8(a5)
 7ea:	1782                	slli	a5,a5,0x20
 7ec:	9381                	srli	a5,a5,0x20
 7ee:	0792                	slli	a5,a5,0x4
 7f0:	fe043703          	ld	a4,-32(s0)
 7f4:	973e                	add	a4,a4,a5
 7f6:	fe843783          	ld	a5,-24(s0)
 7fa:	639c                	ld	a5,0(a5)
 7fc:	02f71763          	bne	a4,a5,82a <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 800:	fe043783          	ld	a5,-32(s0)
 804:	4798                	lw	a4,8(a5)
 806:	fe843783          	ld	a5,-24(s0)
 80a:	639c                	ld	a5,0(a5)
 80c:	479c                	lw	a5,8(a5)
 80e:	9fb9                	addw	a5,a5,a4
 810:	0007871b          	sext.w	a4,a5
 814:	fe043783          	ld	a5,-32(s0)
 818:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 81a:	fe843783          	ld	a5,-24(s0)
 81e:	639c                	ld	a5,0(a5)
 820:	6398                	ld	a4,0(a5)
 822:	fe043783          	ld	a5,-32(s0)
 826:	e398                	sd	a4,0(a5)
 828:	a039                	j	836 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 82a:	fe843783          	ld	a5,-24(s0)
 82e:	6398                	ld	a4,0(a5)
 830:	fe043783          	ld	a5,-32(s0)
 834:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 836:	fe843783          	ld	a5,-24(s0)
 83a:	479c                	lw	a5,8(a5)
 83c:	1782                	slli	a5,a5,0x20
 83e:	9381                	srli	a5,a5,0x20
 840:	0792                	slli	a5,a5,0x4
 842:	fe843703          	ld	a4,-24(s0)
 846:	97ba                	add	a5,a5,a4
 848:	fe043703          	ld	a4,-32(s0)
 84c:	02f71563          	bne	a4,a5,876 <free+0x102>
    p->s.size += bp->s.size;
 850:	fe843783          	ld	a5,-24(s0)
 854:	4798                	lw	a4,8(a5)
 856:	fe043783          	ld	a5,-32(s0)
 85a:	479c                	lw	a5,8(a5)
 85c:	9fb9                	addw	a5,a5,a4
 85e:	0007871b          	sext.w	a4,a5
 862:	fe843783          	ld	a5,-24(s0)
 866:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 868:	fe043783          	ld	a5,-32(s0)
 86c:	6398                	ld	a4,0(a5)
 86e:	fe843783          	ld	a5,-24(s0)
 872:	e398                	sd	a4,0(a5)
 874:	a031                	j	880 <free+0x10c>
  } else
    p->s.ptr = bp;
 876:	fe843783          	ld	a5,-24(s0)
 87a:	fe043703          	ld	a4,-32(s0)
 87e:	e398                	sd	a4,0(a5)
  freep = p;
 880:	00001797          	auipc	a5,0x1
 884:	d9078793          	addi	a5,a5,-624 # 1610 <freep>
 888:	fe843703          	ld	a4,-24(s0)
 88c:	e398                	sd	a4,0(a5)
}
 88e:	0001                	nop
 890:	7422                	ld	s0,40(sp)
 892:	6145                	addi	sp,sp,48
 894:	8082                	ret

0000000000000896 <morecore>:

static Header*
morecore(uint nu)
{
 896:	7179                	addi	sp,sp,-48
 898:	f406                	sd	ra,40(sp)
 89a:	f022                	sd	s0,32(sp)
 89c:	1800                	addi	s0,sp,48
 89e:	87aa                	mv	a5,a0
 8a0:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 8a4:	fdc42783          	lw	a5,-36(s0)
 8a8:	0007871b          	sext.w	a4,a5
 8ac:	6785                	lui	a5,0x1
 8ae:	00f77563          	bgeu	a4,a5,8b8 <morecore+0x22>
    nu = 4096;
 8b2:	6785                	lui	a5,0x1
 8b4:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 8b8:	fdc42783          	lw	a5,-36(s0)
 8bc:	0047979b          	slliw	a5,a5,0x4
 8c0:	2781                	sext.w	a5,a5
 8c2:	2781                	sext.w	a5,a5
 8c4:	853e                	mv	a0,a5
 8c6:	00000097          	auipc	ra,0x0
 8ca:	b6a080e7          	jalr	-1174(ra) # 430 <sbrk>
 8ce:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 8d2:	fe843703          	ld	a4,-24(s0)
 8d6:	57fd                	li	a5,-1
 8d8:	00f71463          	bne	a4,a5,8e0 <morecore+0x4a>
    return 0;
 8dc:	4781                	li	a5,0
 8de:	a03d                	j	90c <morecore+0x76>
  hp = (Header*)p;
 8e0:	fe843783          	ld	a5,-24(s0)
 8e4:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 8e8:	fe043783          	ld	a5,-32(s0)
 8ec:	fdc42703          	lw	a4,-36(s0)
 8f0:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 8f2:	fe043783          	ld	a5,-32(s0)
 8f6:	07c1                	addi	a5,a5,16 # 1010 <digits+0x508>
 8f8:	853e                	mv	a0,a5
 8fa:	00000097          	auipc	ra,0x0
 8fe:	e7a080e7          	jalr	-390(ra) # 774 <free>
  return freep;
 902:	00001797          	auipc	a5,0x1
 906:	d0e78793          	addi	a5,a5,-754 # 1610 <freep>
 90a:	639c                	ld	a5,0(a5)
}
 90c:	853e                	mv	a0,a5
 90e:	70a2                	ld	ra,40(sp)
 910:	7402                	ld	s0,32(sp)
 912:	6145                	addi	sp,sp,48
 914:	8082                	ret

0000000000000916 <malloc>:

void*
malloc(uint nbytes)
{
 916:	7139                	addi	sp,sp,-64
 918:	fc06                	sd	ra,56(sp)
 91a:	f822                	sd	s0,48(sp)
 91c:	0080                	addi	s0,sp,64
 91e:	87aa                	mv	a5,a0
 920:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 924:	fcc46783          	lwu	a5,-52(s0)
 928:	07bd                	addi	a5,a5,15
 92a:	8391                	srli	a5,a5,0x4
 92c:	2781                	sext.w	a5,a5
 92e:	2785                	addiw	a5,a5,1
 930:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 934:	00001797          	auipc	a5,0x1
 938:	cdc78793          	addi	a5,a5,-804 # 1610 <freep>
 93c:	639c                	ld	a5,0(a5)
 93e:	fef43023          	sd	a5,-32(s0)
 942:	fe043783          	ld	a5,-32(s0)
 946:	ef95                	bnez	a5,982 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 948:	00001797          	auipc	a5,0x1
 94c:	cb878793          	addi	a5,a5,-840 # 1600 <base>
 950:	fef43023          	sd	a5,-32(s0)
 954:	00001797          	auipc	a5,0x1
 958:	cbc78793          	addi	a5,a5,-836 # 1610 <freep>
 95c:	fe043703          	ld	a4,-32(s0)
 960:	e398                	sd	a4,0(a5)
 962:	00001797          	auipc	a5,0x1
 966:	cae78793          	addi	a5,a5,-850 # 1610 <freep>
 96a:	6398                	ld	a4,0(a5)
 96c:	00001797          	auipc	a5,0x1
 970:	c9478793          	addi	a5,a5,-876 # 1600 <base>
 974:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 976:	00001797          	auipc	a5,0x1
 97a:	c8a78793          	addi	a5,a5,-886 # 1600 <base>
 97e:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 982:	fe043783          	ld	a5,-32(s0)
 986:	639c                	ld	a5,0(a5)
 988:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 98c:	fe843783          	ld	a5,-24(s0)
 990:	4798                	lw	a4,8(a5)
 992:	fdc42783          	lw	a5,-36(s0)
 996:	2781                	sext.w	a5,a5
 998:	06f76763          	bltu	a4,a5,a06 <malloc+0xf0>
      if(p->s.size == nunits)
 99c:	fe843783          	ld	a5,-24(s0)
 9a0:	4798                	lw	a4,8(a5)
 9a2:	fdc42783          	lw	a5,-36(s0)
 9a6:	2781                	sext.w	a5,a5
 9a8:	00e79963          	bne	a5,a4,9ba <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 9ac:	fe843783          	ld	a5,-24(s0)
 9b0:	6398                	ld	a4,0(a5)
 9b2:	fe043783          	ld	a5,-32(s0)
 9b6:	e398                	sd	a4,0(a5)
 9b8:	a825                	j	9f0 <malloc+0xda>
      else {
        p->s.size -= nunits;
 9ba:	fe843783          	ld	a5,-24(s0)
 9be:	479c                	lw	a5,8(a5)
 9c0:	fdc42703          	lw	a4,-36(s0)
 9c4:	9f99                	subw	a5,a5,a4
 9c6:	0007871b          	sext.w	a4,a5
 9ca:	fe843783          	ld	a5,-24(s0)
 9ce:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9d0:	fe843783          	ld	a5,-24(s0)
 9d4:	479c                	lw	a5,8(a5)
 9d6:	1782                	slli	a5,a5,0x20
 9d8:	9381                	srli	a5,a5,0x20
 9da:	0792                	slli	a5,a5,0x4
 9dc:	fe843703          	ld	a4,-24(s0)
 9e0:	97ba                	add	a5,a5,a4
 9e2:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 9e6:	fe843783          	ld	a5,-24(s0)
 9ea:	fdc42703          	lw	a4,-36(s0)
 9ee:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 9f0:	00001797          	auipc	a5,0x1
 9f4:	c2078793          	addi	a5,a5,-992 # 1610 <freep>
 9f8:	fe043703          	ld	a4,-32(s0)
 9fc:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 9fe:	fe843783          	ld	a5,-24(s0)
 a02:	07c1                	addi	a5,a5,16
 a04:	a091                	j	a48 <malloc+0x132>
    }
    if(p == freep)
 a06:	00001797          	auipc	a5,0x1
 a0a:	c0a78793          	addi	a5,a5,-1014 # 1610 <freep>
 a0e:	639c                	ld	a5,0(a5)
 a10:	fe843703          	ld	a4,-24(s0)
 a14:	02f71063          	bne	a4,a5,a34 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 a18:	fdc42783          	lw	a5,-36(s0)
 a1c:	853e                	mv	a0,a5
 a1e:	00000097          	auipc	ra,0x0
 a22:	e78080e7          	jalr	-392(ra) # 896 <morecore>
 a26:	fea43423          	sd	a0,-24(s0)
 a2a:	fe843783          	ld	a5,-24(s0)
 a2e:	e399                	bnez	a5,a34 <malloc+0x11e>
        return 0;
 a30:	4781                	li	a5,0
 a32:	a819                	j	a48 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a34:	fe843783          	ld	a5,-24(s0)
 a38:	fef43023          	sd	a5,-32(s0)
 a3c:	fe843783          	ld	a5,-24(s0)
 a40:	639c                	ld	a5,0(a5)
 a42:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 a46:	b799                	j	98c <malloc+0x76>
  }
}
 a48:	853e                	mv	a0,a5
 a4a:	70e2                	ld	ra,56(sp)
 a4c:	7442                	ld	s0,48(sp)
 a4e:	6121                	addi	sp,sp,64
 a50:	8082                	ret
