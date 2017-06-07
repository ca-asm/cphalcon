
/*
 +------------------------------------------------------------------------+
 | Phalcon Framework                                                      |
 +------------------------------------------------------------------------+
 | Copyright (c) 2011-2017 Phalcon Team (https://phalconphp.com)          |
 +------------------------------------------------------------------------+
 | This source file is subject to the New BSD License that is bundled     |
 | with this package in the file docs/LICENSE.txt.                        |
 |                                                                        |
 | If you did not receive a copy of the license and are unable to         |
 | obtain it through the world-wide-web, please send an email             |
 | to license@phalconphp.com so we can send you a copy immediately.       |
 +------------------------------------------------------------------------+
 | Authors: Andres Gutierrez <andres@phalconphp.com>                      |
 |          Eduar Carvajal <eduar@phalconphp.com>                         |
 +------------------------------------------------------------------------+
 */

namespace Phalcon\Config\Adapter;

use Phalcon\Config;
use Phalcon\Factory\Exception;
use Phalcon\Config\Factory;

/**
 * Phalcon\Config\Adapter\Grouped
 *
 * Reads multiple files (or arrays) and merges them all together.
 *
 *<code>
 * $config = new \Phalcon\Config\Adapter\Grouped(
 *    ["path/to/config.php", "path/to/config.dist.php"]
 * );
 *</code>
 *
 *<code>
 * $config = new \Phalcon\Config\Adapter\Grouped(
 *    ["path/to/config.json", "path/to/config.dist.json"],
 *    "json"
 * );
 *</code>
 *
 *<code>
 * $config = new \Phalcon\Config\Adapter\Grouped(
 *    [
 *        [
 *            "filePath" => "path/to/config.php",
 *            "adapter"  => "php""path/to/config.dist.php"
 *        ],
 *        [
 *            "filePath" => "path/to/config.json",
 *            "adapter"  => "json"
 *        ],
 *        [
 *            "adapter"  => "array",
 *            "config"   => [
 *                "property" => "value"
 *            ]
 *        ],
 * );
 *</code>
 */
class Grouped extends Config
{

	/**
	 * Phalcon\Config\Adapter\Grouped constructor
	 */
	public function __construct(array! arrayConfig, string! defaultAdapter = "php")
	{
		var configName, configInstance, adapterName, configArray;

		parent::__construct([]);

		for configName in arrayConfig {
		    let configInstance = configName;

		    //Set To Default Adapter If Passed As String
		    if typeof configName === "string" {
		        let configInstance = ["filePath" : configName, "adapter" : defaultAdapter];
		    } elseif !isset(configInstance["adapter"]) {
		        let configInstance["adapter"] = defaultAdapter;
		    }

            if configInstance["adapter"] === "array" {
                if !isset(configInstance["config"]) {
                    throw new Exception("Config Array Not Specified");
                }

                let configArray    = configInstance["config"];
                let configInstance = new Config(configArray);
            } else {
                let configInstance = Factory::load(configInstance);
            }

            this->_merge(configInstance);
		}
	}
}