IDEAL 
MODEL small
STACK 100h
DATASEG


x dw 10
y dw 10


x_prev dw ? ; Holds prev x value to know where to print next tile in print_tile
y_prev dw ?
y_tracker dw 15
color db 60d


line_len dw 20		; square side sizes (or rect)
col_len dw 20


col1 db 1,0,1,0,0,0,2,0			; This is the board. Every array represents a different column
col2 db 0,1,0,0,0,2,0,2
col3 db 1,0,1,0,0,0,2,0
col4 db 0,1,0,0,0,2,0,2
col5 db 1,0,1,0,0,0,2,0
col6 db 0,1,0,0,0,2,0,2
col7 db 1,0,1,0,0,0,2,0
col8 db 0,1,0,0,0,2,0,2


col_number dw 0
row_number dw 0


col_num_prev_click dw 0
row_num_prev_click dw 0


current_turn db 1		; 1 for player 1, 2 for player 2


right_or_left db 0  ; Right - 1, Left - 0. Used to save the direction in whicj player went


value_to_check dw 0	; Used in the check_column proc


eat db 0


p1_score db 0
p2_score db 0


col12 db 1,0,1,0,0,0,2,0		; Board copy for intitialization
col22 db 0,1,0,0,0,2,0,2
col32 db 1,0,1,0,0,0,2,0
col42 db 0,1,0,0,0,2,0,2
col52 db 1,0,1,0,0,0,2,0
col62 db 0,1,0,0,0,2,0,2
col72 db 1,0,1,0,0,0,2,0
col82 db 0,1,0,0,0,2,0,2


p1_queens_num db 0
p2_queens_num db 0


queen_mov db 0 ; 0 for false 1 for true


; Messages for printing in graphic mode
start_message1 db 'CHECKERS by Ido Levy$'
start_message2 db 'Click anywhere on the screen to begin$'
current_turn_message db 'Turn:$'
p1_message db 'Player 1$'
p2_message db 'Player 2$'
restart_message db 'Restart$'
p1_won db 'Player 1 won!$'
p2_won db 'Player 2 won!$'


CODESEG
proc print_line_fullscreen

	; This proc prints a horizontal line of 320 pixels in length
	mov cx, 320d
	
	loop1:
		push cx
		mov cx, [x]
		mov dx, [y]
		mov ah, 0ch
		int 10h
		inc [x]
		pop cx
		dec cx
		cmp cx, 0
		jne loop1
		
	ret
	
endp print_line_fullscreen

proc print_line_square
	
	; Print a square of side length line_len
	mov cx, [line_len]
	
	loop2:
		push cx
		mov cx, [x]
		mov dx, [y]
		mov ah, 0ch
		int 10h
		inc [x]
		pop cx
		dec cx
		cmp cx, 0
		jne loop2
		
	ret
	
endp print_line_square

proc print_tile

	; Print tile based on col_len
	mov cx, [col_len]
	mov ax, [y]
	mov [y_prev], ax
	
	loop3:
		push cx
		mov ax, [x_prev]
		mov [x], ax
		mov al, [color]
		call print_line_square		; call print_line * col_len
		inc [y]
		pop cx
		dec cx 
		cmp cx, 0
		jne loop3
		
	ret
	
endp print_tile

proc print_line1

	; Print a row of the game board
	mov cx, 8d
	
	loop4:
		mov ax, [y_prev]
		mov [y], ax
		mov [color],1d
		mov ax, cx
		mov bl, 2
		div bl
		cmp ah, 0
		je cc1
		jmp c11
		cc1:
		mov [color], 15d
		c11:
		push cx
		call print_tile
		mov ax, [x]
		mov [x_prev], ax
		pop cx
		dec cx
		cmp cx, 0
		jne loop4
		
	ret
	
endp print_line1

proc print_line2

	; Print a row type 2 of the game board
	mov cx, 8d
	
	loop5:
		mov ax, [y_prev]
		mov [y], ax
		mov [color],15d
		mov ax, cx
		mov bl, 2
		div bl
		cmp ah, 0
		je cc2
		jmp c12
		cc2:
		mov [color], 1d
		c12:
		push cx
		call print_tile
		mov ax, [x]
		mov [x_prev], ax
		pop cx
		dec cx
		cmp cx, 0
		jne loop5
		
	ret
	
endp print_line2

proc print_board

	; Print the board using print_line1 and print_line2
	mov cx, 4
	
	draw_board:
		push cx
		mov ax, [y]
		mov [y_prev], ax
		mov [x], 70
		mov [x_prev], 70
		mov [color], 15d
		call print_line2
		mov [x], 70
		mov [x_prev], 70
		add [y_prev], 20
		add [y], 20
		call print_line1
		pop cx
		loop draw_board
		
	ret
	
endp print_board

proc init_soldiers

	; Init a row of soldiers
	mov cx, 4
	
	init_soldiers_p1:
			push cx
			call print_tile  ; a mini tile represents a soldier
			add [x], 40d
			add [x_prev], 40d
			mov ax, [y_tracker]
			mov [y], ax
			mov [y_prev], ax
			pop cx
			loop init_soldiers_p1
			
	ret
	
endp init_soldiers

proc init_all_soldiers

	; Initialize soldiers
	mov [line_len], 10d
	mov [col_len], 10d
	mov [color], 4
	mov [x], 75
	mov [x_prev], 75
	mov [y], 15
	mov [y_prev], 15
	call init_soldiers
	add [y], 20d
	mov ax, [y]
	mov [y_tracker], ax
	mov [x], 95d
	mov [x_prev], 95d
	call init_soldiers
	add [y], 20d
	mov ax, [y]
	mov [y_tracker], ax
	mov [x], 75
	mov [x_prev], 75
	call init_soldiers
	
	mov [color], 14d
	mov [x], 95d
	mov [x_prev], 95d
	mov [y], 115d
	mov [y_prev], 115d
	mov [y_tracker], 115d
	call init_soldiers
	add [y], 20d
	mov ax, [y]
	mov [y_tracker], ax
	mov [x], 75d
	mov [x_prev], 75d
	call init_soldiers
	add [y], 20d
	mov ax, [y]
	mov [y_tracker], ax
	mov [x], 95d
	mov [x_prev], 95d
	call init_soldiers
	
	ret
	
endp init_all_soldiers

proc get_column_and_row_of_mouse

		; (cx/2 - 70) / 20 : Gets the index of the current column
		shr cx, 1d
		sub cx, 70d
		mov ax, cx
		push dx
		mov dx, 0d
		mov bx, 20d
		div bx
		
		; ax gets the column number (0 - 7)
		mov [col_number], ax
		
		pop dx
		sub dx, 15d
		mov ax, dx
		mov dx, 0
		mov bx, 20d
		div bx
		
		; ax gets the row number (0 - 7)
		mov [row_number], ax
		
	ret
	
endp get_column_and_row_of_mouse

proc check_column

			; Returns the address of wanted column array
			cmp [value_to_check], 0
			je change_col1
			cmp [value_to_check], 1
			je change_col2
			cmp [value_to_check], 2
			je change_col3
			cmp [value_to_check], 3
			je change_col4
			cmp [value_to_check], 4
			je change_col5
			cmp [value_to_check], 5
			je change_col6
			cmp [value_to_check], 6
			je change_col7
			cmp [value_to_check], 7
			je change_col8
			
			change_col1:
				mov bx, offset col1
				jmp finish1
				
			change_col2:
				mov bx, offset col2
				jmp finish1
				
			change_col3:
				mov bx, offset col3
				jmp finish1
				
			change_col4:
				mov bx, offset col4
				jmp finish1
				
			change_col5:
				mov bx, offset col5
				jmp finish1
				
			change_col6:
				mov bx, offset col6
				jmp finish1
				
			change_col7:
				mov bx, offset col7
				jmp finish1
				
			change_col8:
				mov bx, offset col8
				jmp finish1
				
			finish1:
			; The address goes into bx
	ret
endp check_column

proc restart_game
	
	;Copy the mock arrays into game arrays to init game
	mov si, 0
	l1:
	
		mov bx, offset col12
		mov al, [byte ptr bx+si]
		mov bx, offset col1
		mov [byte ptr bx+si], al
		inc si
		cmp si, 8
		jne l1 
	mov si, 0
	
	l2:
		mov bx, offset col22
		mov al, [byte ptr bx+si]
		mov bx, offset col2
		mov [byte ptr bx+si], al
		inc si
		cmp si, 8
		jne l2
	mov si, 0
	
	l3:
		mov bx, offset col32
		mov al, [byte ptr bx+si]
		mov bx, offset col3
		mov [byte ptr bx+si], al
		inc si
		cmp si, 8
		jne l3
	mov si, 0
	
	l4:
		mov bx, offset col42
		mov al, [byte ptr bx+si]
		mov bx, offset col4
		mov [byte ptr bx+si], al
		inc si
		cmp si, 8
		jne l4
	mov si, 0
	
	l5:
		mov bx, offset col52
		mov al, [byte ptr bx+si]
		mov bx, offset col5
		mov [byte ptr bx+si], al
		inc si
		cmp si, 8
		jne l5
	mov si, 0
	
	l6:
		mov bx, offset col62
		mov al, [byte ptr bx+si]
		mov bx, offset col6
		mov [byte ptr bx+si], al
		inc si
		cmp si, 8
		jne l6
	mov si, 0
	
	l7:
		mov bx, offset col72
		mov al, [byte ptr bx+si]
		mov bx, offset col7
		mov [byte ptr bx+si], al
		inc si
		cmp si, 8
		jne l7
	mov si, 0
	
	l8:
		mov bx, offset col82
		mov al, [byte ptr bx+si]
		mov bx, offset col8
		mov [byte ptr bx+si], al
		inc si
		cmp si, 8
		jne l8
		
	finish2:
	mov [line_len], 20
	mov [col_len], 20
	mov bh, 0
	mov [x], 10
	mov [y], 10
	mov [x_prev], 10
	mov [y_prev], 10
	mov dx, [y]
	mov al, [color]
	call print_board		; Repaint the board
	
	mov [x], 15
	mov [x_prev], 15
	mov [y], 15
	mov [y_prev], 15
	mov [y_tracker], 15
	call init_all_soldiers	; Re-init the soldiers
	mov [current_turn], 1
	mov [p1_score], 0		; Reset score
	mov [p2_score], 0
	mov [p1_queens_num], 0
	mov [p2_queens_num], 0
	ret
endp restart_game

proc fill_screen

	mov cx, 200
	mov [y], 0
	mov [y_prev], 0
	
	print_welcome_screen:
	
		push cx
		mov al, [color]
		mov [x], 0
		mov [x_prev], 0
		call print_line_fullscreen
		inc [y]
		inc [y_prev]
		inc [y_tracker]
		pop cx
		loop print_welcome_screen
		
	ret
	
endp fill_screen

proc printWords
	; offset of word goes to bx
	; Number of letters in cx
	; Row in dh
	; Col in dl
	; Color in [color]
	
	mov di, 0
	push bx
	
	mov bh, 0
	mov ah, 02h
	
	int 10h
	
	pop bx
	
	ptwt:
		push bx
		mov al, [bx+di]
		mov bl, [color]
		mov bh, 0
		mov ah, 0Eh
		int 10h
		inc di
		inc dl
		pop bx
		loop ptwt
		
	ret
	
endp printWords
start:
	mov ax, @data
	mov ds, ax
	
	;Enter graphic mode:
	mov ax, 13h
	int 10h
	;-----------------
	

	; Init mouse
	mov ax, 0
	int 33h
	; Present mouse
	mov ax, 1h
	int 33h
	
	restarter:
	mov [color], 0
	mov ax, 2h
	int 33h
	call fill_screen
	mov ax, 1h
	int 33h
	
	mov bx, offset start_message1
	mov cx, 20d
	mov dh, 4
	mov dl, 9
	mov [color], 4
	call printWords
	
	mov bx, offset start_message2
	mov cx, 37d
	mov dh, 6
	mov dl, 2
	mov [color], 3
	call printWords
	
	changeScreenWait:
		mov ax,3h
		int 33h
		cmp bx, 01h
		jne changeScreenWait
	
	mov ax, 2
	int 33h
	call fill_screen	
	
	mov [color], 0
	call restart_game
	
	
	; Init mouse
	mov ax, 0
	int 33h
	
	
	; Present mouse
	mov ax, 1h
	int 33h
	
		run1aa:
		mov ax, 3
		int 33h     ;#Check the mouse
		cmp bx, 0   ;#See if button is released
		jne run1aa   ;#If NOT equal, then not released, go check again.
	
	xor bx, bx  ;#button is released, clear the result	
	
	mov bx, offset current_turn_message
	mov cx, 5d
	mov dh, 0
	mov dl, 0
	mov [color], 2d
	call printWords			; Prints 'Current Turn: '
	
	cmp [current_turn], 2
	je p2_turn_message
	
	mov bx, offset p1_message
	jmp print_continue
	
	p2_turn_message:
	mov bx, offset p2_message
	
	print_continue:
	mov cx, 8d
	mov dh, 1
	mov dl, 0
	mov [color], 2d
	call printWords				; Print 'Turn : ...'
	
	
	mov bx, offset restart_message
	mov cx, 7d
	mov dh, 0
	mov dl, 33
	mov [color], 5d
	call printWords
	
	
	
	

	mouse_loop1:
		; Get location of mouse
		mov ax,3h
		int 33h
		cmp bx, 01h
		jne mouse_loop1
		shr cx, 1
		cmp cx, 170
		ja continue7
		jmp continue8
		continue7:
		cmp dx, 20
		ja continue8
		jmp restarter
		jmp run1aa
		continue8:
		shl cx, 1
		call get_column_and_row_of_mouse
			mov si, [row_number]  ; Check the column
			mov ax, [col_number]
			mov [value_to_check], ax
			call check_column
			jmp continue9

			avoid_far_jmp_to_run1aa:
				jmp run1aa
	
			continue9:
			mov al, [byte ptr bx+si]	; al gets the the team which the soldier on the click spot stands
				
			turn_validator:			; current_turn gets 1 or 2 - corresponds to current turn. If clicked on 0 or ~1 or ~2, then wait for a valid click
				cmp al, [current_turn]
				je continue10
				
				cmp al, 3
				je player1_queen
				cmp al, 4
				je player2_queen
				
				player1_queen:
					cmp [current_turn], 1
					je validate_queen_move
					jmp avoid_far_jmp_to_run1aa		; If queen hasn't been validated, wait for another loop - regular move was already rejected
				player2_queen:
					cmp [current_turn], 2
					je validate_queen_move
					jmp avoid_far_jmp_to_run1aa 
				
				validate_queen_move:
					mov [queen_mov], 1
					jmp continue10
					
				jmp avoid_far_jmp_to_run1aa ;jne
				
		continue10:
		mov bx, 0
		
	run1a:
		mov ax, 3
		int 33h     ;#Check the mouse
		cmp bx, 0   ;#See if button is released
		jne run1a   ;#If NOT equal, then not released, go check again.
	
	xor bx, bx  ;#button is released, clear the result		
		
	mouse_loop2:
		mov ax,3h
		int 33h
		cmp bx, 01h
		jne mouse_loop2
		mov ax, [row_number] 
		mov [row_num_prev_click], ax    ; Get row num of prev click to know which tile to clear
		mov ax, [col_number]
		mov [col_num_prev_click], ax	; Get col num of prev click to know which tile to clear
		call get_column_and_row_of_mouse	; dx and cx contain the new coordinates
		cmp [queen_mov], 1
		je queen_move					; In mouse loop 1, queen_mov got one if a valid-to-turn queen was clicked on
		cmp [current_turn], 1
		je player1_check
		jmp player2_check
		
		queen_move:
		
		player1_check:		; Player 1 goes down
			sub [row_number], 1
			mov ax, [row_num_prev_click]	
			cmp ax, [row_number]			; Check if move was valid
			je ok1
			sub [row_number], 1				; Check if soldier went down two rows - ate a soldier
			cmp ax, [row_number]
			je player1_ate
			jmp avoid_far_jmp_to_run1aa
			ok1:
				inc [row_number]				
				mov ax, [col_num_prev_click]
				inc ax
				cmp ax, [col_number]		;Check if current column is +1 or -1 than prev
				mov [right_or_left], 1
				je avoid_avoid_avoid_p1
				sub ax, 2
				cmp ax, [col_number]
				mov [right_or_left], 0
				je avoid_avoid_avoid_p1
				jmp avoid_far_jmp_to_run1aa
				
		player2_check:   ; Player 2 goes up
			add [row_number], 1
			mov ax, [row_num_prev_click]	
			cmp ax, [row_number]			; Check if move was valid
			je ok2
			add [row_number], 1
			cmp ax, [row_number]
			je player2_ate
			jmp avoid_far_jmp_to_run1aa
			ok2:
				dec [row_number]				
				mov ax, [col_num_prev_click]
				inc ax
				cmp ax, [col_number]		;Check if current column is +1 or -1 than prev
				mov [right_or_left], 1
				je avoid_avoidp1
				sub ax, 2
				cmp ax, [col_number]
				mov [right_or_left], 0
				je avoid_avoidp1
				jmp avoid_far_jmp_to_run1aa
		another_avoid:
			jmp avoid_far_jmp_to_run1aa
		avoid_avoid_avoid_p1:
			jmp avoid_avoidp1
	
		player1_ate:
			add [row_number], 2 ; 2 was subbed to check if row + 2
			jmp continue4
				
		player2_ate:
			sub [row_number], 2 ; 2 was added to check of row - 2

			continue4:
			mov ax, [col_num_prev_click]
			add ax, 2
			mov [right_or_left], 1
			cmp ax, [col_number]
			je player1_ate_check_continue
			sub ax, 4
			mov [right_or_left], 0
			cmp ax, [col_number]
			jne another_avoid
			jmp player1_ate_check_continue
			
			

		avoid_avoidp1:
			jmp avoid_far_to_p1
		another_avoid2:
			jmp another_avoid

			
		player1_ate_check_continue:		
			cmp [right_or_left], 0
			je p1_went_left
			
			p1_went_right:
				mov cx, [col_number]
				dec cx					; In order to clear the soldier in needed place
				jmp continue2
										
			p1_went_left:
				mov cx, [col_number]
				inc cx
				jmp continue2
				
				avoid_far_to_p1:
				jmp p1	
				
				continue2:
				mov si, [row_number]
				cmp [current_turn], 1
				je one_less
				one_above:
				inc si
				jmp continue6
				one_less:
				dec si
				continue6:
				mov [value_to_check], cx
				call check_column
				mov al, [byte ptr bx+si]
				mov dl, [current_turn]
				cmp al, dl
				je another_avoid2
				mov al, [byte ptr bx+si]
				cmp al, 0
				je another_avoid2
				mov [byte ptr bx+si], 0	; Clear tile where eaten soldier was
				push si
				push cx
				push bx
				mov ax, [col_number]
				mov [value_to_check], ax
				call check_column
				mov si, [row_number]
				mov al, [current_turn]
				mov [byte ptr bx+si], al	; Move soldier to new spot
				pop bx
				pop cx
				pop si
				
				mov [color], 1
				mov [col_len], 20
				mov [line_len], 20
				mov ax, si		; si contains the row of eaten soldier
				mov bx, 20
				mul bx
				add ax, 10
				mov [y], ax
				mov [y_tracker], ax
				mov [y_prev], ax
				mov ax, cx	
				mul bx
				add ax, 70
				mov [x], ax
				mov [x_prev], ax
				mov ax, 2
				int 33h
				call print_tile				; Draw a tile in the cleared spot
				mov ax, 1
				int 33h
				cmp [current_turn], 1
				jne p2_add_point
				inc [p1_score]
				jmp cuber
				p2_add_point:
				inc [p2_score]
				jmp cuber
							
		avoid_far_jmp_to_mouse_loop_1:
			jmp avoid_far_jmp_to_run1aa
		
		p1: 
			mov si, [row_number]
			mov al, [current_turn]
			push cx
			mov cx, [col_number]
			mov [value_to_check], cx
			pop cx
			call check_column
			
			cmp [byte ptr bx+si], 0					; This is if player made a regular move
			jne avoid_far_jmp_to_mouse_loop_1
			
			mov [byte ptr bx+si], al				; Move player to new spot
			
			cmp [current_turn], 2
			je check_if_p2_reached_end
			
			check_if_p1_reached_end:				; If player 1 reached the end (row 8), add queen
				cmp [row_number], 7
				je add_queen_p1
				jmp cuber
			
			check_if_p2_reached_end:				; If player 2 reached the end (row 1), add queen
				cmp [row_number], 0
				je add_queen_p2
				jmp cuber
			
			add_queen_p1:
				mov [byte ptr bx+si], 3				; bx+si already is value of column and row
				inc [p1_queens_num]
				jmp cuber
			
			add_queen_p2:
				mov [byte ptr bx+si], 4
				inc [p2_queens_num]
				jmp cuber				
			
			
			cuber:
			mov [color], 1
			mov [col_len], 20
			mov [line_len], 20
			mov ax, [row_num_prev_click]
			mov bx, 20
			mul bx
			add ax, 10
			mov [y], ax
			mov [y_tracker], ax
			mov [y_prev], ax
			mov ax, [col_num_prev_click]	
			mul bx
			add ax, 70
			mov [x], ax
			mov [x_prev], ax
			mov ax, 2
			int 33h
			call print_tile				; Draw a tile in the cleared spot
			mov ax, 1h
			int 33h
			
		
			
			cmp [current_turn], 1
			je red
			mov [color],14d
			jmp continue1
			red:
			mov [color], 4
			continue1:
			mov [col_len], 10
			mov [line_len], 10
			mov ax, [row_number]
			mov bx, 20
			mul bx
			add ax, 15
			mov [y], ax
			mov [y_tracker], ax
			mov [y_prev], ax
			mov ax, [col_number]	
			mul bx
			add ax, 75
			mov [x], ax
			mov [x_prev], ax
			mov ax, 2
			int 33h
			call print_tile				; Draw a player in the new spot
			mov ax, 1h
			int 33h
			
			push cx
			mov cx, [col_num_prev_click]
			mov [value_to_check], cx
			pop cx
			call check_column
			mov si, [row_num_prev_click]
			mov [byte ptr bx+si], 0		; Clear the spot where soldier previously was
			
			
		turn_changer:
		mov [eat], 0
		cmp [p1_score], 12
		je p1_wins
		cmp [p2_score], 12
		je p2_wins
		cmp [current_turn], 1
		je change2
		mov [current_turn], 1
		jmp run1aa
		change2:
			mov [current_turn], 2
		jmp run1aa
		
		p1_wins:
		mov ax,2
		int 33h
		mov [color], 0
		call fill_screen
		mov bx, offset p1_won
		jmp continue_win
		
		p2_wins:
		mov ax,2
		int 33h
		mov [color], 0
		call fill_screen
		mov bx, offset p2_won
		
		continue_win:
		mov ax, 1
		int 33h
		mov cx, 13
		mov dl, 5
		mov dh, 5
		mov al, 1
		call printWords
		
		mov bx, 0
		final_mouse_loop:
			mov ax,3h
			int 33h
			cmp bx, 01h
			jne final_mouse_loop
			jmp restarter
		
		
	
exit:
	mov ax,4c00h
	int 21h
END start