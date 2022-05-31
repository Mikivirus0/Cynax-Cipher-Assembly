INCLUDE Irvine32.inc									 ; Including Irvine32 Library
INCLUDE macros.inc										 ; Including macros Library

BUFFER_SIZE = 5000										 ; Defining Global Variable BUFFER_SIZE  

.DATA											         
    buffer byte BUFFER_SIZE DUP(?)						 ; Defining an array named buffer of size BUFFER_SIZE
    FileName    BYTE 80 DUP(0)							 ; An array to store file name
    FileHandle  HANDLE ?								 ; Handle for file handling
	Key word 80 DUP(0)											 ; Key variable to store shift value
	Text byte 100 dup(?)								 ; Array to store the file contents
	Operation dword ?									 ; Variable to store user's choice of operation

	;; input validators:
	CMP_V1 byte "umair", 0
	CMP_V2 byte "shujjah", 0
	CMP_V3 byte "rida", 0
	CMP_V4 byte "shamaim", 0
	CMP_V5 byte "maira", 0


.CODE

strcmp Proc

	INVOKE Str_compare, ADDR Key, ADDR CMP_V1

	je _umair ;; Incase umair is entered.

	INVOKE Str_compare, ADDR Key, ADDR CMP_V2
	
	je _shujjah

	INVOKE Str_compare, ADDR Key, ADDR CMP_V3
	
	je _rida
	INVOKE Str_compare, ADDR Key, ADDR CMP_V4
	
	je _shamaim
	INVOKE Str_compare, ADDR Key, ADDR CMP_V5
	
	je _maira
	jmp _else

	_umair:
		mov ax, 5
		jmp _end

	_shujjah:
		mov ax, 7
		jmp _end

	_rida:
		mov ax, 9
		jmp _end
	_shamaim:
		mov ax, 11
		jmp _end
	_maira:
		mov ax, 13
		jmp _end
	_else:
		mov ax, 15
	_end:
		ret

strcmp endp


MAIN PROC
Start:													 ; Starting Label

	mWrite "                               CYNAX CIPHER                                 "
	CALL CRLF
	mWrite"                            COAL SEMESTER PROJECT                             "
	CALL CRLF
	mWrite"                     UMAIR | SHUJJAH | RIDA | SHAMAIM | MAIRA                        "
	CALL CRLF
	mWrite"=================================================================================="
	CALL CRLF

	mWrite "Enter The Input File Name: "					 ; Prompting the user to input File name
	MOV EDX,OFFSET FileName								 ; Moving the address of FileName to EDX
	MOV ECX,SIZEOF FileName								 ; Moving the size of FileName to ECX
	CALL ReadString										 ; Reading string from console
   
	CALL CRLF											 ; Printing Line
	mWrite "Opening .txt File........"                     ; Displaying string
	CALL CRLF											 ; Printing Line

	MOV EDX,OFFSET FileName								 ; Moving the address of FileName to EDX
    CALL OpenInputFile									 ; Calling builtin function to open file
    MOV FileHandle,EAX									 ; Moving the contents of EAX to FileHandle

	mWrite"Reading The File Contents........"			 ; Displaying string
	CALL CRLF											 ; Printing Line

	MOV EDX,OFFSET buffer								 ; Moving the address of buffer to EDX
    MOV ECX,BUFFER_SIZE									 ; Moving the value of BUFFER_SIZE to ECX
    CALL ReadFromFile									 ; Calling builtin function to read from file
	
	mwrite "File contents: "
	mov edx, offset buffer
	call writestring

	mWrite "Done........"								 ; Printing String
	CALL CRLF											 ; Printing Line
	CALL CRLF											 ; Printing Line

Menu:													 ; Menu Label
	mWrite "Choose the operation that you want to perform: "   ; Displaying String
	CALL CRLF											 ; Printing Line
	mWrite"Press '1' for Encryption."					 ; Displaying string
	CALL CRLF											 ; Printing Line
	mWrite"Press '2' for Decryption. "					 ; Displaying string
	CALL CRLF											 ; Priting Line
	mWrite"Input: "										 ; Displaying string
	CALL readdec										 ; Reading decimal from console
	MOV Operation,EAX									 ; Moving the content of EAX to Operation

	CALL CRLF											 ; Printing Line

	mWrite"Enter The Key: "								 ; Displaying string
	mov edx, offset key
	mov ecx, sizeof key
	CALL readstring										 ; Reading String from console

	;; Comparing Keys:
	mwrite "Calling FUNCTION!!"
	call crlf
	call strcmp
	;; result from strcmp procedure.
	mov key, ax

	cmp Operation,1										 ; Comparing Operation to 1 (  if(Operation == 1)  )
	je Encryption_Module								 ; Jump to Encryption_Module if Operation == 1
	
	cmp Operation,2										 ; Comparing Operation to 2 (  if(Operation == 2)  )
	je Decryption_Module											 ; Jump to Decryption_Module if Operation == 2
 
	mWrite"Invalid Entry! "								 ; Displaying string
	CALL CRLF
	JMP Menu									         ; Jumping to Menu Label

 
Encryption_Module:                                       ; Encryption_Module Label
Encryption proc											 ; Encryption Procedure
		
		CALL CRLF										 ; Printing Line
		mWrite"============================= ENCRYPTION  MODULE ================================="
		CALL CRLF										 ; Printing Line

		MOV EDI,OFFSET Text								 ; Moving the address of Text to EDI
		MOV ECX,(LENGTHOF Text)							 ; Moving the length of Text to ECX
		MOV EBP,offset buffer							 ; Moving the address of buffer to EBP
		MOV ESI,0										 ; Clearing the contents of ESI
		MOV EAX,0										 ; Clearing the contents of EAX
		MOV EBX,0										 ; Clearing the contents of EBX
		MOV EDX,0										 ; Clearing the contents of EDX
	l2:													 ; l2 Label
		MOV EAX,0										 ; Clearing the contents of EAX

		;; for(int i = 0; i < lengthof(text); i++)
		;;	if buffer[i] < 65:
		;;		continue
		;;  if buffer[i] <= 'Z':
		;;      (((buffer[i] + SHIFT) % 26) + 65)  
		;;

		cmp buffer[ESI], 65								 ; Comparing uppercase 'A' with AL (Using ASCII)
		jl next_char                                     ; If AL is less than 'a', then jump tp next_char label
		cmp buffer[ESI], 90                              ; Comparing lowercase 'z' with AL (Using ASCII)
		jle Encryption_Mod                               ; If AL is less than or equal to 90, then jump to Encryption_Mod
		cmp buffer[ESI], 97                              ; Comparing lowercase  'A' with AL (Using ASCII)
		jl next_char                                     ; If AL is less than 'A', then jumpm to next_char label
		cmp buffer[ESI], 122                             ; Comparing uppercase 'Z' with AL (Using ASCII)
		jle Encryption_Module                            ; If AL is less than or equal to 'Z', then jump to Encryption_Module


	Encryption_Module:									 ; Encryption_Module Label
		MOV AL,[EBP+ESI]								 ; Moving value of EBP+ESI to AL
		SUB AX,97										 ; Subtracting 97 from AX (AX - 97)
		ADD AX,Key										 ; Adding the value of Key to AX
		MOV BX,26										 ; Moving 26 to BX
		XOR EDX,EDX										 ; Performing XOR operation on EDX with EDX
		div BX											 ; Remainder			
		ADD DL,97										 ; Adding 97 to DL
		MOV [EDI+ESI],DL								 ; Moving DL to EDI+ESI
		JMP LoopAlt										 ; Jump to LoopAlt Label

	Encryption_Mod:										 ; Encryption_Mod Label
		MOV AL,[EBP+ESI]								 ; Moving the value of EBP+ESI to AL 
		SUB AX,65										 ; Subtracting 65 from AX
		ADD AX,Key										 ; Adding the value of Key to AX
		MOV BX,26										 ; Moving 26 to BX
		XOR EDX,EDX										 ; Performing XOR operation on EDX with EDX
		div BX											 ; Remainder			
		ADD DL,65										 ; Adding 65 to DL
		MOV [EDI+ESI],DL                                 ; Moving the contents of DL to ESI+ESI
		JMP LoopAlt										 ; Jump tp LoopAlt Label


	LoopAlt:											 ; LoopAlt Label
		inc ESI											 ; Incrementing the value of ESI
		loop l2											 ; Looping L2
		JMP Quit										 ; Jump to Quit Label

	next_char:											 ; next_char Label
		MOV AL,[EBP+ESI]								 ; Moving the value of EBP+ESI to AL
		MOV [EDI+ESI],AL								 ; Moving the contents of AL to ESI+ESI
		JMP LoopAlt										 ; Jump to LoopAlt Label

	
	Quit:												 ; Quit Label
		 CALL CRLF										 ; Printing Line
		 mWrite"File Contents: "						 ; Displaying String
		 MOV EDX, offset buffer							 ; Moving the address of buffer to EDX
		 call writestring								 ; Writing string on console
		 CALL CRLF										 ; Printing Line
		 CALL CRLF										 ; Printing Line
		 mWrite"Encrypted Text: "						 ; Displaying String

		 MOV EDX,offset Text							 ; Moving the address of Text to EDX
		 CALL writestring								 ; Writing string on console
		 CALL CRLF										 ; Printing Line
		 CALL CRLF										 ; Printing Line
		 mWrite"=================================================================================="
		 CALL CRLF										 ; Printing Line
			
Encryption ENDP											 ; Ending Encryption Procedure
JMP DONE												 ; Jump to DONE Label

	
Decryption_Module:										 ; Decryption_Module Label
Decryption proc											 ; Decryption Procedure
		CALL CRLF										 ; Printing Line
		mWrite"============================= DECRYPTION  MODULE ================================="
		CALL CRLF										 ; Printing Line
		CALL CRLF										 ; Printing Line

		MOV EDI,OFFSET Text								 ; Moving the address of Text to EDI
		MOV ECX,(LENGTHOF Text)							 ; Moving the length of Text to ECX
		MOV EBP,offset buffer							 ; Moving the address of buffer to EBP
		MOV ESI,0										 ; Clearing the contents of ESI
		MOV EAX,0										 ; Clearing the contents of EAX
		MOV EBX,0										 ; Clearing the contents of EBX
		MOV EDX,0										 ; Clearing the contents of EDX

	l1:													 ; l1 Label
		MOV EAX,0										 ; Clearing the contents of EAX
		cmp buffer[ESI], 65								 ; Comparing AL with lowercase 'a' (Using ASCII)
		jl next_char									 ; If AL is less than 'a', then jump tp next_char Label
		cmp buffer[ESI], 90								 ; Comparing AL with lowercase 'z' (Using ASCII)
		jle Decryption_Mod								 ; If AL is less than or equal to 'z', then jump to Decryption_Mod Label
		cmp buffer[ESI], 97								 ; Comparing AL with uppercase 'A'
		jl next_char									 ; If AL is less than 'A', then jump to next_char label
		cmp buffer[ESI], 122							 ; Comparing AL to uppercase 'Z'
		jle DecryptionLabel								 ; If AL is less than or equal to 'Z', then jump to DecryptionLabel

	DecryptionLabel:									 ; DecryptionLabel 
		MOV AL,[EBP+ESI]								 ; Moving the value of EBP+ESI to AL
		SUB AX,97										 ; Subtracting 97 from AX
		SUB AX,Key										 ; Subtracting Key from AX
		ADD AX,26										 ; Adding 26 to AX
		MOV BX,26										 ; Moving 26 to BX
		XOR EDX,EDX										 ; Performing XOR on EDX with EDX
		div BX											 ; Remainder        
		ADD DL,97										 ; Adding 97 to DL
		MOV [EDI+ESI],DL								 ; Moving the contents of DL to EDI+ESI
		JMP LoopAlt										 ; Jump to LoopAlt Label

	next_char:											 ; next_char Label
		MOV AL,[EBP+ESI]								 ; Moving the value of EBP+ESI to AL
		MOV [EDI+ESI],AL								 ; Moving the contents of AL to EDI+ESI
		JMP LoopAlt										 ; Jump to LoopAlt Label

	Decryption_Mod:										 ; Decryption_Mod Label
		MOV AL,[EBP+ESI]								 ; Moving the value of EBP+ESI to AL
		SUB AX,065										 ; Subtracting 65 from AX
		SUB AX,Key										 ; Subtracting Key from AX
		ADD AX,26										 ; Adding 26 to AX
		MOV BX,26										 ; Moving 26 to BX
		XOR  EDX,EDX									 ; Performing XOR on EDX with EDX
		div BX											 ; Remainder        
		ADD DL,065										 ; Adding 65 to DL
		MOV [EDI+ESI],DL								 ; Moving the contents of DL to EDI+ESI
		JMP LoopAlt										 ; Jump to LoopAlt Label

	LoopAlt:											 ; LoopAlt Label
		inc ESI											 ; Incrementing the value of ESI
		loop l1											 ; Looping l1
		JMP Quit										 ; Jump to Quit Label
	
	Quit:												 ; Quit Label
		CALL CRLF										 ; Printing Line
		mWrite"File Contents: "							 ; Displaying String
		MOV EDX, offset buffer							 ; Moving the address of buffer to EDX
		CALL writestring								 ; Writing string on console
		CALL CRLF										 ; Printing Line
		CALL CRLF										 ; Printing Line
		mWrite"Decrypted Text: "						 ; Displaying String

		MOV EDX,offset Text								 ; Moving the address of Text to EDX
		CALL writestring								 ; Writing string on console
		CALL CRLF										 ; Printing Line

		CALL CRLF										 ; Printing Line
		mWrite"=================================================================================="
		CALL CRLF										 ; Printing Line
Decryption ENDP											 ; Ending Decryption Procedure
JMP DONE												 ; Jump to Done Label

DONE:													 ; DONE Label
	CALL CRLF											 ; Printing Line
	Mwrite"Do You Want To Perform Another Operation? (Y/N): "	; Displaying String
	CALL readchar										 ; Reading character from console
	CALL writechar										 ; Writing that character on console
	CALL CRLF											 ; Printing Line
	CALL CRLF											 ; Printing Line

	cmp AL, 'y'											 ; Comparing AL with lowercase 'y'
	je Start											 ; If AL is equal to 'y' then jump to Start Label

	cmp AL, 'Y'											 ; Comparing AL with uppercase 'Y' 
	je Start											 ; If AL is equal to 'Y' then jump to Start Label

	cmp AL, 'N'											 ; Comparing AL with uppercase 'N'
	je _Exit											 ; If AL is equal to 'N' then jump to _Exit Label

	cmp AL, 'n'											 ; Comparing AL with lowercase 'n'
	je _Exit											 ; If AL is equal to 'n' then jump to _Exit Label

	mWrite"Invalid Entry! "								 ; Displaing String to prompt user about invalid entry
	JMP Done											 ; Jump to Done Label

_Exit:													 ; _Exit Label
	mWrite "Exiting Program........"						 ; Displaying string
	CALL CRLF											 ; Printing Line
	CALL CRLF											 ; Printing Line	
	CALL WAITMSG										 ; Calling waitmsg to hold screen
		exit											 ; Exiting
	MAIN ENDP										 ; Ending MAIN Procedure
END MAIN
