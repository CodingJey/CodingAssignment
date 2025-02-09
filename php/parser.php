<?php
class CompanyClass
{
    public function normalizeCompanyData(array $data): ?array {
        $normalizedData = [];
        if (!$this->isCompanyDataPresent($data)) {
            return null;
        }

        $normalizedData['name'] = $this->normalizeName($data['name']);

        $cleanWebsite =  $this->normalizeWebsite($data['website']);
        
        if (preg_match('/^https?:\/\/(?!\/)/i', $cleanWebsite)) {
            $normalizedData['website'] = parse_url($cleanWebsite, PHP_URL_HOST);

            if ($normalizedData['website'] === null) { // Used '===' for strict comparison
                unset($normalizedData['website']);
            }
        } else{
            throw new Exception("Given website is incorrect");
        }

        $normalizedData['website'] = $cleanWebsite;
        

        $normalizedData['address'] = $this->normalizeAddress($data['address']);
        
        return $normalizedData;
    }

    private function isCompanyDataPresent(array $data): bool {
        if (isset($data[''])) {
            return false;
        }

        //if the ammount of fields were to increase refactor by implementing a foreach field of array instead of hard coding
        if(isset($data['name']) &&
            isset($data['website']) &&
            isset($data['address'])){
            return true;
        }  
        return false;
    }
    private function normalizeName(string $name): string {
        if(ctype_space($name)){
            throw new Exception("The field Name is only whitespaces");
        }
        
        $name = strtolower(trim($name));
        return $name;
    }

    private function normalizeWebsite(string $website): string {
        if(ctype_space($website)){
            throw new Exception("The field Website is only whitespaces");
        }
        
        $website = strtolower(trim($website));
        return $website;
    }

    private function normalizeAddress(string $adress): string {
        if(ctype_space($adress or empty($normalizedData['address']))){
            return null;
        }
        
        $adress = trim($adress);
        return $adress;
    }
}

// Test Data
$input = [
'name' => ' OpenAI ',
'website' => 'https://openai.com ',
'address' => ' '
];
$input2 = [
'name' => 'Innovatiespotter',
'address' => 'Groningen'
];
$input3 = [
'name' => ' Apple ',
'website' => 'xhttps://apple.com ',
];

$input4 = [
    'name' => ' OpenAI ',
    'website' => 'https://openai.com ',
    'address' => 'amsterdam road'
    ];
$company = new CompanyClass();
$result = $company->normalizeCompanyData($input);
var_dump($result);
$result2 = $company->normalizeCompanyData($input2);

var_dump($result2);
$result3 = $company->normalizeCompanyData($input3);
var_dump($result3);
$result4 = $company->normalizeCompanyData($input4);
var_dump($result4);