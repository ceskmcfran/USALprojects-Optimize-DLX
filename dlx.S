;David Flores Barbero 70907575R
;Francisco Blázquez Matías 70919093L


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

	
	lw	r6,nmax		;carga el numero maximo del vector en r6
	lw	r5,contador	;cargamos el contador en r5
	lw	r9,intentos	;cargamos el numero de intentos
	lw	r10,contVector	;cargamos el contador del vector

	addi	r13,r0,0	;indice para recorrer el vector i=0


	lw	r1,m			;carga valores en los registros
	lw	r2,a
	lw	r3,c
	lw	r4,semilla			;tiene el valor anterior



;------------------------------------------------------------
iniciaVector:
;------------------------------------------------------------
			
	sw	vectoraleatorio(r13),0	;V[i]=0
	sub	r11,r6,r10		;r11=nmax-contVector
	beqz	r11,Loop		;if(r11==0)--> Loop
	addi	r10,r10,1		;contVector=contVector+1
	addi	r13,r13,4		;i++
	j	iniciaVector		;vuelve al bucle

;------------------------------------------------------------
Loop:
;------------------------------------------------------------

	
	multu	r8,r2,r4		;r8=a*ant
	addu	r8,r8,r3		;r8=a*ant+c
	divu	r4,r8,r1		;r4=r8-r1*(r8/r1)	(ant*a+c)mod m
	multu	r4,r4,r1	
	subu	r4,r8,r4

	
	
	addi	r9,r9,1			;intentos=intentos+1
		
	
	divu	r18,r4,r6		;resultado%nmax
	multu	r18,r18,r6	
	subu	r18,r4,r18	

	;sw	PrintfValue,r18
	;addi	r22,r0,PrintfPar
	;trap 5

	
	addi	r15,r0,4		;r15=4
	multu	r14,r18,r15		;resultado=resultado*4
	
	

	j comprobarVector
	
;------------------------------------------------------------
seguirEjecucion:
;------------------------------------------------------------
	
	subi	r19,r5,1		;aux=contador-1	
	sub	r7,r6,r19		;r7=nmax-(aux)
	beqz	r7,acabar		;if(r7==0)--> acabar	
	j	Loop			;sigue en el bucle

;------------------------------------------------------------
comprobarVector:
;------------------------------------------------------------
	
	lw	r17,vectoraleatorio(r14)	;if(V[resultado]==0)
	beqz	r17,colocarNum			;V[resultado]=contador
	j 	seguirEjecucion			;continua ejecucion

;------------------------------------------------------------
colocarNum:
;------------------------------------------------------------

	sw	vectoraleatorio(r14),r5	;V[resultado]=contador
	addi	r5,r5,1			;contador=contador+1
	j	seguirEjecucion		;continua ejecucion

;------------------------------------------------------------
acabar:
;------------------------------------------------------------	



	trap 0; Finaliza la ejecución del programa
