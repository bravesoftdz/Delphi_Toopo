//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
//
// Unidad: PalabrasVacias.pas
//
// Prop�sito:
//		La clase TPalabrasVacias es un descendiete directo de TListaEnFichero y
//		sirve para recuperar la lista de palabras (stoplist) que se consideran
//		sup�rfluas tanto en la indexaci�n como en la b�squeda.
//		Ofrece m�todos para averiguar si una palabra est� en la lista (es decir:
//		saber si es palabra vac�a o no) y para eliminar todas las palabras
//
//
// Autor:          JM - http://www.lawebdejm.com
// Observaciones:  Creado en Delphi 6 para Todo Programaci�n (www.iberprensa.com)
// Copyright:      Este c�digo es de dominio p�blico y se puede utilizar y/o
//						 mejorar siempre que SE HAGA REFERENCIA AL AUTOR ORIGINAL, ya
//						 sea a trav�s de estos comentarios o de cualquier otro modo.
//
// Modificaciones:
//		JM		01/12/2004		Versi�n inicial
//
//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
unit PalabrasVacias;

interface

uses ListaEnFichero;

type
	TPalabrasVacias = class(TListaEnFichero)
	public
		function EsPalabraVacia(palabra: PChar): boolean;
		function QuitarPalabrasVacias(texto: PChar): integer;
	end;


implementation

uses SysUtils, Parseador;


function TPalabrasVacias.EsPalabraVacia(palabra: PChar): boolean;
begin
	result := (Lista.IndexOf(palabra) <> -1);
end;


function TPalabrasVacias.QuitarPalabrasVacias(texto: PChar): integer;
var
	ini, fin, final: PChar;
	palabra: array[0..63] of char;
begin
	result := 0;
	ini := texto;
	final := StrEnd(texto);
	repeat
		ini := TParseador.AvanzarMientrasCaracter(ini, final, ' ');
		fin := TParseador.AvanzarHastaCaracter(ini, final, ' ');

		if (ini <> nil) and (ini^ <> #0) then
		begin
			StrLCopy(palabra, ini, fin - ini);

			if EsPalabraVacia(palabra) then
			begin
				Inc(result);
				Dec(ini);
				if (fin = nil) or (fin^ = #0) then
				begin
					while ini^ <> ' ' do
						Dec(ini);
					ini^ := #0;
				end
				else
					StrLCopy(ini, fin, final - fin);
			end
			else
				ini := fin;
		end;

	until (ini = nil) or (ini^ = #0);
end;


end.
