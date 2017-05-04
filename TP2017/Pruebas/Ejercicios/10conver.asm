;******************************************************************
; convert.asm
; Ejercicio que transforma un nro en binario a su representacion en
; en ASCII mediante divisiones sucesivas y lo imprime en pantalla
;
;*******************************************************************

segment pila stack
   resb 1024
segment datos data

	num		dw  31
	diez		dw  10
	cociente	db  0
	resto		db  0
	j_anio      dw 1
	cadena	times 4	db  '0'
            db'$' ;para agregar el fin de string para imprimir por pantalla

segment codigo code
..start:
	mov	ax,datos	   ;ds <-- dir del segmento de datos
	mov	ds,ax
	mov	ax,pila		;ss <-- dir del segmento de pila
	mov   ss,ax

	mov	word[j_anio],150
	mov word[num],1900
	mov si,[j_anio]
	add word[num],si
	
	mov  dx,0	   ;pongo en 0 dx para la dupla dx:ax
	mov  ax,[num]  ;copio el nro en AX para divisiones sucesivas
	mov  si,3	   ;'si' apunta al ultimo byte de la cadena

otraDiv:
	div  word[diez]      ;dx:ax div 10 ==> dx <- resto & ax <- cociente

	add  dx,48		      ;convierto a Ascii el resto
	mov  [cadena+si],dl	;lo pongo en la posicion anterior
	sub  si,1		      ;posiciono SI en el caracter anterior en la cadena
	
	cmp  ax,[diez]	;IF    cociente < 10
	jl   finDiv		;THEN  fin division
	
	mov  dx,0		;pongo en 0 DX para la dupla DX:AX
	jmp  otraDiv
finDiv:
	add  ax,48
	mov  [cadena+si],al

	lea  dx,[cadena]
	mov  ah,9
	int  21h

	mov  ax,4c00h	;retorno al DOS
	int  21h