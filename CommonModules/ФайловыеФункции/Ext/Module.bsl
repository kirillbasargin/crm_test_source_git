﻿#Область ПрограммныйИнтерфейс

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать РаботаСФайлами.НастройкиРаботыСФайлами();
// Возвращает структуру, содержащую персональные настройки работы с файлами.
//
// Возвращаемое значение:
//  Структура - со свойствами:
//    * ПоказыватьЗанятыеФайлыПриЗавершенииРаботы        - Булево - Существует, только если внедрена подсистема Работа с
//                                                                  файлами.
//    * СпрашиватьРежимРедактированияПриОткрытииФайла    - Булево - Существует, только если внедрена подсистема Работа с
//                                                                  файлами.
//    * ПоказыватьКолонкуРазмер                          - Булево - Существует, только если внедрена подсистема Работа с
//                                                                  файлами.
//    * ДействиеПоДвойномуЩелчкуМыши                     - Строка - Существует, только если внедрена подсистема Работа с
//                                                                  файлами.
//    * СпособСравненияВерсийФайлов                      - Строка - Существует, только если внедрена подсистема Работа с
//                                                                  файлами.
//    * ГрафическиеСхемыРасширение                       - Строка - Список расширений для графических схем.
//    * ГрафическиеСхемыСпособОткрытия                   - ПеречислениеСсылка.СпособыОткрытияФайлаНаПросмотр - способ
//        открытия графических схем.
//    * ТекстовыеФайлыРасширение                         - Строка - Расширения файлов открытого формата документов.
//    * ТекстовыеФайлыСпособОткрытия                     - ПеречислениеСсылка.СпособыОткрытияФайлаНаПросмотр - способ
//        открытия текстовых файлов.
//    * МаксимальныйРазмерЛокальногоКэшаФайлов           - Число - Определяет максимальный размер локального кэша файлов.
//    * ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов    - Булево - Задавать вопрос при удалении файлов из локального кэша.
//    * ПоказыватьИнформациюЧтоФайлНеБылИзменен          - Булево - Показывать файлы при завершении работы.
//    * ПоказыватьПодсказкиПриРедактированииФайлов       - Булево - В веб-клиенте показывать подсказки при
//                                                                  редактировании файлов.
//    * ПутьКЛокальномуКэшуФайлов                        - Строка - Путь к локальному кэшу файлов.
//    * ЭтоПолноправныйПользователь                      - Булево - Истина, если это полноправный пользователь.
//    * УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактирования - Булево - удаления файлов из локального кэша при
//                                                                              завершении редактирования.
//
Функция НастройкиРаботыСФайлами() Экспорт
	
	Возврат РаботаСФайлами.НастройкиРаботыСФайлами();
	
КонецФункции

// Устарела. Следует использовать РаботаСФайлами.СохранитьНастройкиРаботыСФайлами();
// Сохраняет настройки работы с файлами.
//
// Параметры:
//  НастройкиРаботыСФайлами - Структура - настройки работы с файлами с их значениями.
//     * ПоказыватьИнформациюЧтоФайлНеБылИзменен        - Булево - Необязательный. Показывать сообщение, если файл не
//                                                                 был изменен.
//     * ПоказыватьЗанятыеФайлыПриЗавершенииРаботы      - Булево - Необязательный. Показывать файлы при завершении работы.
//     * ПоказыватьКолонкуРазмер                        - Булево - Необязательный. Отображать колонку размер в формах
//                                                                 списках файлов.
//     * ТекстовыеФайлыРасширение                       - Строка - Расширения файлов открытого формата документов.
//     * ТекстовыеФайлыСпособОткрытия                   - ПеречислениеСсылка.СпособыОткрытияФайлаНаПросмотр - способ
//         открытия текстовых файлов.
//     * ГрафическиеСхемыРасширение                     - Строка - Список расширений графических файлов.
//     * ПоказыватьПодсказкиПриРедактированииФайлов     - Булево - Необязательный. В веб-клиенте показывать подсказки
//                                                                 при редактировании файлов.
//     * СпрашиватьРежимРедактированияПриОткрытииФайла  - Булево - Необязательный. Выбирать режим редактирования при
//                                                                 открытии файла.
//     * СпособСравненияВерсийФайлов                    - ПеречислениеСсылка.СпособыСравненияВерсийФайлов -
//                                                        Необязательный. Способ сравнения версий и файлов.
//     * ДействиеПоДвойномуЩелчкуМыши                   - ПеречислениеСсылка.ДействияСФайламиПоДвойномуЩелчку - Необязательный.
//     * ГрафическиеСхемыСпособОткрытия                 - ПеречислениеСсылка.СпособыОткрытияФайлаНаПросмотр -
//                                                        Необязательный. Способ открытия файла на просмотр.
//
Процедура СохранитьНастройкиРаботыСФайлами(НастройкиРаботыСФайлами) Экспорт
	
	РаботаСФайлами.СохранитьНастройкиРаботыСФайлами(НастройкиРаботыСФайлами);
	
КонецПроцедуры

// Устарела. Следует использовать РаботаСФайлами.МаксимальныйРазмерФайла();
// Возвращает максимальный размер файла.
//
// Возвращаемое значение:
//  Число - целое число байт.
//
Функция МаксимальныйРазмерФайла() Экспорт
	
	Возврат РаботаСФайлами.МаксимальныйРазмерФайла();
	
КонецФункции

// Устарела. Следует использовать РаботаСФайлами.МаксимальныйРазмерФайлаОбщий();
// Возвращает максимальный размер файла провайдера.
//
// Возвращаемое значение:
//  Число - целое число байт.
//
Функция МаксимальныйРазмерФайлаОбщий() Экспорт
	
	Возврат РаботаСФайлами.МаксимальныйРазмерФайлаОбщий();
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Работа с томами файлов

// Устарела. Следует использовать РаботаСФайлами.ЕстьТомаХраненияФайлов();
// Есть ли хоть один том хранения файлов.
//
// Возвращаемое значение:
//  Булево - если Истина, тогда существует хотя бы один работающий том.
//
Функция ЕстьТомаХраненияФайлов() Экспорт
	
	Возврат РаботаСФайлами.ЕстьТомаХраненияФайлов();
	
КонецФункции

#КонецОбласти

#КонецОбласти
