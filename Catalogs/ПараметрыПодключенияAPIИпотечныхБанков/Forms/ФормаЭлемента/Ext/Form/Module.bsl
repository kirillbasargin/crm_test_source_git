﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.Страницы.Видимость = НЕ Объект.ТолькоОтправкаПисем;
	Элементы.ГруппаПолучатели.Видимость = Объект.ТолькоОтправкаПисем;

	//<897513>, Басаргин (23.11.2018) {
	Если НЕ Параметры.Ключ.Пустая() Тогда
		ЗаполнитьЗначенияСвойств(ЭтаФорма, УправлениеИпотечнымиЗаявкамиДомКлик.ПолучитьСекреты(Параметры.Ключ));
	КонецЕсли;	
	//<897513> }
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиПравДоступаПользователейОбъектДоступаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура НастройкиПравДоступаПользователейОбъектДоступаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура ТолькоОтправкаПисемПриИзменении(Элемент)
	
	Элементы.Страницы.Видимость = НЕ Объект.ТолькоОтправкаПисем;
	Элементы.ГруппаПолучатели.Видимость = Объект.ТолькоОтправкаПисем;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	//<897513>, Басаргин (23.11.2018) {		
	УправлениеИпотечнымиЗаявкамиДомКлик.ЗаписатьСекреты(Параметры.Ключ, client_id, client_secret);
	//<897513> }
	
	//УстановитьПривилегированныйРежим(Истина);
	//ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(ТекущийОбъект.Ссылка, Password);
	//УстановитьПривилегированныйРежим(Ложь);
		
КонецПроцедуры
