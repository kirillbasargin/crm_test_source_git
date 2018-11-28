﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьТаблицуТиповПредметов();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	УстановитьОтборТаблицы(ЭтотОбъект);
	
	ТекущийТипПредмета = Настройки.Получить("ТекущийТипПредмета");
	Если ЗначениеЗаполнено(ТекущийТипПредмета) Тогда
		
		НайденныеСтроки =  ТаблицаТиповПредметов.НайтиСтроки(Новый Структура("ТипПредмета", ТекущийТипПредмета));
		
		Если НайденныеСтроки.Количество() > 0 Тогда
			Элементы.ТаблицаТиповПредметов.ТекущаяСтрока = НайденныеСтроки[0].ПолучитьИдентификатор();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыТиповПредмета

&НаКлиенте
Процедура ТаблицаТиповПредметовВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ВыбратьИЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаТиповПредметовПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.ТаблицаТиповПредметов.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		ТекущийТипПредмета = ТекущиеДанные.ТипПредмета;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НеОтображатьВзаимодействияПриИзменении(Элемент)
	
	УстановитьОтборТаблицы(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ВыбратьИЗакрыть();
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицуТиповПредметов()

	СписокДоступныхТиповПредметов = Взаимодействия.СписокДоступныхТиповПредметов();
	СписокДоступныхТиповПредметов.СортироватьПоПредставлению();
	
	Для Каждого ЭлементСписка Из СписокДоступныхТиповПредметов Цикл 
		
		НоваяСтрока = ТаблицаТиповПредметов.Добавить();
		НоваяСтрока.ПредставлениеТипа       = ЭлементСписка.Представление;
		НоваяСтрока.ТипПредмета             = ЭлементСписка.Значение;
		НоваяСтрока.ЯвляетсяВзаимодействием = ЭлементСписка.Пометка;
		
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИЗакрыть()
	
	ТекущиеДанные = Элементы.ТаблицаТиповПредметов.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Закрыть();
	КонецЕсли;
	
	ОповеститьОВыборе(ТекущиеДанные.ТипПредмета);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборТаблицы(Форма)

	Если Форма.НеОтображатьВзаимодействия Тогда
		ОтборСтрок = Новый Структура("ЯвляетсяВзаимодействием", Ложь);
		Форма.Элементы.ТаблицаТиповПредметов.ОтборСтрок = Новый ФиксированнаяСтруктура(ОтборСтрок);
	Иначе
		Форма.Элементы.ТаблицаТиповПредметов.ОтборСтрок = Неопределено;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
