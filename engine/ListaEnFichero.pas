//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
//
// Unidad: ListaEnFichero.pas
//
// Prop�sito:
//		La clase TListaEnFichero sirve como clase base de todas aquellas que
//		representan una lista de palabras almacenadas en un fichero de texto.
//		Cambiando esta clase podr�amos cambiar el formato de almacenamiento sin
//    tocar las clases derivadas.
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
unit ListaEnFichero;

interface

uses classes;

type
	TListaEnFichero = class(TObject)
	private
		FLista: TStrings;

		function GetNumeroPalabras: integer;

	protected
		property Lista: TStrings read FLista;

	public
		constructor Create(const archivo: string);
		destructor Destroy; override;

		property NumeroPalabras: integer read GetNumeroPalabras;
	end;



implementation


constructor TListaEnFichero.Create(const archivo: string);
begin
	inherited Create;

	FLista := TStringList.Create;
	FLista.LoadFromFile(archivo);
end;


destructor TListaEnFichero.Destroy;
begin
	FLista.Free;

	inherited;
end;


function TListaEnFichero.GetNumeroPalabras: integer;
begin
	result := FLista.Count;
end;


end.
