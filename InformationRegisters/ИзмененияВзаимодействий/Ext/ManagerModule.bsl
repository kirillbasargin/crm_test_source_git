﻿
Процедура ЗаписьИзменений(Взаимодействие, НаборНовых, НаборСтарых, Предмет, Рассмотрено, РассмотретьПосле)
	
	ДатаИзменения = ТекущаяДата();
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	
	//Совпадающие поля объекта
	ПроверитьПоле(Взаимодействие, ДатаИзменения, ТекущийПользователь, "ДатаОкончания", 	  НаборНовых, НаборСтарых);
	ПроверитьПоле(Взаимодействие, ДатаИзменения, ТекущийПользователь, "Отменено", 		  НаборНовых, НаборСтарых);
	ПроверитьПоле(Взаимодействие, ДатаИзменения, ТекущийПользователь, "МестоПроведенияВстречи", НаборНовых, НаборСтарых);
	ПроверитьПоле(Взаимодействие, ДатаИзменения, ТекущийПользователь, "Ответственный", 	  НаборНовых, НаборСтарых);
	
	//Разные поля/ТЧ объекта
	Если ТипЗнч(Взаимодействие) = Тип("ДокументСсылка.Встреча") Тогда
		ПроверитьПолеТЧ(Взаимодействие, ДатаИзменения, ТекущийПользователь, "Контакт", ПолучитьСписокКонтактов(НаборНовых), ПолучитьСписокКонтактов(НаборСтарых));
	ИначеЕсли ТипЗнч(Взаимодействие) = Тип("ДокументСсылка.ТелефонныйЗвонок") Тогда
		Если НаборНовых.АбонентКонтакт <> НаборСтарых.АбонентКонтакт Тогда
			
			НовыйКонтакт = СокрЛП(НаборНовых.АбонентПредставление) + " - " + СокрЛП(НаборНовых.АбонентКакСвязаться);
			СтарыйКонтакт = СокрЛП(НаборСтарых.АбонентПредставление) + " - " + СокрЛП(НаборСтарых.АбонентКакСвязаться);
			
			ЗаписатьИзменениеВРегистр(Взаимодействие, ДатаИзменения, ТекущийПользователь, "Контакт", НовыйКонтакт, СтарыйКонтакт);
		КонецЕсли;
	КонецЕсли;
	
	НаборДоп = Взаимодействия.СтруктураРеквизитовВзаимодействия(НаборСтарых);
	
	//Поля формы
	Если НаборДоп.Предмет <> Предмет Тогда
		ЗаписатьИзменениеВРегистр(Взаимодействие, ДатаИзменения, ТекущийПользователь, "Предмет", Предмет, НаборДоп.Предмет);
	КонецЕсли;
	
	Если НаборДоп.Рассмотрено <> Рассмотрено Тогда
		ЗаписатьИзменениеВРегистр(Взаимодействие, ДатаИзменения, ТекущийПользователь, "Рассмотрено", Рассмотрено, НаборДоп.Рассмотрено);
	КонецЕсли;
	
	Если НаборДоп.РассмотретьПосле <> РассмотретьПосле Тогда
		ЗаписатьИзменениеВРегистр(Взаимодействие, ДатаИзменения, ТекущийПользователь, "РассмотретьПосле", РассмотретьПосле, НаборДоп.РассмотретьПосле);
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьСписокКонтактов(Набор)
	
	НС = "";
	
	Если Набор.Метаданные().ТабличныеЧасти.Найти("Участники") <> Неопределено Тогда
		Для Каждого Контакт Из Набор.Участники Цикл
			НС = НС + ?(ЗначениеЗаполнено(Контакт.Контакт), Контакт.Контакт.ФИО, СокрЛП(Контакт.ПредставлениеКонтакта)) + " - " + СокрЛП(Контакт.КакСвязаться) + "; ";
		КонецЦикла;
		НС = Сред(НС, 1, СтрДлина(НС) - 2);
	КонецЕсли;
	
	Возврат НС;
	
КонецФункции

Процедура ПроверитьПолеТЧ(Взаимодействие, ДатаИзменения, ТекущийПользователь, Реквизит, НовоеЗначение, СтароеЗначение)
	
	Если Реквизит = "Контакт" Тогда
		Если НовоеЗначение <> СтароеЗначение Тогда
			ЗаписатьИзменениеВРегистр(Взаимодействие, ДатаИзменения, ТекущийПользователь, Реквизит, НовоеЗначение, СтароеЗначение);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаписатьИзменениеВРегистр(Взаимодействие, ДатаИзменения, ТекущийПользователь, Реквизит, НовоеЗначение, СтароеЗначение) Экспорт
	
	Набор = РегистрыСведений.ИзмененияВзаимодействий.СоздатьНаборЗаписей();
	Набор.Отбор.Взаимодействие.Установить(Взаимодействие);
	Набор.Прочитать();
	
	Запись = Набор.Добавить();
	Запись.Период = ДатаИзменения;
	Запись.Взаимодействие = Взаимодействие;
	Запись.Ответственный = ТекущийПользователь;
	
	Запись.Реквизит = Реквизит;
	Запись.НовоеЗначение = НовоеЗначение;
	Запись.СтароеЗначение = СтароеЗначение;
	
	Набор.Записать();
	
КонецПроцедуры

Процедура ПроверитьПоле(Взаимодействие, ДатаИзменения, ТекущийПользователь, Реквизит, НаборНовых, НаборСтарых)
	
	Если НаборНовых.Метаданные().Реквизиты.Найти(Реквизит) <> Неопределено Тогда
		Если НаборНовых[Реквизит] <> НаборСтарых[Реквизит] Тогда
			ЗаписатьИзменениеВРегистр(Взаимодействие, ДатаИзменения, ТекущийПользователь, Реквизит, НаборНовых[Реквизит], НаборСтарых[Реквизит]);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьОбъект(Объект, Предмет, Рассмотрено, РассмотретьПосле) Экспорт
	
	ЗаписьИзменений(Объект.Ссылка, Объект, Объект.Ссылка, Предмет, Рассмотрено, РассмотретьПосле);
	
КонецПроцедуры
