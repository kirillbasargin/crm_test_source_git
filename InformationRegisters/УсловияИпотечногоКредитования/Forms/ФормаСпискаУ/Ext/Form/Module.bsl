﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
    Параметры.Свойство("ИдентификаторСтроки",ИдентификаторСтроки);
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
    
    Если ЭтаФорма.ЗакрыватьПриВыборе и ЭтаФорма.ВладелецФормы <> Неопределено Тогда
    	СтандартнаяОбработка = Ложь;
    	Закрыть();		
    	Оповестить("ВыбраноУсловиеКредитования",Новый Структура("GUID, ИдентификаторСтроки", ВыбраннаяСтрока.GUID, ИдентификаторСтроки));
    КонецЕсли;
    
КонецПроцедуры
