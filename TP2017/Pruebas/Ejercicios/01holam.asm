;******************************************************
; holam.asm
; Ejercicio para imprimir "Hola mundo!!" por pantalla
;
;******************************************************
.model small
.stack
.data

mensaje	db  "Hola mundo!!$"        ;el string debe finalizar con $

.code
start:

	mov	ax,@data		;ds <-- dir del segmento de datos
	mov	ds,ax

	mov	ax,@stack	;no usamos el stack, en caso de usarlo deberiamos hacer esto
	mov	ss,ax

	mov	dx,offset mensaje ;dx <-- offset de 'mensaje' dento del segmento de datos
         ;lea     dx,mensaje        ;funciona igual que usar offset

	mov	ah,9		; servicio 9 para int 21 -- Impmrimir cadena en pantalla
	int	21h

	mov	ax,4c00h		; retornar al DOS
	int	21h
end start