;David Flores Barbero
;Francisco Blázquez Matías

	.data
;Espacio de datos

m:			.word	32768
a:			.word	1103515245
c:			.word	12345
semilla:		.word	2
nmax:			.word	25
intentos:		.word	0
ant:			.word	0
contador:		.word	1
contVector:		.word	0


	.data	0x00003000
			.global	vectoraleatorio
vectoraleatorio:	.space	nmax*4
			
		.text
;Espacio de codigo
		.global main

;------------------------------------------------------------
main:
;------------------------------------------------------------
	
	lw	r4,semilla		;tiene el valor anterior
	lw	r2,a
	lw	r3,c	

	multu	r8,r2,r4		;r8=a*ant	Formula aleatorio (1/5)

	lw	r5,contador		;cargamos el contador en r5
	lw	r1,m			;carga valores en los registros

	addu	r8,r8,r3		;r8=a*ant+c	Formula aleatorio(2/5)

	lw	r9,intentos		;cargamos el numero de intentos

	divu	r4,r8,r1		;r4=r8-r1*(r8/r1)	(ant*a+c)mod m  Formula aleatorio(3/5)

	lw	r6,nmax			;carga el numero maximo del vector en r6
	
	addi	r13,r0,0		;indice para recorrer el vector i=0
	slli	r22,r6,2		;nmax *4

	multu	r4,r4,r1		;Formula aleatorio(4/5)

;------------------------------------------------------------
iniciaVector:
;------------------------------------------------------------
			
	sw	vectoraleatorio(r13),0	;V[i]=0
	sub	r11,r22,r13		;r11=nmax*4-i		
	addi	r13,r13,4		;i++
	bnez	r11,iniciaVector	;if(r11!=0)--> iniciaVector

;------------------------------------------------------------
Loop:
;------------------------------------------------------------

	subu	r4,r8,r4		;Formula aleatorio (5/5)

	divu	r18,r4,r6		;resultado%nmax	(obtiene la posicion (1/3))

	multu	r8,r2,r4		;r8=a*ant	Formula aleatorio (1/5)
	
	multu	r18,r18,r6		;resultado%nmax	(obtiene la posicion (2/3))

	addu	r8,r8,r3		;r8=a*ant+c	Formula aleatorio (2/5)

	subu	r18,r4,r18		;resultado%nmax	(obtiene la posicion (3/3))

	divu	r4,r8,r1		;r4=r8-r1*(r8/r1)	(ant*a+c)mod m (Formula aleatorio (3/5))
		
	slli	r14,r18,2		;resultado=resultado*4 desplaza los bits 2 hacia la izquierda (para multiplicar por 4)
	addi	r9,r9,1			;intentos=intentos+1
	
;------------------------------------------------------------
;A partir de aqui es ComprobarVector:
;------------------------------------------------------------
	
	lw	r17,vectoraleatorio(r14)	;if(V[resultado]==0)	
	multu	r4,r4,r1			;Formula aleatorio(4/5)
	bnez	r17,Loop			;colocaNum si hay un 0 en esa pos
	
;------------------------------------------------------------
;A partir de aqui es colocarNum:
;------------------------------------------------------------

	sw	vectoraleatorio(r14),r5		;V[resultado]=contador
	sub	r7,r6,r5			;r7=nmax-(contador)
	addi	r5,r5,1				;contador=contador+1
	bnez	r7,Loop				;if(r7!=0)--> loop	
	trap	0;				;else acaba

